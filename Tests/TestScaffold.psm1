<#
.SYNOPSIS
Get AllMetadata.

.DESCRIPTION
Internal helper function for Get-AllMetadata operations.

This function provides supporting functionality for the NinjaOne module.

.PARAMETER Parameter1
    Describes the first parameter.

.PARAMETER Parameter2
    Describes the second parameter.

.EXAMPLE
    PS> Get-AllMetadata

    get the specified AllMetadata.

.OUTPUTS
Returns information about the AllMetadata resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
function Get-AllMetadata {
    $FunctionList = Get-FunctionList
    $AllMetadata = foreach ($Function in $FunctionList) {
        $AST = $Function.ScriptBlock.Ast
        $MetadataElement = Get-MetadataElement -AST $AST
        $PositionalArguments = Get-PositionalArguments -MetadataElement $MetadataElement
        $Metadata = Get-Metadata -PositionalArguments $PositionalArguments
        $Metadata
    }
    return $AllMetadata
}

<#
.SYNOPSIS
Import the module being tested.

.DESCRIPTION
Imports the NinjaOne module from the output directory for testing.
#>
function Import-ModuleToBeTested {
    $ParentPath = Split-Path -Parent -Path $PSScriptRoot
    $ModulePath = Join-Path -Path $ParentPath -ChildPath 'Output\NinjaOne\2.0.5\NinjaOne.psd1'
    if (Test-Path -Path $ModulePath) {
        Import-Module -Name $ModulePath -Force
    }
}

<#
.SYNOPSIS
Get the module name.

.DESCRIPTION
Returns the name of the module being tested.
#>
function Get-ModuleName {
    return 'NinjaOne'
}

<#
.SYNOPSIS
Get the list of exported functions.

.DESCRIPTION
Returns the list of exported functions from the NinjaOne module.
#>
function Get-FunctionList {
    $Module = Get-Module -Name 'NinjaOne'
    if ($Module) {
        return $Module.ExportedFunctions.Values
    }
    return @()
}

<#
.SYNOPSIS
Get the list of API endpoints.

.DESCRIPTION
Returns the list of API endpoints from the ninjaOne-API-core-resources.yaml file.
#>
function Get-Endpoints {
    $ParentPath = Split-Path -Parent -Path $PSScriptRoot
    $YamlPath = Join-Path -Path $ParentPath -ChildPath 'ninjaOne-API-core-resources.yaml'
    
    if (-not (Test-Path -Path $YamlPath)) {
        return @()
    }

    try {
        $YamlContent = Get-Content -Path $YamlPath -Raw
        
        # Simple YAML parser for paths section
        $PathMatches = [regex]::Matches($YamlContent, '^\s{2}(/[^:]+):', [System.Text.RegularExpressions.RegexOptions]::Multiline)
        
        $Endpoints = @()
        
        foreach ($PathMatch in $PathMatches) {
            $Path = $PathMatch.Groups[1].Value
            $PathIndex = $YamlContent.IndexOf("  $Path`:")
            if ($PathIndex -eq -1) { continue }
            
            $NextPathIndex = $YamlContent.IndexOf("`n  /", $PathIndex + 1)
            if ($NextPathIndex -eq -1) { $NextPathIndex = $YamlContent.Length }
            
            $PathSection = $YamlContent.Substring($PathIndex, $NextPathIndex - $PathIndex)
            $MethodMatches = [regex]::Matches($PathSection, '^\s{4}(get|post|patch|put|delete|options|head)\s*:', [System.Text.RegularExpressions.RegexOptions]::Multiline)
            
            foreach ($MethodMatch in $MethodMatches) {
                $Method = $MethodMatch.Groups[1].Value
                $Endpoints += [PSCustomObject]@{
                    Path   = $Path
                    Method = $Method.ToLower()
                }
            }
        }
        
        return @($Endpoints)
    } catch {
        Write-Warning "Error parsing YAML endpoints: $_"
        return @()
    }
}

<#
.SYNOPSIS
Extract string value from AST expression.

