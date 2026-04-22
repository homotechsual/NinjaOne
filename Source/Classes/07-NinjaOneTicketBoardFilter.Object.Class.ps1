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
	[String]$field
	[String]$operator
	[Object]$value

	# Full constructor with validation
	NinjaOneTicketBoardFilter(
		[String]$field,
		[String]$operator,
		[Object]$value
	) {
		$validOperators = @('present', 'not_present', 'is', 'is_not', 'contains', 'not_contains', 'contains_any', 'contains_none', 'greater_than', 'less_than', 'greater_or_equal_than', 'less_or_equal_than', 'between', 'in', 'not_in')
		if ($operator -notin $validOperators) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' is not valid.' -f $operator))
		}
		# Validate operator/value combinations
		if ($operator -in @('present', 'not_present') -and ($null -ne $value)) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' does not accept a value.' -f $operator))
		}
		if ($operator -notin @('present', 'not_present') -and ($null -eq $value)) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' requires a value.' -f $operator))
		}
		if ($operator -in @('greater_than', 'less_than', 'greater_or_equal_than', 'less_or_equal_than') -and ($value -isnot [Int])) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' requires a numeric value.' -f $operator))
		}
		if ($operator -in @('contains_any', 'contains_none') -and ($value -notlike '*,*')) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' requires CSV format.' -f $operator))
		}
		if ($operator -eq 'between' -and ($value -notlike '*:*')) {
			throw [System.ArgumentException]::new(('Operator ''{0}'' requires start:end format.' -f $operator))
		}
		$this.Field = $field
		$this.Operator = $operator
		$this.Value = $value
	}
}
