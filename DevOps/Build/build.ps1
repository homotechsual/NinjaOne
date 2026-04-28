# requires -Version 7.0
<#
	.SYNOPSIS
		Homotechsual portable module build script.
#>
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseCompatibleSyntax', '', Justification = 'Script runs in CI/CD pipelines and is not designed to run on old versions.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal DevOps script does not require parameter descriptions.')]

param (
	[ValidateSet('clean', 'build', 'updateManifest', 'publish', 'publishDocs', 'publishDevDocs', 'updateHelp', 'generateShortNamesMapping', 'push')]
	[String[]]$taskNames = ('clean', 'build', 'updateManifest', 'publish', 'updateHelp', 'generateShortNamesMapping', 'push'),
	[Hashtable]$BuildConfig = (
		Join-Path -Path $PSScriptRoot -ChildPath 'build.config.psd1' | Import-PowerShellDataFile -LiteralPath { $_ } -ErrorAction SilentlyContinue
	),
	[Switch]$excludeCustomTasks = $false,
	[System.Management.Automation.SemanticVersion]$semVer
)
$BuildToolsRoot = $PSScriptRoot
$RepoRoot = Resolve-Path -Path (Join-Path -Path $BuildToolsRoot -ChildPath '..\..')
$Script:ModuleName = 'NinjaOne'
$Script:DocsSourcePath = Join-Path -Path $RepoRoot -ChildPath 'docs\NinjaOne\commandlets'
$Script:DevDocsSourcePath = Join-Path -Path $RepoRoot -ChildPath 'docs\NinjaOne\development'

