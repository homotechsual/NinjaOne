#requires -Version 7
<#
.SYNOPSIS
    Adds missing .PARAMETER sections to comment-based help from inline parameter comments.
.DESCRIPTION
    Scans functions and adds .PARAMETER sections to comment-based help blocks based on
    inline parameter comments (# comment after parameter declaration).
#>
param(
	[string[]]$FunctionNames
)

foreach ($FunctionName in $FunctionNames) {
	# Find the .ps1 file
	$file = Get-ChildItem -Path '.\Source\Public' -Recurse -Filter "$FunctionName.ps1" | Select-Object -First 1
    
	if (-not $file) {
		Write-Warning "Could not find file for $FunctionName"
		continue
	}
    
	Write-Host "Processing: $($file.FullName)" -ForegroundColor Cyan
    
	$content = Get-Content -Path $file.FullName -Raw
    
	# Extract parameter names and their inline comments
	$paramPattern = '(?m)^\s*(?:\[Parameter[^\]]*\])?\s*(?:\[[^\]]+\])?\s*\$(\w+)\s*(?:,|\))?(?:\s*#\s*(.+))?$'
	$matches = [regex]::Matches($content, $paramPattern)
    
	$parameters = @{}
	foreach ($match in $matches) {
		$paramName = $match.Groups[1].Value
		$paramComment = $match.Groups[2].Value.Trim()
		if ($paramComment) {
			$parameters[$paramName] = $paramComment
		}
	}
    
	if ($parameters.Count -eq 0) {
		Write-Warning '  No inline parameter comments found'
		continue
	}
    
	Write-Host "  Found $($parameters.Count) parameters with inline comments"
    
	# Find the insertion point (after .FUNCTIONALITY or .DESCRIPTION, before .EXAMPLE)
	if ($content -match '(?s)(<#.*?)(\.EXAMPLE)') {
		$helpBlock = $Matches[1]
		$rest = $content.Substring($Matches[1].Length)
        
		# Build .PARAMETER sections
		$paramSections = ''
		foreach ($paramName in $parameters.Keys | Sort-Object) {
			$paramSections += "`t`t.PARAMETER $paramName`n"
			$paramSections += "`t`t`t$($parameters[$paramName])`n"
		}
        
		# Insert before .EXAMPLE
		$newContent = $helpBlock + $paramSections + $rest
        
		Set-Content -Path $file.FullName -Value $newContent -NoNewline
		Write-Host "  ✓ Added $($parameters.Count) .PARAMETER sections" -ForegroundColor Green
	} else {
		Write-Warning '  Could not find insertion point in help block'
	}
}

Write-Host "`nDone processing $($FunctionNames.Count) functions" -ForegroundColor Green