.DESCRIPTION
Recursively extracts string values from AST expression objects.
#>
function Get-AstStringValue {
    param(
        [Parameter(Mandatory)]
        $Expression
    )

    if ($null -eq $Expression) {
        return $null
    }

    if ($Expression -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
        return $Expression.Value
    }

    if ($Expression -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
        return $Expression.Value
    }

    if ($Expression -is [System.Management.Automation.Language.UnaryExpressionAst]) {
        return Get-AstStringValue -Expression $Expression.Child
    }

    if ($Expression -is [System.Management.Automation.Language.BinaryExpressionAst]) {
        $left = Get-AstStringValue -Expression $Expression.Left
        $right = Get-AstStringValue -Expression $Expression.Right
        return "$left$right"
    }

    if ($Expression -is [System.Management.Automation.Language.ArrayExpressionAst]) {
        return Get-AstStringValue -Expression $Expression.SubExpression
    }

    if ($Expression -is [System.Management.Automation.Language.ParenthesizedExpressionAst]) {
        return Get-AstStringValue -Expression $Expression.Pipeline
    }

    if ($Expression -is [System.Management.Automation.Language.PipelineAst]) {
        if ($Expression.PipelineElements -and $Expression.PipelineElements.Count -gt 0) {
            return Get-AstStringValue -Expression $Expression.PipelineElements[0]
        }
    }

    if ($Expression -is [System.Management.Automation.Language.CommandExpressionAst]) {
        return Get-AstStringValue -Expression $Expression.Expression
    }

    if ($Expression | Get-Member -Name Value -ErrorAction SilentlyContinue) {
        return $Expression.Value
    }

    return $null
}

<#
.SYNOPSIS
Get metadata attribute elements from function AST.

.DESCRIPTION
Extracts all MetadataAttribute declarations from a function's Abstract Syntax Tree.
#>
function Get-MetadataElement {
    param(
        [Parameter(Mandatory)]
        $AST
    )

    if ($AST -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
        $AST = $AST.Body
    }

    $MetadataAttributes = @()
    if ($AST.ParamBlock) {
        $MetadataAttributes = $AST.ParamBlock.Attributes | Where-Object {
            $_.TypeName.Name -eq 'MetadataAttribute'
        }
    }

    if ($MetadataAttributes) {
        return @($MetadataAttributes)
    }
    return @()
}

<#
.SYNOPSIS
Extract positional arguments from a metadata attribute.

.DESCRIPTION
Gets the positional arguments passed to a MetadataAttribute.
#>
function Get-PositionalArguments {
    param(
        [Parameter(Mandatory)]
        $MetadataElement
    )

    if (-not $MetadataElement -or $MetadataElement.Count -eq 0) {
        return @()
    }

    $AllPositionalArgs = @()
    foreach ($Element in $MetadataElement) {
        if ($Element.PositionalArguments) {
            foreach ($Arg in $Element.PositionalArguments) {
                $AllPositionalArgs += $Arg
            }
        }
    }

    return @($AllPositionalArgs)
}

<#
.SYNOPSIS
Convert positional arguments to metadata pairs.

.DESCRIPTION
Converts positional arguments from MetadataAttribute into structured metadata objects
with Endpoint and Method properties.
#>
function Get-Metadata {
    param(
        [Parameter(Mandatory)]
        $PositionalArguments
    )

    if (-not $PositionalArguments -or $PositionalArguments.Count -eq 0) {
        return @()
    }

    $Metadata = @()
    
    for ($i = 0; $i -lt $PositionalArguments.Count; $i += 2) {
        if ($i + 1 -lt $PositionalArguments.Count) {
            $EndpointArg = $PositionalArguments[$i]
            $MethodArg = $PositionalArguments[$i + 1]
            
            $Endpoint = Get-AstStringValue -Expression $EndpointArg
            $Method = Get-AstStringValue -Expression $MethodArg
            
            if ($Endpoint -and $Method) {
                $Metadata += [PSCustomObject]@{
                    Endpoint = $Endpoint
                    Method   = $Method
                }
            }
        }
    }

    return @($Metadata)
}