function Invoke-IsolatedBuildIfNeeded {
	param(
		[string[]]$taskNames,
		[switch]$excludeCustomTasks,
		[System.Management.Automation.SemanticVersion]$semVer
	)

	if ($env:NINJAONE_BUILD_ISOLATED_CHILD) {
		return
	}

	if ($taskNames -notcontains 'clean' -and $taskNames -notcontains 'build') {
		return
	}

	$escapedScriptPath = $PSCommandPath.Replace("'", "''")
	$taskList = ($taskNames | ForEach-Object { "'$($_.Replace("'", "''"))'" }) -join ','
	$command = "`$env:NINJAONE_BUILD_ISOLATED_CHILD='1'; & '$escapedScriptPath' -taskNames @($taskList)"
	if ($excludeCustomTasks) {
		$command += ' -excludeCustomTasks'
	}
	if ($semVer) {
		$command += " -semVer '$semVer'"
	}

	$argList = @(
		'-NoProfile',
		'-ExecutionPolicy', 'Bypass',
		'-Command', $command
	)

	Write-Verbose 'Running isolated build (clean/build)...'
	$proc = Start-Process -FilePath 'pwsh' -ArgumentList $argList -Wait -NoNewWindow -PassThru
	exit $proc.ExitCode
}

Invoke-IsolatedBuildIfNeeded -taskNames $taskNames -excludeCustomTasks:$excludeCustomTasks -semVer $semVer
# Install required modules
if (-not (Get-Command -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue)) {
	Install-Script -Name 'Install-RequiredModule' -Force -Scope CurrentUser
}

$installCmd = Get-Command -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue
if (-not $installCmd) {
	$installedScript = Get-InstalledScript -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue
	if ($installedScript) {
		$installCmdPath = Join-Path -Path $installedScript.InstalledLocation -ChildPath 'Install-RequiredModule.ps1'
	}
} else {
	if ($installCmd.Path) {
		$installCmdPath = $installCmd.Path
	} elseif ($installCmd.Source -and (Test-Path $installCmd.Source)) {
		$installCmdPath = $installCmd.Source
	}
}

if (-not $installCmdPath) {
	$userDocs = [Environment]::GetFolderPath('MyDocuments')
	$fallbackPaths = @(
		(Join-Path -Path $userDocs -ChildPath 'PowerShell\Scripts\Install-RequiredModule.ps1'),
		(Join-Path -Path $userDocs -ChildPath 'WindowsPowerShell\Scripts\Install-RequiredModule.ps1')
	)
	$installCmdPath = $fallbackPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $installCmdPath) {
	throw 'Install-RequiredModule script not found. Ensure it is installed and on PATH.'
}

& $installCmdPath -RequiredModulesFile ('{0}\RequiredModules.psd1' -f $BuildToolsRoot) -Scope CurrentUser -TrustRegisteredRepositories -Import -Quiet
# Alt3.Docusaurus.PowerShell is imported via the RequiredModules script above
# Use strict mode when building.
Set-StrictMode -Version Latest
# Helper: Get the module PSD1 file path.
function GetModulePath {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[String]$moduleName
	)
	$moduleManifest = Get-ChildItem -Path ('{0}\Output\*\*\{1}.psd1' -f $RepoRoot, $moduleName) -ErrorAction SilentlyContinue |
	Sort-Object { [version]$_.Directory.Name } -Descending |
	Select-Object -First 1
	$ModulePath = $moduleManifest.FullName
	if (!(Test-Path -Path $ModulePath)) {
		throw ('Module {0} not found at "{1}".' -f $moduleName, $ModulePath)
	}
	return $ModulePath
}
# Helper: Get functions from the module.
function GetFunctions {
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List[String]])]
	param(
		[Parameter(Mandatory)]
		[String]$moduleName
	)
	$ModulePath = GetModulePath -moduleName $moduleName
	Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
	$Module = Import-Module $ModulePath -Force -PassThru
	$CommandletList = [System.Collections.Generic.List[String]]::new()
	foreach ($exportedFunction in $Module.ExportedFunctions.Keys) {
		$null = $CommandletList.Add([string]$exportedFunction)
	}
	return $CommandletList
}
# Task: Push to remote repositories.
function Push {
	[CmdletBinding()]
	param(
		[Parameter()]
		[String[]]$Remotes = @('origin', 'homotechsual')
	)
	# Push to remote repositories.
	foreach ($Remote in $Remotes) {
		Start-Process -FilePath 'git' -ArgumentList @('push', $Remote) -Wait -NoNewWindow
		Start-Process -FilePath 'git' -ArgumentList @('push', $Remote, '--tags') -Wait -NoNewWindow
	}
}
# Task: (Re)Generate the mapping file for the short names of the commandlets. Stored in the Functionality item of the comment based help. The file will be stored in .\.build\CommandletShortNames.yaml
## Requires YAYAML installed.
function GenerateShortNamesMapping {
	<#
	.SYNOPSIS
		Generate short names mapping for commandlets.
	.DESCRIPTION
		Generates a YAML mapping file containing commandlet short names from the Functionality metadata in comment-based help.
		The output file is stored at .\build\CommandletShortNames.yaml.
	.NOTES
		Requires YAYAML module to be installed.
	#>
	$OutputFilePath = [System.IO.FileInfo]'.\.build\CommandletShortNames.yaml'
	$ShortNameOutput = [System.Collections.Generic.Dictionary[String, String]]::new()
	$CommandletList = GetFunctions -moduleName $Script:ModuleName
	foreach ($Commandlet in $CommandletList) {
		$AST = (Get-Content -Path ('function:/{0}' -f $Commandlet) -ErrorAction Ignore).AST
		$ShortName = $AST.GetHelpContent().Functionality
		if ($ShortName) {
			$ShortNameOutput.Add($Commandlet, $ShortName)
		} else {
			throw ('Commandlet {0} does not have a short name.' -f $Commandlet)
		}
	}
	if ($ShortNameOutput.Count -eq $CommandletList.Count) {
		$ShortNameOutput | ConvertTo-Yaml | Out-File -FilePath $OutputFilePath -Force
	} else {
		$CommandletList | Where-Object { -not $ShortNameOutput.ContainsKey($_) } | ForEach-Object { WriteMessage ('Commandlet {0} not present in the short name list.' -f $_) -Category Warning }
		throw 'Not all commandlets have a short name.'
	}
}
# Task: Update the PowerShell Module Help Files.
## Requires PlatyPS, Pester, PSScriptAnalyzer and Alt3.Docusaurus.PowerShell installed.
function UpdateHelp {
	<#
	.SYNOPSIS
		Update PowerShell module help files.
	.DESCRIPTION
		Updates the PowerShell Module Help Files using PlatyPS, generating markdown documentation from comment-based help.
		Generates docs in the specified Docusaurus path.
	.PARAMETER DocusaurusPath
		Path to the Docusaurus documentation directory. Defaults to '.\docs'.
	.PARAMETER ForceUpdateCategoryFiles
		Force update of category files. Defaults to $true.
	.NOTES
		Requires PlatyPS, Pester, PSScriptAnalyzer, and Alt3.Docusaurus.PowerShell modules.
	#>
	[CmdletBinding()]
	param (
		[System.IO.DirectoryInfo]$DocusaurusPath = '.\docs',
		[bool]$ForceUpdateCategoryFiles = $true
	)
	$DocsFolderPath = Join-Path -Path $DocusaurusPath -ChildPath $Script:ModuleName
	if (-not(Test-Path -Path $DocsFolderPath)) {
		New-Item -Path $DocsFolderPath -ItemType Directory | Out-Null
	}
	$bundledDocusaurusRoot = Join-Path -Path $RepoRoot -ChildPath 'Modules\Alt3.Docusaurus.Powershell'
	if (Test-Path -Path $bundledDocusaurusRoot) {
		$bundledManifest = Get-ChildItem -Path $bundledDocusaurusRoot -Filter 'Alt3.Docusaurus.Powershell.psd1' -Recurse | Sort-Object FullName -Descending | Select-Object -First 1
		if ($bundledManifest) {
			Import-Module -Name $bundledManifest.FullName -Force -ErrorAction Stop
		}
	}
	$ShortNamesFilePath = [System.IO.FileInfo]'.\.build\CommandletShortNames.yaml'
	$ShortNamesYAML = Get-Content -Path $ShortNamesFilePath -Raw
	$ShortNamesDictionary = $ShortNamesYAML | ConvertFrom-Yaml
	$MarkdownHeader = @'
:::powershell[Generated Cmdlet Help]
This page has been generated from the {0} PowerShell module source. To make changes please edit the appropriate PowerShell source file.
:::
'@ -f $Script:ModuleName
	$ExcludeFiles = Get-ChildItem -Path (Join-Path -Path $RepoRoot -ChildPath 'Source\Private') -Filter '*.ps1' -Recurse | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }
	$NewDocusaurusHelpParams = @{
		Module = (GetModulePath -moduleName $Script:ModuleName)
		DocsFolder = $DocsFolderPath
		Exclude = $ExcludeFiles
		Sidebar = 'commandlets'
		# MetaDescription = 'Generated cmdlet help for the %1 commandlet.'
		GroupByVerb = $true
		NoPlaceHolderExamples = $true
		UseCustomShortTitles = $true
		ShortTitles = $ShortNamesDictionary
		PrependMarkdown = $MarkdownHeader
		RemoveParameters = @('-ProgressAction', '-FakeParam')
	}
	New-DocusaurusHelp @NewDocusaurusHelpParams | Out-Null
	$CommandletDocsFolder = Join-Path -Path $DocusaurusPath -ChildPath $Script:ModuleName -AdditionalChildPath 'commandlets'
	$VerbFolders = Get-ChildItem -Path $CommandletDocsFolder -Directory
	$CategoryFileBase = @{
		position = 1
		collapsible = $true
		collapsed = $true
		label = ''
		className = ''
		link = @{
			type = 'generated-index'
			title = ''
		}
		customProps = @{
			description = ''
		}
	}
	foreach ($VerbFolder in $VerbFolders) {
		$HasCategoryFile = Get-ChildItem -Path $VerbFolder.FullName -Filter '_category_.*' -File -ErrorAction SilentlyContinue
		$CategoryFilePath = Join-Path -Path $VerbFolder.FullName -ChildPath '_category_.json'
		# Start with a fresh copy so each verb gets its own object
		$CategoryFile = $CategoryFileBase | ConvertTo-Json -Depth 5 | ConvertFrom-Json
		switch ($VerbFolder.Name) {
			'Connect' {
				$CategoryFile.label = 'Connect to Services'
				$CategoryFile.position = 0.1
				$CategoryFile.collapsed = $false
				$CategoryFile.className = 'category-connect'
				$CategoryFile.link.title = 'Connect to Services'
				$CategoryFile.customProps.description = 'This category contains commands for connecting to services, retrieving and storing credentials and managing connections.'
			}
			'Find' {
				$CategoryFile.label = 'Find Information'
				$CategoryFile.position = 0.2
				$CategoryFile.className = 'category-find'
				$CategoryFile.link.title = 'Find Information'
				$CategoryFile.customProps.description = 'This category contains commands for finding information from services, this may include data, objects, settings and more.'
			}
			'Get' {
				$CategoryFile.label = 'Retrieve Information'
				$CategoryFile.position = 0.3
				$CategoryFile.className = 'category-get'
				$CategoryFile.link.title = 'Retrieve Information'
				$CategoryFile.customProps.description = 'This category contains commands for retrieving information from services, this may include data, objects, settings and more.'
			}
			'Invoke' {
				$CategoryFile.label = 'Invoke Actions'
				$CategoryFile.position = 0.4
				$CategoryFile.className = 'category-invoke'
				$CategoryFile.link.title = 'Invoke Actions'
				$CategoryFile.customProps.description = 'This category contains commands for invoking actions, this may include running scripts, executing commands and more. For API modules, this category will contain commands for sending arbitrary requests to the API - that is requests not covered by existing commands.'
			}
			'New' {
				$CategoryFile.label = 'Create Data'
				$CategoryFile.position = 0.5
				$CategoryFile.className = 'category-new'
				$CategoryFile.link.title = 'Create Data'
				$CategoryFile.customProps.description = 'This category contains commands for creating data, objects, settings and more.'
			}
			'Remove' {
				$CategoryFile.label = 'Remove Data'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-remove'
				$CategoryFile.link.title = 'Remove Data'
				$CategoryFile.customProps.description = 'This category contains commands for removing data, objects, settings and more.'
			}
			'Reset' {
				$CategoryFile.label = 'Reset State'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-reset'
				$CategoryFile.link.title = 'Reset State'
				$CategoryFile.customProps.description = 'This category contains commands for resetting state, this may include resetting settings, connections and more.'
			}
			'Restart' {
				$CategoryFile.label = 'Restart Services'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-restart'
				$CategoryFile.link.title = 'Restart Services'
				$CategoryFile.customProps.description = 'This category contains commands for restarting services, this may include restarting services, processes and more.'
			}
			'Restore' {
				$CategoryFile.label = 'Restore Data'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-restore'
				$CategoryFile.link.title = 'Restore Data'
				$CategoryFile.customProps.description = 'This category contains commands for restoring data, objects, settings and more. These commands will primarily be used for restoring data to a previous state.'
			}
			'Set' {
				$CategoryFile.label = 'Update Data (Set)'
				$CategoryFile.position = 0.4
				$CategoryFile.className = 'category-set'
				$CategoryFile.link.title = 'Update Data (Set)'
				$CategoryFile.customProps.description = 'This category contains commands for updating data, objects, settings and more. This category will overlap with the Update category.'
			}
			'Update' {
				$CategoryFile.label = 'Update Data (Update)'
				$CategoryFile.position = 0.4
				$CategoryFile.className = 'category-update'
				$CategoryFile.link.title = 'Update Data (Update)'
				$CategoryFile.customProps.description = 'This category contains commands for updating data, objects, settings and more. This category will overlap with the Set category.'
			}
			'Add' {
				$CategoryFile.label = 'Add Data'
				$CategoryFile.position = 0.5
				$CategoryFile.className = 'category-add'
				$CategoryFile.link.title = 'Add Data'
				$CategoryFile.customProps.description = 'This category contains commands for adding or appending data, objects, settings and more.'
			}
			'Merge' {
				$CategoryFile.label = 'Merge Data'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-merge'
				$CategoryFile.link.title = 'Merge Data'
				$CategoryFile.customProps.description = 'This category contains commands for merging data, objects, settings and more.'
			}
			'Move' {
				$CategoryFile.label = 'Move Data'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-move'
				$CategoryFile.link.title = 'Move Data'
				$CategoryFile.customProps.description = 'This category contains commands for moving data, objects, settings and more.'
			}
			'Start' {
				$CategoryFile.label = 'Start Services'
				$CategoryFile.position = 0.5
				$CategoryFile.className = 'category-start'
				$CategoryFile.link.title = 'Start Services'
				$CategoryFile.customProps.description = 'This category contains commands for starting services, processes and more.'
			}
			'Rename' {
				$CategoryFile.label = 'Rename Data'
				$CategoryFile.position = 0.6
				$CategoryFile.className = 'category-rename'
				$CategoryFile.link.title = 'Rename Data'
				$CategoryFile.customProps.description = 'This category contains commands for renaming data, objects, settings and more.'
			}
		}
		if (-not($HasCategoryFile)) {
			$CategoryFile | ConvertTo-Json | Out-File -FilePath $CategoryFilePath -Force
		} else {
			if (-not($ForceUpdateCategoryFiles)) {
				Write-Warning -Message ('Category file already exists in "{0}" verb folder. Use the ForceUpdateCategoryFiles switch to overwrite existing category files.' -f $VerbFolder.Name)
			} else {
				Set-Content -Path $CategoryFilePath -Value ($CategoryFile | ConvertTo-Json) -Force
			}
		}
	}
}
# Task: Build the PowerShell Module
function Build {
	<#
	.SYNOPSIS
		Build the PowerShell module.
	.DESCRIPTION
		Builds the PowerShell module from source files, with optional semantic versioning.
		Verifies that output binaries are not locked before the build proceeds.
	.NOTES
		Uses Invoke-Build with the Source directory as input.
	#>
	$outputDirConfig = $BuildConfig.OutputDirectory ?? 'output'
	# ModuleBuilder creates output relative to the Source directory
	$moduleOutputRoot = Join-Path -Path $RepoRoot -ChildPath $outputDirConfig
	$moduleOutputPath = Join-Path -Path $moduleOutputRoot -ChildPath $Script:ModuleName
	AssertOutputBinariesUnlocked -outputPath $moduleOutputPath

	if ($semVer) {
		Build-Module -path '.\Source' -SemVer $semVer.ToString() -Prefix 'Initialisation.ps1'
	} else {
		Build-Module -path '.\Source' -Prefix 'Initialisation.ps1'
	}

	# Ensure Binaries folder is copied to output module (post-build step)
	# Find all module manifest files (which tells us where the module was built)
	$moduleManifests = Get-ChildItem -Path './Output' -Recurse -Filter '*.psd1' -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'NinjaOne.psd1' -and $_.Directory.Name -match '^[\d\.]' }
	
	foreach ($manifest in $moduleManifests) {
		$moduleDir = $manifest.Directory.FullName
		$binariesDir = Join-Path -Path $moduleDir -ChildPath 'Binaries'
		
		if ((Test-Path '.\Source\Binaries') -and (-not (Test-Path $binariesDir))) {
			Copy-Item -Path '.\Source\Binaries' -Destination $binariesDir -Recurse -Force
			Write-Host "✓ Copied Binaries folder to: $binariesDir" -ForegroundColor Green
		}
	}
	
	# Restore Prerelease field to Output manifests if it exists in Source (ModuleBuilder strips it)
	$sourceManifestPath = Join-Path -Path $RepoRoot -ChildPath (Join-Path -Path 'Source' -ChildPath "$Script:ModuleName.psd1")
	$sourceManifest = Import-PowerShellDataFile -Path $sourceManifestPath
	if ($sourceManifest.PrivateData.PSData.Prerelease) {
		$prerelease = $sourceManifest.PrivateData.PSData.Prerelease
		Write-Host "Restoring Prerelease = '$prerelease' to output manifests" -ForegroundColor Gray
		foreach ($manifest in $moduleManifests) {
			(Get-Content $manifest.FullName) -replace "Prerelease = ''", "Prerelease = '$prerelease'" | Set-Content $manifest.FullName
		}
	}
}

