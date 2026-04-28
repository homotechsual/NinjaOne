param(
	[string]$OutputPath = (Join-Path -Path (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')) -ChildPath 'codecov.yml')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
$publicRoot = Join-Path -Path $repoRoot -ChildPath 'Source\Public'

function ConvertTo-CodecovId {
	<#
		.SYNOPSIS
			Converts text to a stable Codecov-compatible identifier.
	#>
	param(
		# The text value to convert into an identifier.
		[string]$Name,
		# A hash set of identifiers already used in the current output.
		[hashtable]$Seen
	)

	$normalizedName = $Name -creplace '([a-z0-9])([A-Z])', '$1_$2'
	$id = $normalizedName.ToLowerInvariant() -replace '[^a-z0-9]+', '_'
	$id = $id.Trim('_')
	if ([string]::IsNullOrWhiteSpace($id)) {
		$id = 'component'
	}

	$base = $id
	$index = 2
	while ($Seen.ContainsKey($id)) {
		$id = '{0}_{1}' -f $base, $index
		$index++
	}

	$Seen[$id] = $true
	return $id
}

function Get-RelativePath {
	<#
		.SYNOPSIS
			Builds a repository-relative path with normalized separators.
	#>
	param(
		# The full path to convert.
		[string]$FullName,
		# The repository root path.
		[string]$Root
	)

	$relative = $FullName.Substring($Root.Length + 1)
	return ($relative -replace '\\', '/')
}

function Get-FunctionalityMappings {
	<#
		.SYNOPSIS
			Maps CBH .FUNCTIONALITY values to public function file paths.
	#>
	param(
		# The root folder containing public function scripts.
		[string]$RootPath,
		# The repository root used for relative paths.
		[string]$RepoPath
	)

	$functionalityMap = [ordered]@{}
	$files = Get-ChildItem -Path $RootPath -Recurse -Filter '*.ps1' | Sort-Object -Property FullName

	foreach ($file in $files) {
		$lines = @(Get-Content -LiteralPath $file.FullName)
		if ($lines.Count -eq 0) {
			continue
		}

		$functionalityValues = New-Object System.Collections.Generic.List[string]
		for ($i = 0; $i -lt $lines.Count; $i++) {
			if ($lines[$i] -match '^\s*\.FUNCTIONALITY\s*$') {
				$j = $i + 1
				while ($j -lt $lines.Count -and [string]::IsNullOrWhiteSpace($lines[$j])) {
					$j++
				}

				if ($j -lt $lines.Count) {
					$value = $lines[$j].Trim()
					if (-not [string]::IsNullOrWhiteSpace($value) -and -not $value.StartsWith('.')) {
						$functionalityValues.Add($value)
					}
				}
			}
		}

		if ($functionalityValues.Count -eq 0) {
			continue
		}

		$relativePath = Get-RelativePath -FullName $file.FullName -Root $RepoPath
		foreach ($value in ($functionalityValues | Select-Object -Unique)) {
			if (-not $functionalityMap.Contains($value)) {
				$functionalityMap[$value] = New-Object System.Collections.Generic.List[string]
			}
			$functionalityMap[$value].Add($relativePath)
		}
	}

	return $functionalityMap
}

function Get-PublicFolderMappings {
	<#
		.SYNOPSIS
			Maps top-level public folders to recursive Codecov path patterns.
	#>
	param(
		# The root folder containing top-level public component folders.
		[string]$RootPath,
		# The repository root used for relative paths.
		[string]$RepoPath
	)

	$folders = Get-ChildItem -Path $RootPath -Directory | Sort-Object -Property Name
	$folderMap = [ordered]@{}

	foreach ($folder in $folders) {
		$relativeFolder = Get-RelativePath -FullName $folder.FullName -Root $RepoPath
		$folderMap[$folder.Name] = "$relativeFolder/**"
	}

	return $folderMap
}

$repoPath = $repoRoot.Path
$folderMappings = Get-PublicFolderMappings -RootPath $publicRoot -RepoPath $repoPath
$functionalityMappings = Get-FunctionalityMappings -RootPath $publicRoot -RepoPath $repoPath

$linesOut = New-Object System.Collections.Generic.List[string]
$linesOut.Add('codecov:')
$linesOut.Add('  require_ci_to_pass: true')
$linesOut.Add('')
$linesOut.Add('flags:')
$linesOut.Add('  classes:')
$linesOut.Add('    paths:')
$linesOut.Add('      - Source/Classes/**')
$linesOut.Add('  private:')
$linesOut.Add('    paths:')
$linesOut.Add('      - Source/Private/**')

$flagIds = @{}
foreach ($folderName in $folderMappings.Keys) {
	$flagId = ConvertTo-CodecovId -Name $folderName -Seen $flagIds
	$pathPattern = $folderMappings[$folderName]
	$linesOut.Add("  ${flagId}:")
	$linesOut.Add('    paths:')
	$linesOut.Add("      - '$pathPattern'")
}

$linesOut.Add('')
$linesOut.Add('component_management:')
$linesOut.Add('  default_rules:')
$linesOut.Add('    statuses:')
$linesOut.Add('      - type: project')
$linesOut.Add('        target: auto')
$linesOut.Add('  individual_components:')
$linesOut.Add('    - component_id: classes')
$linesOut.Add('      name: Classes')
$linesOut.Add('      paths:')
$linesOut.Add('        - Source/Classes/**')
$linesOut.Add('    - component_id: private')
$linesOut.Add('      name: Private')
$linesOut.Add('      paths:')
$linesOut.Add('        - Source/Private/**')

$componentIds = @{
	classes = $true
	private = $true
}

foreach ($folderName in $folderMappings.Keys) {
	$folderId = ConvertTo-CodecovId -Name ("folder_$folderName") -Seen $componentIds
	$pathPattern = $folderMappings[$folderName]
	$escapedName = $folderName.Replace("'", "''")

	$linesOut.Add("    - component_id: $folderId")
	$linesOut.Add("      name: 'Folder: $escapedName'")
	$linesOut.Add('      paths:')
	$linesOut.Add("        - '$pathPattern'")
}

foreach ($functionalityName in ($functionalityMappings.Keys | Sort-Object)) {
	$functionalityId = ConvertTo-CodecovId -Name ("func_$functionalityName") -Seen $componentIds
	$escapedName = $functionalityName.Replace("'", "''")
	$paths = $functionalityMappings[$functionalityName] | Sort-Object -Unique

	$linesOut.Add("    - component_id: $functionalityId")
	$linesOut.Add("      name: 'Functionality: $escapedName'")
	$linesOut.Add('      paths:')
	foreach ($path in $paths) {
		$linesOut.Add("        - $path")
	}
}

Set-Content -LiteralPath $OutputPath -Value $linesOut -Encoding utf8
Write-Host ('Generated codecov config: {0}' -f $OutputPath)
Write-Host ('Folder flags/components: {0}' -f $folderMappings.Count)
Write-Host ('Functionality components: {0}' -f $functionalityMappings.Count)
