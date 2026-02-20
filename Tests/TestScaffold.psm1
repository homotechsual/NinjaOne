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