# Helper: ensure output binaries are not locked before rebuild.
function AssertOutputBinariesUnlocked {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$outputPath
	)

	if (-not (Test-Path $outputPath)) {
		return
	}
	$resolvedOutputPath = (Resolve-Path -Path $outputPath).Path

	$locked = [System.Collections.Generic.List[string]]::new()
	$processInfo = [System.Collections.Generic.List[string]]::new()
	$dlls = Get-ChildItem -Path $resolvedOutputPath -Filter '*.dll' -Recurse -ErrorAction SilentlyContinue
	Write-Verbose ('Checking output DLL locks in {0}' -f $resolvedOutputPath)
	if (-not $dlls) {
		return
	}
	$dlls | ForEach-Object {
		$originalPath = $_.FullName
		Get-Process -ErrorAction SilentlyContinue | ForEach-Object {
			$proc = $_
			try {
				if ($proc.Modules | Where-Object { $_.FileName -eq $originalPath }) {
					$processInfo.Add("$($proc.ProcessName)($($proc.Id)) -> $originalPath")
				}
			} catch {
				Write-Verbose -Message "Unable to inspect process $($proc.ProcessName): $_"
			}
		}
	}

	$dlls | ForEach-Object {
		try {
			$originalPath = $_.FullName
			$tempPath = "$originalPath.lockcheck"
			Move-Item -Path $originalPath -Destination $tempPath -ErrorAction Stop
			Move-Item -Path $tempPath -Destination $originalPath -ErrorAction Stop
		} catch {
			$locked.Add($_.FullName)
		}
	}

	if ($locked.Count -gt 0 -or $processInfo.Count -gt 0) {
		if ($locked.Count -gt 0) {
			$details = $locked -join '; '
		} else {
			$details = 'None detected by rename check'
		}
		if ($processInfo.Count -gt 0) {
			$procDetails = $processInfo -join '; '
		} else {
			$procDetails = 'Unknown process'
		}
		throw "Build output DLLs are in use. Close any process using these files and retry. Locked: $details. Processes: $procDetails"
	}
}
# Task: Update the Module Manifest file with info from the Changelog.
function UpdateManifest {
	<#
	.SYNOPSIS
		Update module manifest from changelog.
	.DESCRIPTION
		Updates the PowerShell module manifest file with version information and release notes
		extracted from the CHANGELOG.md file.
	.NOTES
		Requires PlatyPS module for parsing changelog versions.
		Throws an error if no new version is found in CHANGELOG.md.
	#>
	# Import PlatyPS. Needed for parsing the versions in the Changelog.
	Import-Module -Name PlatyPS
	# Find Latest Version in Change log.
	$CHANGELOG = Get-Content -Path "$($RepoRoot)\CHANGELOG.md"
	$MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
	[regex]$Regex = '\d\.\d\.\d'
	$Versions = $Regex.Matches($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) | ForEach-Object { $_.Value }
	$ChangeLogVersion = ($Versions | Measure-Object -Maximum).Maximum
	$ManifestPath = Join-Path -Path $RepoRoot -ChildPath (Join-Path -Path 'Source' -ChildPath "$Script:ModuleName.psd1")
	# Read the manifest as a hashtable to determine the current version
	$Manifest = Import-PowerShellDataFile -Path $ManifestPath
	[System.Version]$Version = $Manifest.ModuleVersion

	if ($ChangeLogVersion -eq $Version) {
		throw 'No new version found in CHANGELOG.md'
	}
	Write-Output -InputObject ("Current Module Version: $($Version)")
	Write-Output -InputObject ("New Module version: $($ChangeLogVersion)")
	# Update Manifest file with Release Notes
	$CHANGELOG = Get-Content -Path "$($RepoRoot)\CHANGELOG.md"
	$MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
	$ReleaseNotes = ((($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) -match '\d\.\d\.\d') -split ' - ')[1]
	
	# Save original Prerelease value before Update-ModuleManifest clears it
	$OriginalPrerelease = $Manifest.PrivateData.PSData.Prerelease
	
	# Update Module with new version
	Update-ModuleManifest -ModuleVersion $ChangeLogVersion -Path $ManifestPath -ReleaseNotes $ReleaseNotes
	
	# Restore Prerelease field if it existed in source manifest
	if ($OriginalPrerelease) {
		Write-Output "Restoring Prerelease field: $OriginalPrerelease"
		# Restore in Source manifest
		(Get-Content $ManifestPath) -replace "Prerelease = ''", "Prerelease = '$OriginalPrerelease'" | Set-Content $ManifestPath
		
		# Also restore in Output manifest if it exists (from previous build)
		$OutputManifestPath = Get-ChildItem -Path (Join-Path -Path $RepoRoot -ChildPath 'output\*\*\NinjaOne.psd1') -ErrorAction SilentlyContinue | Select-Object -First 1
		if ($OutputManifestPath) {
			Write-Output "Restoring Prerelease in output manifest: $($OutputManifestPath.FullName)"
			(Get-Content $OutputManifestPath.FullName) -replace "Prerelease = ''", "Prerelease = '$OriginalPrerelease'" | Set-Content $OutputManifestPath.FullName
		}
	}
}
# Task: Publish Module to PowerShell Gallery
function Publish {
	[CmdletBinding()]
	param()
	try {
		# Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
		$PublishParams = @{
			Path = Join-Path -Path $RepoRoot -ChildPath 'output\*\*\*.psd1' | Get-Item | Where-Object { $_.BaseName -eq $_.Directory.Parent.Name } | Select-Object -ExpandProperty Directory
			NuGetApiKey = if ($ENV:PSGalleryAPIKey) {
				$ENV:PSGalleryAPIKey
			} elseif ($ENV:TF_BUILD) {
				$ENV:PSGalleryAPIKey
			} else {
				Get-AzKeyVaultSecret -VaultName $ENV:PSGalleryVault -Name $ENV:PSGallerySecret -AsPlainText
			}
			ErrorAction = 'Stop'
		}
		$ManifestPath = Get-ChildItem -Path $PublishParams.Path -Filter '*.psd1'
		$Manifest = Test-ModuleManifest -Path $ManifestPath
		if ($Manifest.PrivateData.PSData.Prerelease) {
			[System.Management.Automation.SemanticVersion]$Version = ('{0}-{1}' -f $Manifest.Version, $Manifest.PrivateData.PSData.Prerelease)
		} else {
			[System.Management.Automation.SemanticVersion]$Version = $Manifest.Version
		}
		Publish-Module @PublishParams
		Write-Output -InputObject ("$Script:ModuleName PowerShell Module version $($Version.ToString()) published to the PowerShell Gallery")
	} catch {
		throw $_
	}
}

