<#
    .SYNOPSIS
        Homotechsual portable module build script.
#>
[CmdletBinding()]
Param (
    [String[]]$TaskNames = ('clean', 'build', 'test', 'updateManifest', 'publish', 'updateHelp', 'generateShortNamesMapping', 'push'),
    [String[]]$Remotes = @('origin', 'homotechsual'),
    [Switch]$Push,
    [Switch]$UpdateHelp,
    [System.IO.DirectoryInfo]$DocusaurusPath,
    [Switch]$ForceUpdateCategoryFiles,
    [Switch]$CopyModuleFiles,
    [Switch]$Test,
    [Switch]$UpdateManifest,
    [Switch]$PublishModule,
    [Switch]$Clean,
    [Switch]$GenerateShortNamesMapping
)

$ModuleName = 'NinjaOne'

# Install required modules
if (-Not(Get-Module -Name 'Install-RequiredModule')) {
    Install-Script -Name 'Install-RequiredModule' -Force -Scope CurrentUser
}
Install-RequiredModule -RequiredModulesFile ('{0}\RequiredModules.psd1' -f $PSScriptRoot) -Scope CurrentUser -TrustRegisteredRepositories -Import -Quiet

# Use strict mode when building.
Set-StrictMode -Version Latest

# Helper: Get functions from the module.
function GetFunctions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ModuleName
    )
    Import-Module ('.\Source\{0}.psd1' -f $ModuleName) -Force
    $Module = Get-Module -Name $ModuleName
    $CommandletList = [System.Collections.Generic.List[String]]::new()
    $CommandletList.AddRange($Module.ExportedFunctions.Keys)
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

# Task: Check the implemented commandlets against NinjaOne's API specification.
function CheckSchema {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ModuleName
    )
    $SchemaURI = 'https://oc.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
    $CoveredEndpoints = [System.Collections.Generic.List[String]]::new()
    $MissingEndpoints = [System.Collections.Generic.List[String]]::new()
    $SchemaObject = Invoke-WebRequest -Uri $SchemaURI -UseBasicParsing | ConvertFrom-Yaml
    $Endpoints = foreach ($Path in $SchemaObject.paths.GetEnumerator()) {
        @{
            Path = $Path.Name
            Methods = $Path.Value.GetEnumerator() | ForEach-Object { $_.Name }
        }
    }
    $CommandletList = GetFunctions -ModuleName $ModuleName
    foreach ($Commandlet in $CommandletList) {
        $AST = (Get-Content -Path ('function:/{0}' -f $Commandlet) -ErrorAction Ignore).AST
        $MetadataFinder = [System.Func[System.Management.Automation.Language.Ast, bool]] { $args[0] -is [System.Management.Automation.Language.AttributeAst] -and $args[0].TypeName.Name -eq 'Metadata' -and $args[0].Parent -is [System.Management.Automation.Language.ParamBlockAst] }
        $Metadata = $AST.FindAll($MetadataFinder, $true)
        $PositionalArguments = $Metadata.PositionalArguments
        $MetadataHashTable = [Hashtable]@{}
        if ($PositionalArguments.Count -gt 0 -and ($PositionalArguments.Count % 2 -eq 0)) {
            for ($i = 0; $i -lt $PositionalArguments.Count; $i += 2) { $MetadataHashTable[$PositionalArguments[$i].Value] = $PositionalArguments[$i + 1].Value }
        }
        foreach ($MetadataPairs in $MetadataHashTable) {
            $EndpointObject = $Endpoints.Where( { $_.Path -eq $MetadataPairs.Key } )
            if (-not $EndpointObject) {
                $MissingEndpoints.Add($MetadataPairs.Key)
            } elseif ($EndpointObject.Methods -notcontains $MetadataPairs.Value) {
                $MissingEndpoints.Add($MetadataPairs.Key)
            } else {
                $CoveredEndpoints.Add($MetadataPairs.Key)
            }
        }
        Write-Verbose ('Covered endpoints: {0}' -f $CoveredEndpoints.Count)
        if ($MissingEndpoints.Count -gt 0) {
            Write-Warning ('Missing endpoints: {0}' -f $MissingEndpoints.Count)
            $MissingEndpoints | ForEach-Object { Write-Warning -Message ('{0}' -f $_) }
            throw 'Missing endpoints'
        }
    }
}

