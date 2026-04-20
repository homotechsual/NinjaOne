function New-NinjaOneTicketBoardSort {
	<#
		.SYNOPSIS
			Create a new Ticket Board sort object.
		.DESCRIPTION
			Creates a sort object for ticket board queries with validation.
		.FUNCTIONALITY
			Ticket Board Sort Object Helper
		.OUTPUTS
			[Object]
		.EXAMPLE
			PS> New-NinjaOneTicketBoardSort -field 'created' -direction 'asc'
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('nnotbs')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The field to sort by.
		[Parameter(Mandatory, Position = 0)]
		[String]$field,
		# The sort direction.
		[Parameter(Mandatory, Position = 1)]
		[ValidateSet('asc', 'desc')]
		[String]$direction
	)
	process {
		$sort = [PSCustomObject]@{
			Field = $field
			Direction = $direction
		}
		$sort.PSTypeNames.Insert(0, 'NinjaOneTicketBoardSort')
		return $sort
	}
}
