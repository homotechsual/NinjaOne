<#
	.SYNOPSIS
		Represents a NinjaOne ticket board sort object.

	.DESCRIPTION
		Defines the structure for sorting ticket board queries.
		Provides type validation for sort field and direction.

	.NOTES
		This class is used for creating strongly-typed sort objects
		for ticket board API queries.
#>
class NinjaOneTicketBoardSort {
	[String]$Field
	[String]$Direction

	# Full constructor
	NinjaOneTicketBoardSort(
		[String]$Field,
		[String]$Direction
	) {
		if ($Direction -notmatch '^(asc|desc)$') {
			throw [System.ArgumentException]::new("Direction must be 'asc' or 'desc'")
		}
		$this.Field = $Field
		$this.Direction = $Direction
	}
}
