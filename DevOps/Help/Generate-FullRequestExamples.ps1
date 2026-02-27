<#
.SYNOPSIS
Generate full request examples for POST/PUT/PATCH cmdlets.

.DESCRIPTION
Fetches the OpenAPI YAML (default: eu.ninjarmm.com) and generates a "Full request example" help block
for cmdlets that have request bodies. The block is inserted or replaced only between explicit markers,
leaving all other examples untouched.

.PARAMETER BaseUrl
Base instance URL used to download the OpenAPI YAML. Defaults to https://eu.ninjarmm.com.

.PARAMETER YamlPath
Optional local OpenAPI YAML file path. When provided, no download is performed.

.PARAMETER SourcePath
Root path to scan for public cmdlets. Defaults to Source/Public.

.PARAMETER EndpointPath
Optional OpenAPI path to target (e.g. /v2/user/end-users). When set, only cmdlets
matching this endpoint will be updated.

.PARAMETER CommandName
Optional cmdlet name to target (e.g. New-NinjaOneEndUser). When set, only that
cmdlet will be updated.

.EXAMPLE
PS> .\DevOps\Help\Generate-FullRequestExamples.ps1

Generates full request examples using the eu.ninjarmm.com OpenAPI YAML.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
	[String]$BaseUrl = 'https://eu.ninjarmm.com',
	[String]$YamlPath,
	[String]$SourcePath = (Join-Path -Path $PSScriptRoot -ChildPath '..\..\Source\Public'),
	[String]$EndpointPath,
	[String[]]$CommandName
)

$beginMarker = '# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN'
$endMarker = '# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END'

function Get-OpenApiDocument {
	param(
		[String]$BaseUrl,
		[String]$YamlPath
	)

	if ($YamlPath) {
		if (-not (Test-Path -Path $YamlPath)) {
			throw "OpenAPI YAML file not found at '$YamlPath'."
		}
		return Get-Content -Path $YamlPath -Raw
	}

	$uri = "{0}/apidocs-beta/NinjaRMM-API-v2.yaml" -f $BaseUrl.TrimEnd('/')
	$webParams = @{ Uri = $uri; ErrorAction = 'Stop' }
	if ($PSVersionTable.PSVersion.Major -eq 5) {
		$webParams.UseBasicParsing = $true
	}
	return [System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest @webParams).Content)
}