# Task: Export docs for publishing (local file ops only)
# Note: GitHub Actions workflow will handle git commit and push to remote repo
function UpdateInstanceEndpointDriftDevDoc {
	<#
	.SYNOPSIS
		Generates an MDX development doc page for instance endpoint drift.
	.DESCRIPTION
		Runs the instance capability drift check script when available, then writes a
		development doc page with frontmatter and the latest drift summary content.
		If live collection fails, the page still renders with guidance and the last
		available report data when present.
	.PARAMETER DocsPath
		Path to the development docs folder where the generated MDX file is written.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string]$docsPath = $Script:DevDocsSourcePath
	)

	$checkScriptPath = Join-Path -Path $RepoRoot -ChildPath 'DevOps\Quality\check-instance-capabilities.ps1'
	$reportJsonPath = Join-Path -Path $RepoRoot -ChildPath '.artifacts\instance-capability-report.json'
	$reportMarkdownPath = [System.IO.Path]::ChangeExtension($reportJsonPath, '.md')
	$devDocPath = Join-Path -Path $docsPath -ChildPath 'instance-endpoint-drift.mdx'
	$generatedAt = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ss')
	$collectionError = $null

	if (Test-Path -Path $checkScriptPath -PathType Leaf) {
		try {
			& $checkScriptPath -outputPath $reportJsonPath
		} catch {
			$collectionError = $_.Exception.Message
			WriteMessage -message 'Instance drift collection did not complete with live data' -Category Warning -details $collectionError
		}
	} else {
		$collectionError = 'check-instance-capabilities.ps1 script not found.'
		WriteMessage -message 'Instance drift collection script not found' -Category Warning -details $checkScriptPath
	}

	if (-not (Test-Path -Path $docsPath)) {
		New-Item -Path $docsPath -ItemType Directory -Force | Out-Null
	}

	$docLines = [System.Collections.Generic.List[string]]::new()
	$docLines.Add('---') | Out-Null
	$docLines.Add('title: Instance Endpoint Drift') | Out-Null
	$docLines.Add('sidebar_position: 7') | Out-Null
	$docLines.Add('---') | Out-Null
	$docLines.Add('') | Out-Null
	$docLines.Add('This page is generated by `DevOps/Build/build.ps1` during docs publishing.') | Out-Null
	$docLines.Add('It summarizes endpoint differences between tracked NinjaOne instances and repository/cmdlet coverage.') | Out-Null
	$docLines.Add('') | Out-Null
	$docLines.Add(('Last generated (UTC): `{0}`' -f $generatedAt)) | Out-Null

	if (Test-Path -Path $reportMarkdownPath -PathType Leaf) {
		$docLines.Add('') | Out-Null
		$docLines.Add('## Latest Drift Snapshot') | Out-Null
		$docLines.Add('') | Out-Null
		$reportLines = @(Get-Content -Path $reportMarkdownPath)
		foreach ($line in $reportLines) {
			if ($line -match '^#\s+') {
				$docLines.Add(('## {0}' -f ($line -replace '^#\s+', ''))) | Out-Null
			} elseif ($line -match '^##\s+') {
				$docLines.Add(('### {0}' -f ($line -replace '^##\s+', ''))) | Out-Null
			} elseif ($line -match '^###\s+') {
				$docLines.Add(('#### {0}' -f ($line -replace '^###\s+', ''))) | Out-Null
			} else {
				$docLines.Add($line) | Out-Null
			}
		}
	}

	if ($collectionError) {
		$docLines.Add('') | Out-Null
		$docLines.Add(':::note') | Out-Null
		$docLines.Add('Live drift collection did not complete during this build. The page includes the last available report content when present.') | Out-Null
		$docLines.Add(('Error: `{0}`' -f $collectionError)) | Out-Null
		$docLines.Add(':::') | Out-Null
	}

	Set-Content -Path $devDocPath -Value $docLines -Encoding UTF8
	WriteMessage -message 'Generated instance drift development doc' -Category Success -details $devDocPath
}

