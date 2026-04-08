function Set-NinjaOneBillingTicketTimeEntry {
	<#
		.SYNOPSIS
			Updates a billing ticket time entry.
		.DESCRIPTION
			Updates a billing ticket time entry using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Time Entry
		.EXAMPLE
			PS> Set-NinjaOneBillingTicketTimeEntry -TimeEntryId 1 -TimeEntry @{ billable = $true }

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
		[Int]$TimeEntryId,
		# Time entry payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$TimeEntry
	)
	process {
		try {
			$Resource = ('v2/billing/ticket-time-entry/{0}' -f $TimeEntryId)
			$RequestParams = @{ Resource = $Resource; Body = $TimeEntry }
			if ($PSCmdlet.ShouldProcess(('Billing Ticket Time Entry {0}' -f $TimeEntryId), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