function ConvertFrom-OpenApiYaml {
	param([String]$Yaml)

	if (-not (Get-Command -Name ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
		Import-Module powershell-yaml -ErrorAction SilentlyContinue
		Import-Module Yayaml -ErrorAction SilentlyContinue
	}

	$yamlCommands = Get-Command -Name ConvertFrom-Yaml -All -ErrorAction SilentlyContinue
	if (-not $yamlCommands) {
		throw 'ConvertFrom-Yaml is not available. Install the powershell-yaml or Yayaml module.'
	}

	$command = $yamlCommands | Where-Object { $_.Parameters.ContainsKey('Yaml') } | Select-Object -First 1
	if ($command) {
		return & $command -Yaml $Yaml
	}

	$command = $yamlCommands | Where-Object { $_.Parameters.ContainsKey('InputObject') } | Select-Object -First 1
	if ($command) {
		return & $command -InputObject $Yaml
	}

	throw 'ConvertFrom-Yaml is available but does not expose a supported parameter set.'
}

function Resolve-SchemaRef {
	param(
		[Object]$Schema,
		[Hashtable]$Schemas
	)
	$hasRef = if (($Schema -is [hashtable]) -or ($Schema -is [System.Collections.Specialized.OrderedDictionary])) {
		$Schema.Contains('$ref')
	} else {
		$Schema.PSObject.Properties.Name -contains '$ref'
	}
	
	if ($Schema -and $hasRef) {
		$ref = if (($Schema -is [hashtable]) -or ($Schema -is [System.Collections.Specialized.OrderedDictionary])) {
			$Schema['$ref']
		} else {
			$Schema.'$ref'
		}
		if ($ref -match '#/components/schemas/(?<name>[^/]+)$') {
			$name = $Matches['name']
			$resolved = $Schemas[$name]
			if ($resolved) {
				return $resolved
			}
		}
	}
	return $Schema
}

function New-ExampleFromSchema {
	param(
		[Object]$Schema,
		[Hashtable]$Schemas,
		[Hashtable]$Visited
	)

	$Schema = Resolve-SchemaRef -Schema $Schema -Schemas $Schemas
	if (-not $Schema) {
		return $null
	}

	# Helper function to check if a property exists (works for hashtables, OrderedDictionaries, and PSCustomObjects)
	function Test-SchemaProperty {
		param([Object]$Obj, [string]$PropName)
		if (($Obj -is [hashtable]) -or ($Obj -is [System.Collections.Specialized.OrderedDictionary])) {
			return $Obj.Contains($PropName)
		}
		return ($Obj.PSObject.Properties.Name -contains $PropName)
	}

	# Helper function to get a property value (works for hashtables, OrderedDictionaries, and PSCustomObjects)
	function Get-SchemaValue {
		param([Object]$Obj, [string]$PropName)
		if (($Obj -is [hashtable]) -or ($Obj -is [System.Collections.Specialized.OrderedDictionary])) {
			return $Obj[$PropName]
		}
		return $Obj.$PropName
	}

	# Helper function to get properties (works for hashtables, OrderedDictionaries, and PSCustomObjects)
	function Get-SchemaProperties {
		param([Object]$Obj)
		if (($Obj -is [hashtable]) -or ($Obj -is [System.Collections.Specialized.OrderedDictionary])) {
			return $Obj.Keys | ForEach-Object {
				[PSCustomObject]@{ Name = $_; Value = $Obj[$_] }
			}
		}
		return $Obj.PSObject.Properties
	}

	if (Test-SchemaProperty -Obj $Schema -PropName 'oneOf') {
		$oneOf = Get-SchemaValue -Obj $Schema -PropName 'oneOf'
		return New-ExampleFromSchema -Schema $oneOf[0] -Schemas $Schemas -Visited $Visited
	}
	if (Test-SchemaProperty -Obj $Schema -PropName 'anyOf') {
		$anyOf = Get-SchemaValue -Obj $Schema -PropName 'anyOf'
		return New-ExampleFromSchema -Schema $anyOf[0] -Schemas $Schemas -Visited $Visited
	}
	if (Test-SchemaProperty -Obj $Schema -PropName 'allOf') {
		$allOf = Get-SchemaValue -Obj $Schema -PropName 'allOf'
		$merged = [ordered]@{}
		foreach ($item in $allOf) {
			$child = New-ExampleFromSchema -Schema $item -Schemas $Schemas -Visited $Visited
			if (($child -is [hashtable]) -or ($child -is [System.Collections.Specialized.OrderedDictionary])) {
				foreach ($key in $child.Keys) { $merged[$key] = $child[$key] }
			}
		}
		return $merged
	}

	if (Test-SchemaProperty -Obj $Schema -PropName 'enum') {
		$enum = Get-SchemaValue -Obj $Schema -PropName 'enum'
		return $enum[0]
	}

	$schemaType = Get-SchemaValue -Obj $Schema -PropName 'type'
	if (-not $schemaType -and (Test-SchemaProperty -Obj $Schema -PropName 'properties')) {
		$schemaType = 'object'
	}

	switch ($schemaType) {
		'object' {
			if (Test-SchemaProperty -Obj $Schema -PropName 'properties') {
				$properties = Get-SchemaValue -Obj $Schema -PropName 'properties'
				$result = [ordered]@{}
				foreach ($prop in (Get-SchemaProperties -Obj $properties)) {
					$propName = $prop.Name
					$propSchema = $prop.Value
					$result[$propName] = New-ExampleFromSchema -Schema $propSchema -Schemas $Schemas -Visited $Visited
				}
				return $result
			}
			if (Test-SchemaProperty -Obj $Schema -PropName 'additionalProperties') {
				$additionalSchema = Get-SchemaValue -Obj $Schema -PropName 'additionalProperties'
				if ($additionalSchema -eq $true) {
					return [ordered]@{ additionalProp1 = 'value' }
				}
				$additionalValue = New-ExampleFromSchema -Schema $additionalSchema -Schemas $Schemas -Visited $Visited
				return [ordered]@{ additionalProp1 = $additionalValue }
			}
			return [ordered]@{}
		}
		'array' {
			if (Test-SchemaProperty -Obj $Schema -PropName 'items') {
				$items = Get-SchemaValue -Obj $Schema -PropName 'items'
				$item = New-ExampleFromSchema -Schema $items -Schemas $Schemas -Visited $Visited
				return ,@($item)
			}
			return @()
		}
		'integer' { return 0 }
		'number' { return 0 }
		'boolean' { return $false }
		'string' {
			$format = Get-SchemaValue -Obj $Schema -PropName 'format'
			if ($format -eq 'date-time') { return '2024-01-01T00:00:00Z' }
			if ($format -eq 'date') { return '2024-01-01' }
			if ($format -eq 'uuid') { return '00000000-0000-0000-0000-000000000000' }
			return 'string'
		}
		default { return $null }
	}
}

function ConvertTo-HashtableLines {
	param(
		[Object]$Value,
		[String]$Indent
	)

	$lines = @()
	if (($Value -is [hashtable]) -or ($Value -is [System.Collections.Specialized.OrderedDictionary])) {
		$lines += "${Indent}@{"
		foreach ($key in $Value.Keys) {
			$child = ConvertTo-HashtableLines -Value $Value[$key] -Indent ($Indent + "`t")
			if ($child.Count -eq 1) {
				# Single line value - check if it's a complex type that needs special formatting
				$childValue = $child[0]
				if (($childValue -is [string]) -and ($childValue.StartsWith('@(') -or $childValue.StartsWith('@{'))) {
					# Complex value on same line
					$line = "${Indent}`t${key} = $childValue"
				} else {
					# Simple value
					$line = "${Indent}`t${key} = $childValue"
				}
				$lines += $line
			} else {
				# Multi-line value - format with newline
				$firstLine = $child[0]
				if ($firstLine -match '^\s+@([\(\{])') {
					$firstLine = $firstLine.TrimStart()
				}
				$line = "${Indent}`t${key} = $firstLine"
				$lines += $line
				$lines += $child[1..($child.Count - 1)]
			}
		}
		$lines += "${Indent}}"
		return $lines
	}
	if ($Value -is [array]) {
		if ($Value.Count -eq 0) { return @("@()") }
		$child = ConvertTo-HashtableLines -Value $Value[0] -Indent ($Indent + "`t")
		$lines += "${Indent}@("
		foreach ($line in $child) {
			if ($line -match '^\s') {
				$lines += $line
			} else {
				$lines += "${Indent}`t$line"
			}
		}
		$lines += "${Indent})"
		return $lines
	}
	if ($Value -is [string]) {
		$quoted = '"{0}"' -f $Value
		return , @($quoted)  # Comma forces array to not unravel
	}
	if ($Value -is [bool]) {
		$result = if ($Value) { '$true' } else { '$false' }

		return , @($result)
	}
	if ($null -eq $Value) { return @('$null') }
	return @($Value)
}

function Get-BodyParameterName {
	param([String]$Content)

	# Look for parameter with 'body' in its Alias attribute (can be first or not)
	$bodyMatch = [regex]::Match($Content, '\[Alias\([^\)]*''body''[^\)]*\)\][\s\S]*?\$(?<name>[A-Za-z0-9_]+)')
	if ($bodyMatch.Success) { return $bodyMatch.Groups['name'].Value }

	$paramMatch = [regex]::Match($Content, '\[Parameter\([^\)]*Mandatory[^\)]*\)\][\s\S]*?\$(?<name>[A-Za-z0-9_]+)')
	if ($paramMatch.Success) { return $paramMatch.Groups['name'].Value }

	return 'Body'
}

function Get-PathParameters {
	param(
		[String]$Content,
		[String]$Path
	)

	$pathParams = @()
	# Extract {id}, {organizationId}, etc from the path
	$matches = [regex]::Matches($Path, '\{(?<param>[^}]+)\}')
	if ($matches.Count -eq 0) { return $pathParams }

	# For each path parameter, find the corresponding PowerShell parameter
	foreach ($match in $matches) {
		$pathParam = $match.Groups['param'].Value
		# Look for parameter defined before the body parameter
		$pattern = '\[Parameter\([^\)]*\)\][\s\S]*?\[Alias\([^\)]*\)\]?[\s\S]*?\$(?<name>[A-Za-z0-9_]+)'
		$paramMatches = [regex]::Matches($Content, $pattern)
		
		foreach ($pm in $paramMatches) {
			$paramName = $pm.Groups['name'].Value
			$fullBlock = $pm.Value
			# Skip if this is the body parameter
			if ($fullBlock -match "Alias\('body'\)") { continue }
			# Match if parameter name contains the path param name or vice versa
			# e.g., organizationId matches {id}, deviceId matches {id}, etc.
			if ($paramName -match "$pathParam|Id$") {
				$pathParams += @{
					Name = $paramName
					Placeholder = if ($pathParam -eq 'id') { '1' } else { '<value>' }
				}
				break
			}
		}
	}

	return $pathParams
}

function Build-FullRequestExampleBlock {
	param(
		[String]$CommandName,
		[String]$BodyParam,
		[Object]$ExampleObject,
		[Array]$PathParameters = @()
	)

	$indent = "`t`t"
	$lines = @()
	$lines += "$indent.EXAMPLE"
	$lines += "$indent`t$beginMarker"
	$bodyLines = ConvertTo-HashtableLines -Value $ExampleObject -Indent ''
	
	$lines += "$indent`tPS> `$body = " + $bodyLines[0]
	if ($bodyLines.Count -gt 1) {
		foreach ($line in $bodyLines[1..($bodyLines.Count - 1)]) {
			$lines += "$indent`t" + $line
		}
	}
	
	# Build the command line with path parameters first, then body
	$cmdLine = "$indent`tPS> $CommandName"
	if ($PathParameters.Count -gt 0) {
		foreach ($pathParam in $PathParameters) {
			$cmdLine += " -$($pathParam.Name) $($pathParam.Placeholder)"
		}
	}
	$cmdLine += " -$BodyParam `$body"
	$lines += $cmdLine
	
	$lines += "$indent`t$endMarker"
	$lines += "$indent`t"
	$lines += "$indent`tFull request example (auto-generated)."
	return ($lines -join "`n")
}

function Update-HelpBlock {
	param(
		[String]$Content,
		[String]$ExampleBlock
	)

	$lines = $Content -split "\r?\n"
	$beginIndex = [array]::FindIndex($lines, [System.Predicate[string]]{ param($line) $line -match [regex]::Escape($beginMarker) })
	$endIndex = [array]::FindIndex($lines, [System.Predicate[string]]{ param($line) $line -match [regex]::Escape($endMarker) })
	
	if ($beginIndex -ge 0 -and $endIndex -ge $beginIndex) {
		
		# Find the .EXAMPLE line that contains this marked block
		$exampleStart = $beginIndex - 1
		while ($exampleStart -ge 0 -and $lines[$exampleStart] -notmatch '^\s*\.EXAMPLE\s*$') {
			$exampleStart--
		}
		
		# Find where this example block ends (next section or next example's description end)
		$exampleEnd = $endIndex + 1
		# Skip any blank lines or description after the end marker
		while ($exampleEnd -lt $lines.Count -and $lines[$exampleEnd] -match '^\s*$') {
			$exampleEnd++
		}
		# If there's a description line, include it
		if ($exampleEnd -lt $lines.Count -and $lines[$exampleEnd] -notmatch '^\s*\.(EXAMPLE|OUTPUTS|LINK|PARAMETER|NOTES)\b' -and $lines[$exampleEnd] -notmatch '^\s*#>') {
			$exampleEnd++
		}
		
		# Replace only from .EXAMPLE line to end of this example block
		$before = if ($exampleStart -gt 0) { $lines[0..($exampleStart - 1)] } else { @() }
		$after = if ($exampleEnd -lt $lines.Count) { $lines[$exampleEnd..($lines.Count - 1)] } else { @() }
		$updated = @()
		$updated += $before
		$updated += ($ExampleBlock -split "`n")
		$updated += $after
		return ($updated -join "`n")
	}

	$insertAt = [array]::FindIndex($lines, [System.Predicate[string]]{ param($line) $line -match '^\s*\.OUTPUTS\b' })
	if ($insertAt -lt 0) {
		return $Content
	}
	$before = if ($insertAt -gt 0) { $lines[0..($insertAt - 1)] } else { @() }
	$after = $lines[$insertAt..($lines.Count - 1)]
	$updated = @()
	$updated += $before
	$updated += ($ExampleBlock -split "`n")
	$updated += $after
	return ($updated -join "`n")
}

$yamlText = Get-OpenApiDocument -BaseUrl $BaseUrl -YamlPath $YamlPath
$openApi = ConvertFrom-OpenApiYaml -Yaml $yamlText

$schemas = @{}
if ($openApi.components -and $openApi.components.schemas) {
	$schemasObj = $openApi.components.schemas
	if (($schemasObj -is [hashtable]) -or ($schemasObj -is [System.Collections.Specialized.OrderedDictionary])) {
		foreach ($key in $schemasObj.Keys) {
			$schemas[$key] = $schemasObj[$key]
		}
	} else {
		foreach ($schemaProp in $schemasObj.PSObject.Properties) {
			$schemas[$schemaProp.Name] = $schemaProp.Value
		}
	}
}
Write-Host "Loaded $($schemas.Count) schemas from OpenAPI document" -ForegroundColor Cyan

$publicFiles = Get-ChildItem -Path $SourcePath -Recurse -Filter '*.ps1'
Write-Host "Found $($publicFiles.Count) PowerShell files" -ForegroundColor Cyan
if ($CommandName) {
	Write-Host "Filtering for command: $($CommandName -join ', ')" -ForegroundColor Yellow
	$publicFiles = $publicFiles | Where-Object { 
		$fileName = $_.BaseName
		$CommandName -contains $fileName
	}
	Write-Host "After filtering: $($publicFiles.Count) files" -ForegroundColor Yellow
}
foreach ($file in $publicFiles) {
	Write-Host "Examining file: $($file.FullName)" -ForegroundColor Magenta
	$content = Get-Content -Path $file.FullName -Raw
	if ([string]::IsNullOrWhiteSpace($content)) {
		Write-Host "  Skipping: empty content" -ForegroundColor Gray
		continue
	}
	$functionMatch = [regex]::Match($content, 'function\s+(?<name>[^\s\{]+)')
	if (-not $functionMatch.Success) {
		Write-Host "  Skipping: no function found" -ForegroundColor Gray
		continue
	}
	$commandName = $functionMatch.Groups['name'].Value
	Write-Host "  Found function: $commandName" -ForegroundColor Green
	if ($CommandName -and $CommandName.Count -gt 0 -and $CommandName -notcontains $commandName) {
		Write-Host "  Skipping: function name doesn't match filter" -ForegroundColor Gray
		continue
	}

	$metaMatch = [regex]::Match($content, "\[MetadataAttribute\(\s*'(?<path>[^']+)'\s*,\s*'(?<method>[^']+)'\s*\)\]", [System.Text.RegularExpressions.RegexOptions]::Singleline)
	if (-not $metaMatch.Success) {
		Write-Host "  Skipping: no MetadataAttribute" -ForegroundColor Gray
		continue
	}
	$path = $metaMatch.Groups['path'].Value
	$method = $metaMatch.Groups['method'].Value.ToLowerInvariant()
	Write-Host "  Metadata: $path ($method)" -ForegroundColor Green
	if ($EndpointPath -and $path -ne $EndpointPath) {
		Write-Host "  Skipping: endpoint doesn't match filter" -ForegroundColor Gray
		continue
	}
	if (@('post', 'put', 'patch') -notcontains $method) {
		Write-Host "  Skipping: method is not POST/PUT/PATCH" -ForegroundColor Gray
		continue
	}

	$pathItem = $openApi.paths[$path]
	if (-not $pathItem) {
		Write-Host "  Skipping: path not found in OpenAPI" -ForegroundColor Red
		continue
	}
	$methodItem = $pathItem[$method]
	if (-not $methodItem) {
		Write-Host "  Skipping: method not found in OpenAPI path" -ForegroundColor Red
		continue
	}
	if (-not $methodItem.requestBody) {
		Write-Host "  Skipping: no requestBody in OpenAPI" -ForegroundColor Red
		continue
	}
	$contentMap = $methodItem.requestBody.content
	if (-not $contentMap) {
		Write-Host "  Skipping: no content in requestBody" -ForegroundColor Red
		continue
	}
	$schema = $null
	if ($contentMap.'application/json' -and $contentMap.'application/json'.schema) {
		$schema = $contentMap.'application/json'.schema
		Write-Host "  Found application/json schema" -ForegroundColor Green
	} elseif ($contentMap.PSObject.Properties.Count -gt 0) {
		$schema = $contentMap.PSObject.Properties[0].Value.schema
		Write-Host "  Found schema from first content type" -ForegroundColor Green
	}
	if (-not $schema) {
		Write-Host "  Skipping: no schema found" -ForegroundColor Red
		continue
	}

	$exampleObject = New-ExampleFromSchema -Schema $schema -Schemas $schemas -Visited @{}
	if (-not $exampleObject) {
		Write-Host "  Skipping: could not generate example from schema" -ForegroundColor Red
		continue
	}
	Write-Host "  Generated example object" -ForegroundColor Green
	$bodyParam = Get-BodyParameterName -Content $content
	$pathParams = Get-PathParameters -Content $content -Path $path
	
	$exampleBlock = Build-FullRequestExampleBlock -CommandName $commandName -BodyParam $bodyParam -ExampleObject $exampleObject -PathParameters $pathParams
	$updatedContent = Update-HelpBlock -Content $content -ExampleBlock $exampleBlock

	Write-Host "Processing: $commandName at $path ($method)" -ForegroundColor Cyan
	Write-Host "Content length: $($content.Length), Updated length: $($updatedContent.Length)" -ForegroundColor Yellow
	
	if ($updatedContent -ne $content) {
		Write-Host "Changes detected, updating file..." -ForegroundColor Green
		if ($PSCmdlet.ShouldProcess($file.FullName, 'Update full request example')) {
			# Write a preview of what's being saved
			$previewLines = ($updatedContent -split "`r?`n") | Select-Object -First 20
			Write-Host "Preview of updated content (first 20 lines):" -ForegroundColor Cyan
			$previewLines | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
			
			Set-Content -Path $file.FullName -Value $updatedContent
			Write-Host "File updated successfully!" -ForegroundColor Green
		}
	} else {
		Write-Host "No changes needed (content identical)" -ForegroundColor Gray
	}
}
