using namespace System.Management.Automation
class NinjaOneTicketBoardFilter {
    [String]$Field
    [FilterOperator]$Operator
    [Object]$Value

    NinjaOneTicketBoardFilter([String]$Field, [String]$Operator, [Object]$Value) {
        if ($Value -isnot [string] -and $Value -isnot [int]) {
            throw [MetadataException]::new("Value must be a string or integer.")
        }
        if ($Operator -in @('present', 'not_present') -and ($null -ne $Value)) {
            throw [MetadataException]::new("Operator '$Operator' does not accept a value.")
        }
        if ($Operator -notin @('present', 'not_present') -and ($null -eq $Value)) {
            throw [MetadataException]::new("Operator '$Operator' requires a value.")
        }
        if ($Operator -in @('greater_than', 'less_than', 'greater_or_equal_than', 'less_or_equal_than') -and ($Value -isnot [Int])) {
            throw [MetadataException]::new("Operator '$Operator' requires a numeric value.")
        }
        if ($Operator -in @('contains_any', 'contains_none') -and ($Value -notlike '*,*')) {
            throw [MetadataException]::new("Operator '$Operator' requires a value in the format 'value1,value2,value3'.")
        }
        if ($Operator -eq 'between' -and ($Value -notlike '*:*')) {
            throw [MetadataException]::new("Operator '$Operator' requires a value in the format 'start:end'.")
        }
        if ($Operator -eq 'is' -and ($Value -notlike '*:is')) {
            throw [MetadataException]::new("Operator '$Operator' requires a value in the format 'property:is'.")
        }
        # ToDo: Get clarification on the in and not_in operators from NinjaOne. Support request #279234
        #if ($Operator -in @('in', 'not_in')) {
        #    throw [MetadataException]::new("Operator '$Operator' requires a value in the format 'property:value'.")
        #}
        $this.Field = $Field
        $this.Operator = $Operator
        $this.Value = $Value
    }
}