function PublishDocsTask {
	<#
	.SYNOPSIS
		Export documentation for publishing.
	.DESCRIPTION
		Wrapper task that exports generated documentation for publishing.
		Performs local file operations only; GitHub Actions workflow handles git operations.
	.NOTES
		Called during the build process to prepare docs for external publishing.
	#>
	[CmdletBinding()]
	param()
	PublishDocs -docsOutputPath $docsOutputPath
}

# Task: Export development docs for publishing (local file ops only)
# Note: GitHub Actions workflow will handle git commit and push to remote repo
function PublishDevDocsTask {
	<#
	.SYNOPSIS
		Export development documentation for publishing.
	.DESCRIPTION
		Wrapper task that exports generated development docs for publishing.
		Performs local file operations only; GitHub Actions workflow handles git operations.
	#>
	[CmdletBinding()]
	param()
	PublishDevDocs -docsOutputPath $docsOutputPath
}

# Task: Export docs for publishing to external repo
# Purpose: Copies generated docs to output directory for workflow to push to remote
# GitHub Actions Workflow Integration:
#   - Run this task to generate docs at: .\.build\docs\docs\ninjaone\commandlets
#   - Workflow will checkout homotechsualdocs repo on dev branch
#   - Workflow will replace docs\ninjaone\commandlets with output from this task
#   - Workflow will commit and push with GITHUB_TOKEN (automatic in GitHub Actions)
function PublishDocs {
	<#
	.SYNOPSIS
		Export docs for publishing to external repository.
	.DESCRIPTION
		Copies generated documentation to the output directory for GitHub Actions workflow to push to remote repository.
		Integrates with GitHub Actions to automatically commit and push documentation updates.
	.PARAMETER DocsOutputPath
		Path where generated documentation will be exported. Optional parameter.
	.NOTES
		GitHub Actions workflow will handle git commit and push operations.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string]$docsOutputPath
	)

	if (-not $docsOutputPath) {
		$docsOutputPath = Join-Path -Path $RepoRoot -ChildPath '.build\docs'
	}

	# Create output structure matching target repo path: docs/ninjaone/commandlets
	$destPath = Join-Path -Path $docsOutputPath -ChildPath 'docs\ninjaone\commandlets'
	if (Test-Path $destPath) {
		Remove-Item -Path $destPath -Recurse -Force
	}
	New-Item -Path $destPath -ItemType Directory -Force | Out-Null

	# Copy generated docs to output
	Copy-Item -Path $Script:DocsSourcePath\* -Destination $destPath -Recurse -Force

	WriteMessage -message 'Docs exported to output directory' -details $destPath -Category Success
	WriteMessage -message 'Next step: GitHub Actions workflow will push these commandlet docs to homotechsualdocs/dev' -Category Information
}