# Task: (Re)Generate the mapping file for the short names of the commandlets. Stored in the Functionality item of the comment based help. The file will be stored in .\.build\CommandletShortNames.yaml
## Requres YAYAML installed.
function GenerateShortNamesMapping {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ModuleName
    )
    $OutputFilePath = [System.IO.FileInfo]'.\.build\CommandletShortNames.yaml'
    $ShortNameOutput = [System.Collections.Generic.Dictionary[String, String]]::new()
    $CommandletList = GetFunctions -ModuleName $ModuleName
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
        $CommandletList | Where-Object { -not $ShortNameOutput.ContainsKey($_) } | ForEach-Object { Write-Warning -Message ('Commandlet {0} not present in the short name list.' -f $_) }
        throw 'Not all commandlets have a short name.'
    }
}

# Task: Update the PowerShell Module Help Files.
## Requires PlatyPS, Pester, PSScriptAnalyzer and Alt3.Docusaurus.PowerShell installed.
function UpdateHelp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$ModuleName,
        [Parameter(Mandatory)]
        [ValidateScript( { Resolve-Path -Path $_ } )]
        [System.IO.DirectoryInfo]$DocusaurusPath,
        [Switch]$ForceUpdateCategoryFiles
    )
    $DocsFolderPath = Join-Path -Path $DocusaurusPath -ChildPath 'docs' -AdditionalChildPath $ModuleName
    if (-Not(Test-Path -Path $DocsFolderPath)) {
        New-Item -Path $DocsFolderPath -ItemType Directory | Out-Null
    }
    $ShortNamesFilePath = [System.IO.FileInfo]'.\.build\CommandletShortNames.yaml'
    $ShortNamesYAML = Get-Content -Path $ShortNamesFilePath
    $ShortNamesDictionary = ConvertFrom-Yaml -InputObject $ShortNamesYAML
    $MarkdownHeader = @'
:::powershell[Generated Cmdlet Help]
This page has been generated from the {0} PowerShell module source. To make changes please edit the appropriate PowerShell source file.
:::
'@ -f $ModuleName
    $ExcludeFiles = Get-ChildItem -Path "$($PSScriptRoot)\Private" -Filter '*.ps1' -Recurse | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }
    $NewDocusaurusHelpParams = @{
        Module = ('.\Source\{0}.psd1' -f $ModuleName)
        DocsFolder = $DocsFolderPath
        Exclude = $ExcludeFiles
        Sidebar = 'commandlets'
        # MetaDescription = 'Generated cmdlet help for the %1 commandlet.'
        GroupByVerb = $true
        UseDescriptionFromHelp = $true
        NoPlaceHolderExamples = $true
        UseCustomShortTitles = $true
        ShortTitles = $ShortNamesDictionary
        PrependMarkdown = $MarkdownHeader
        RemoveParameters = @('-ProgressAction', '-FakeParam')
    }
    New-DocusaurusHelp @NewDocusaurusHelpParams | Out-Null
    $CommandletDocsFolder = Join-Path -Path $DocusaurusPath -ChildPath 'docs' -AdditionalChildPath @($ModuleName, 'commandlets')
    $VerbFolders = Get-ChildItem -Path $CommandletDocsFolder -Directory
    $CategoryFileBase = @{
        position = 1
        collapsible = $true
        collapsed = $true
        link = @{
            type = 'generated-index'
        }
        customProps = @{
            description = ''
        }
    }
    foreach ($VerbFolder in $VerbFolders) {
        $HasCategoryFile = Get-ChildItem -Path $VerbFolder.FullName -Filter '_category_.*' -File -ErrorAction SilentlyContinue
        $CategoryFilePath = Join-Path -Path $VerbFolder.FullName -ChildPath '_category_.json'
        switch ($VerbFolder.Name) {
            'Connect' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Connect to Services'
                $CategoryFile.position = 0.1
                $CategoryFile.collapsed = $false
                $CategoryFile.className = 'category-connect'
                $CategoryFile.link.title = 'Connect to Services'
                $CategoryFile.customProps.description = 'This category contains commands for connecting to services, retrieving and storing credentials and managing connections.'
            }
            'Find' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Find Information'
                $CategoryFile.position = 0.2
                $CategoryFile.className = 'category-find'
                $CategoryFile.link.title = 'Find Information'
                $CategoryFile.customProps.description = 'This category contains commands for finding information from services, this may include data, objects, settings and more.'
            }
            'Get' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Retrieve Information'
                $CategoryFile.position = 0.3
                $CategoryFile.className = 'category-get'
                $CategoryFile.link.title = 'Retrieve Information'
                $CategoryFile.customProps.description = 'This category contains commands for retrieving information from services, this may include data, objects, settings and more.'
            }
            'Invoke' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Invoke Actions'
                $CategoryFile.position = 0.4
                $CategoryFile.className = 'category-invoke'
                $CategoryFile.link.title = 'Invoke Actions'
                $CategoryFile.customProps.description = 'This category contains commands for invoking actions, this may include running scripts, executing commands and more. For API modules, this category will contain commands for sending arbitrary requests to the API - that is requests not covered by existing commands.'
            }
            'New' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Create Data'
                $CategoryFile.position = 0.5
                $CategoryFile.className = 'category-new'
                $CategoryFile.link.title = 'Create Data'
                $CategoryFile.customProps.description = 'This category contains commands for creating data, objects, settings and more.'
            }
            'Remove' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Remove Data'
                $CategoryFile.position = 0.6
                $CategoryFile.className = 'category-remove'
                $CategoryFile.link.title = 'Remove Data'
                $CategoryFile.customProps.description = 'This category contains commands for removing data, objects, settings and more.'
            }
            'Reset' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Reset State'
                $CategoryFile.position = 0.6
                $CategoryFile.className = 'category-reset'
                $CategoryFile.link.title = 'Reset State'
                $CategoryFile.customProps.description = 'This category contains commands for resetting state, this may include resetting settings, connections and more.'
            }
            'Restart' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Restart Services'
                $CategoryFile.position = 0.6
                $CategoryFile.className = 'category-restart'
                $CategoryFile.link.title = 'Restart Services'
                $CategoryFile.customProps.description = 'This category contains commands for restarting services, this may include restarting services, processes and more.'
            }
            'Restore' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Restore Data'
                $CategoryFile.position = 0.6
                $CategoryFile.className = 'category-restore'
                $CategoryFile.link.title = 'Restore Data'
                $CategoryFile.customProps.description = 'This category contains commands for restoring data, objects, settings and more. These commands will primarily be used for restoring data to a previous state.'
            }
            'Set' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Update Data (Set)'
                $CategoryFile.position = 0.4
                $CategoryFile.className = 'category-set'
                $CategoryFile.link.title = 'Update Data (Set)'
                $CategoryFile.customProps.description = 'This category contains commands for updating data, objects, settings and more. This category will overlap with the Update category.'
            }
            'Update' {
                $CategoryFile = $CategoryFileBase
                $CategoryFile.label = 'Update Data (Update)'
                $CategoryFile.position = 0.4
                $CategoryFile.className = 'category-update'
                $CategoryFile.link.title = 'Update Data (Update)'
                $CategoryFile.customProps.description = 'This category contains commands for updating data, objects, settings and more. This category will overlap with the Set category.'
            }
        }
        if (-Not($HasCategoryFile)) {
            $CategoryFile | ConvertTo-Json | Out-File -FilePath $CategoryFilePath -Force
        } else {
            if (-Not($ForceUpdateCategoryFiles)) {
                Write-Warning -Message ('Category file already exists in "{0}" verb folder. Use the ForceUpdateCategoryFiles switch to overwrite existing category files.' -f $VerbFolder.Name)
            } else {
                Set-Content -Path $CategoryFilePath -Value ($CategoryFile | ConvertTo-Json) -Force
            }
        }
    }
}

