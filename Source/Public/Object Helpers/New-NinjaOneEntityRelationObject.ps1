function New-NinjaOneEntityRelationObject {
	<#
		.SYNOPSIS
			Create a new Entity Relation object.
		.DESCRIPTION
			Creates a new Entity Relation object containing required / specified properties / structure.
		.FUNCTIONALITY
			Entity Relation Object Helper
		.OUTPUTS
			[Object]

			A new Document Template Field or UI Element object.
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('nnoer')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The entity type of the relation.
		[EntityType]$Entity,
		[EntityType]$relationEntityType,
		[FilterOperator]$Operator,
		[ValidateStringOrInt()][Object]$Value
	)

	NinjaOneTicketBoardFilter([String]$Field, [String]$Operator, [Object]$Value) {
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