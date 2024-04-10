function New-NinjaOneCustomFieldObject {
    <#
        .SYNOPSIS
            Create a new Custom Field object.
        .DESCRIPTION
            Creates a new Custom Field object containing required / specified properties / structure.
        .OUTPUTS
            [CustomField]

            A new Custom Field object.
    #>
    [CmdletBinding()]
    [OutputType([CustomField])]
    [Alias('nnodtfo')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
    param(
        # The custom field name.
        [Parameter(Mandatory, Position = 0)]
        [String]$Name,
        # The custom field value.
        [Parameter(Mandatory, Position = 1)]
        [Object]$Value,
        # Is the custom field value HTML.
        [Parameter(Position = 2)]
        [Bool]$IsHTML
    )
    process {
        if ($IsHTML) {
            $OutputObject = [PSCustomObject]@{
                name = $Name
                value = @{ html = $Value }
            }
        } else {
            $OutputObject = [PSCustomObject]@{
                name = $Name
                value = $Value
            }
        }
        $OutputObject.PSTypeNames.Insert(0, 'CustomField')
        return $OutputObject
    }
}