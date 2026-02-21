$basePath = 'j:\Projects\NinjaOne\Source\Public\'
$allFiles = @(Get-ChildItem -Path $basePath -Filter '*.ps1' -Recurse)

Write-Output '=== METADATA ATTRIBUTE ANALYSIS ==='
Write-Output "Total PS1 files: $($allFiles.Count)"
Write-Output ''

$missingAttributeFiles = @()

foreach ($file in $allFiles) {
	$content = Get-Content -Path $file.FullName -TotalCount 50 -ErrorAction SilentlyContinue
	$hasAttribute = $false
    
	if ($content) {
		foreach ($line in $content) {
			if ($line -match '\[MetadataAttribute\(') {
				$hasAttribute = $true
				break
			}
		}
	}
    
	if (-not $hasAttribute) {
		$missingAttributeFiles += @{
			FullPath = $file.FullName
			RelativePath = $file.FullName.Replace($basePath, '')
			FunctionName = $file.BaseName
		}
	}
}

Write-Output "Files WITHOUT MetadataAttribute: $($missingAttributeFiles.Count)"
Write-Output ''

if ($missingAttributeFiles.Count -gt 0) {
	Write-Output '=== MISSING METADATAATTRIBUTE ==='
	$missingAttributeFiles | ForEach-Object {
		$parts = $_.RelativePath -split '\\'
		$category = $parts[0]
		$subfolder = $parts[1]
		"$category\$subfolder : $($_.FunctionName)"
	} | Sort-Object | Get-Unique | ForEach-Object { Write-Output $_ }
} else {
	Write-Output '✓ All public functions have MetadataAttribute!'
}