function Build {
    Build-Module -Path (Resolve-Path -Path ('{0}\*\build.psd1') -f $PSScriptRoot)
}

# Copy PowerShell Module files to output folder for release on PSGallery
if ($CopyModuleFiles) {
    # Copy Module Files to Output Folder
    if (-not (Test-Path "$($PSScriptRoot)\Output\$ModuleName")) {
        New-Item -Path "$($PSScriptRoot)\Output\$ModuleName" -ItemType Directory | Out-Null
    }
    if (Test-Path -Path "$($PSScriptRoot)\Classes\") {
        Copy-Item -Path "$($PSScriptRoot)\Classes\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    }
    if (Test-Path -Path "$($PSScriptRoot)\Data\") {
        Copy-Item -Path "$($PSScriptRoot)\Data\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    }
    Copy-Item -Path "$($PSScriptRoot)\Private\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    Copy-Item -Path "$($PSScriptRoot)\Public\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force

    # Copy module, manifest and scaffold files
    Copy-Item -Path @(
        "$($PSScriptRoot)\LICENSE.md"
        "$($PSScriptRoot)\CHANGELOG.md"
        "$($PSScriptRoot)\README.md"
        "$($PSScriptRoot)\$ModuleName.psd1"
        "$($PSScriptRoot)\$ModuleName.psm1"
    ) -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
}

# Task: Run all Pester tests in folder .\Tests
function Test {
    $Result = Invoke-Pester "$($PSScriptRoot)\Tests" -PassThru
    if ($Result.FailedCount -gt 0) {
        throw 'Pester tests failed'
    }
}

# Task: Update the Module Manifest file with info from the Changelog.
function UpdateManifest {
    # Import PlatyPS. Needed for parsing the versions in the Changelog.
    Import-Module -Name PlatyPS

    # Find Latest Version in Change log.
    $CHANGELOG = Get-Content -Path "$($PSScriptRoot)\CHANGELOG.md"
    $MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
    [regex]$Regex = '\d\.\d\.\d'
    $Versions = $Regex.Matches($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) | ForEach-Object { $_.Value }
    $ChangeLogVersion = ($Versions | Measure-Object -Maximum).Maximum

    $ManifestPath = "$($PSScriptRoot)\$ModuleName.psd1"

    # Start by importing the manifest to determine the version, then add 1 to the Build
    $Manifest = Test-ModuleManifest -Path $ManifestPath
    [System.Version]$Version = $Manifest.Version

    if ($ChangeLogVersion -eq $Version) {
        throw 'No new version found in CHANGELOG.md'
    }

    Write-Output -InputObject ("Current Module Version: $($Version)")
    Write-Output -InputObject ("New Module version: $($ChangeLogVersion)")

    # Update Manifest file with Release Notes
    $CHANGELOG = Get-Content -Path "$($PSScriptRoot)\CHANGELOG.md"
    $MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
    $ReleaseNotes = ((($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) -Match '\d\.\d\.\d') -Split ' - ')[1]

    # Update Module with new version
    Update-ModuleManifest -ModuleVersion $ChangeLogVersion -Path "$($PSScriptRoot)\$ModuleName.psd1" -ReleaseNotes $ReleaseNotes
}

# Task: Publish Module to PowerShell Gallery
function Publish {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ModuleName
    )
    Try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $params = @{
            Path = ("$($PSScriptRoot)\Build\$ModuleName")
            NuGetApiKey = $ENV:TF_BUILD ? $ENV:PSGalleryAPIKey : (Get-AzKeyVaultSecret -VaultName $ENV:PSGalleryVault -Name $ENV:PSGallerySecret -AsPlainText) # If running in Azure DevOps, use the Environment Variable, otherwise use the Key Vault
            ErrorAction = 'Stop'
            
        }
        $ManifestPath = "$($PSScriptRoot)\$ModuleName.psd1"
        $Manifest = Test-ModuleManifest -Path $ManifestPath
        [System.Version]$Version = $Manifest.Version
        Publish-Module @params
        Write-Output -InputObject ("$ModuleName PowerShell Module version $($Version) published to the PowerShell Gallery")
    } Catch {
        throw $_
    }
}

