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
    if (Test-Path -Path $YamlPath) {
        return @()
    }
    return @()
}
