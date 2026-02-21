<#
	.SYNOPSIS
		Represents a NinjaOne ticket board filter object.

	.DESCRIPTION
		Defines the structure for filtering ticket board queries.
		Provides validation for filter operators and values.

	.NOTES
		This class is used for creating strongly-typed filter objects
		for ticket board API queries.
#>
class NinjaOneTicketBoardFilter {
	[String]$Field
	[String]$Operator
	[Object]$Value

	# Full constructor with validation
	NinjaOneTicketBoardFilter(
		[String]$Field,
		[String]$Operator,
		[Object]$Value
	) {
		$validOperators = @('present', 'not_present', 'is', 'is_not', 'contains', 'not_contains', 'contains_any', 'contains_none', 'greater_than', 'less_than', 'greater_or_equal_than', 'less_or_equal_than', 'between', 'in', 'not_in')
		if ($Operator -notin $validOperators) {
			throw [System.ArgumentException]::new("Operator '$Operator' is not valid.")
		}
		# Validate operator/value combinations
		if ($Operator -in @('present', 'not_present') -and ($null -ne $Value)) {
			throw [System.ArgumentException]::new("Operator '$Operator' does not accept a value.")
		}
		if ($Operator -notin @('present', 'not_present') -and ($null -eq $Value)) {
			throw [System.ArgumentException]::new("Operator '$Operator' requires a value.")
		}
		if ($Operator -in @('greater_than', 'less_than', 'greater_or_equal_than', 'less_or_equal_than') -and ($Value -isnot [Int])) {
			throw [System.ArgumentException]::new("Operator '$Operator' requires a numeric value.")
		}
		if ($Operator -in @('contains_any', 'contains_none') -and ($Value -notlike '*,*')) {
			throw [System.ArgumentException]::new("Operator '$Operator' requires CSV format.")
		}
		if ($Operator -eq 'between' -and ($Value -notlike '*:*')) {
			throw [System.ArgumentException]::new("Operator '$Operator' requires start:end format.")
		}
		$this.Field = $Field
		$this.Operator = $Operator
		$this.Value = $Value
	}
}