# Task: Export development docs for publishing to external repo
function PublishDevDocs {
	<#
	.SYNOPSIS
		Export development docs for publishing to external repository.
	.DESCRIPTION
		Generates development documentation content and copies it to the output
		directory for GitHub Actions workflow to push to the development docs job.
	.PARAMETER DocsOutputPath
		Path where generated development documentation will be exported. Optional parameter.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string]$docsOutputPath
	)

	if (-not $docsOutputPath) {
		$docsOutputPath = Join-Path -Path $RepoRoot -ChildPath '.build\docs'
	}

	UpdateInstanceEndpointDriftDevDoc -docsPath $Script:DevDocsSourcePath

	$devDocsDestPath = Join-Path -Path $docsOutputPath -ChildPath 'docs\ninjaone\development'
	if (Test-Path $devDocsDestPath) {
		Remove-Item -Path $devDocsDestPath -Recurse -Force
	}
	New-Item -Path $devDocsDestPath -ItemType Directory -Force | Out-Null
	Copy-Item -Path $Script:DevDocsSourcePath\* -Destination $devDocsDestPath -Recurse -Force

	WriteMessage -message 'Development docs exported to output directory' -details $devDocsDestPath -Category Success
	WriteMessage -message 'Next step: GitHub Actions workflow will push these development docs in their dedicated job' -Category Information
}
# Task: Clean up Output folder
function Clean {
	# Clean output folder
	$moduleOutput = Join-path -path $RepoRoot -ChildPath ('output\{0}\*\Binaries' -f $Script:ModuleName)
	AssertOutputBinariesUnlocked -outputPath $moduleOutput
	if ((Test-path "$($RepoRoot)\Build")) {
		Remove-Item -path "$($RepoRoot)\Build" -Recurse -Force
	}
}
# Helper: Write a message to the console.
function WriteMessage {
	[CmdletBinding()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Script is not intended to be used as a module.')]
	param (
		# The message to write to the console.
		[Parameter(Mandatory, ValueFromPipeline)]
		[String]$message,
		# The category of the message.
		[ValidateSet('Information', 'Warning', 'Error', 'Success')]
		[String]$Category = 'Information',
		# Additional details to write to the console.
		[String]$details
	)
	process {
		$Params = @{
			Object = ('{0}: {1}' -f $message, $details).TrimEnd(' :')
			ForegroundColor = switch ($Category) {
				'Success' { 'Green' }
				'Information' { 'Cyan' }
				'Warning' { 'Yellow' }
				'Error' { 'Red' }
			}
		}
		Write-Host @Params
	}
}
# Helper: Invoke a task.
function InvokeTask {
	[CmdletBinding()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Script is not intended to be used as a module.')]
	param (
		[Parameter(Mandatory, ParameterSetName = 'ExecuteFunction', ValueFromPipeline)]
		[String]$taskName,
		[Parameter(Mandatory, ParameterSetName = 'ExecuteScript', ValueFromPipelineByPropertyName)]
		[Alias('FullName')]
		[String]$path
	)
	begin {
		WriteMessage ('Build {0}' -f $PSCommandPath) -Category Success
	}
	process {
		if ($PSCmdlet.ParameterSetName -eq 'ExecuteScript') {
			$taskName = [System.IO.Path]::GetFileNameWithoutExtension($path)
		}
		$ErrorActionPreference = 'Stop'
		try {
			$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
			WriteMessage -message ('Task {0}' -f $taskName)
			if ($PSCmdlet.ParameterSetName -eq 'ExecuteFunction') {
				& "Script:$taskName"
			} else {
				& $path
			}
			WriteMessage -message ('Done {0} {1}' -f $taskName, $StopWatch.Elapsed)
		} catch {
			WriteMessage -message ('Failed {0} [{1}]' -f $taskName, $StopWatch.Elapsed) -Category Error -details $_.Exception.Message
			exit 1
		} finally {
			$StopWatch.Stop()
		}
	}
}
$TasksPath = Join-path -path $RepoRoot -ChildPath '.build\tasks'
@(
	$taskNames
	if ((-not $excludeCustomTasks) -and (Test-path $TasksPath)) {
		Get-ChildItem -path $TasksPath
	}
) | Where-Object { -not $BuildConfig -or $BuildConfig['Skip'] -notcontains $_ } | InvokeTask