# Task: Clean up Output folder
function Clean {
    # Clean output folder
    if ((Test-Path "$($PSScriptRoot)\Build")) {
        Remove-Item -Path "$($PSScriptRoot)\Build" -Recurse -Force
    }
}
# Helper: Write a message to the console.
function WriteMessage {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Script is not intended to be used as a module.')]
    param (
        # The message to write to the console.
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$Message,
        # The category of the message.
        [ValidateSet('Information', 'Warning', 'Error')]
        [String]$Category = 'Information',
        # Additional details to write to the console.
        [String]$Details
    )
    process {
        $Params = @{
            Object = ('{0}: {1}' -f $Message, $Details).TrimEnd(' :')
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

function InvokeTask {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Script is not intended to be used as a module.')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ExecuteFunction', ValueFromPipeline)]
        [String]$TaskName,
        [Parameter(Mandatory, ParameterSetName = 'ExecuteScript', ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [String]$Path
    )
    begin {
        WriteMessage ('Build {0}' -f $PSCommandPath) -Category Success
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ExecuteScript') {
            $TaskName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        }
        $ErrorActionPreference = 'Stop'
        try {
            $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
            WriteMessage -Message ('Task {0}' -f $TaskName)
            if ($PSCmdlet.ParameterSetName -eq 'ExecuteFunction') {
                & "Script:$TaskName"
            } else {
                & $Path
            }
            WriteMessage -Message ('Done {0} {1}' -f $TaskName, $StopWatch.Elapsed)
        } catch {
            WriteMessage -Message ('Failed {0} {1}' -f $TaskName, $StopWatch.Elapsed) -Category Error -Details $_.Exception.Message
            exit 1
        } finally {
            $StopWatch.Stop()
        }
    }
}

$TasksPath = Join-Path -Path $PSScriptRoot -ChildPath '.build\tasks'
@(
    $TaskName
    if ((-not $ExcludeCustomTasks) -and (Test-Path $TasksPath)) {
        Get-ChildItem -Path $TasksPath
    }
) | Where-Object { -not $BuildConfig -or $BuildConfig['Skip'] -NotContains $_ } | InvokeTask