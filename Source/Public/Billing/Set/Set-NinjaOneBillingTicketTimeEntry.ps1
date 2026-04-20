function Set-NinjaOneBillingTicketTimeEntry {
	<#
		.SYNOPSIS
			Updates a billing ticket time entry.
		.DESCRIPTION
			Updates a billing ticket time entry using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Time Entry
		.EXAMPLE
			PS> Set-NinjaOneBillingTicketTimeEntry -timeEntryId 1 -timeEntry @{ billable = $true }

			Updates billing ticket time entry 1.
		.OUTPUTS
			A PowerShell object containing the updated time entry.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billingtickettimeentry
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobtte')]
	[MetadataAttribute(
		'/v2/billing/ticket-time-entry/{timeEntryId}',
		'put'
	)]
	param(
		# Time entry ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$timeEntryId,
		# Time entry payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$timeEntry
	)
	process {
		try {
			$Resource = ('v2/billing/ticket-time-entry/{0}' -f $timeEntryId)
			$RequestParams = @{ Resource = $Resource; Body = $timeEntry }
			if ($PSCmdlet.ShouldProcess(('Billing Ticket Time Entry {0}' -f $timeEntryId), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
