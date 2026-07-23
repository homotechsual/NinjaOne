function Set-NinjaOneSoftwareLicenseAssignmentsLastUsage {
	<#
		.SYNOPSIS
			Updates last-usage data for software license assignments.
		.DESCRIPTION
			Updates software license assignment last-usage data via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License Assignments
		.EXAMPLE
			PS> Set-NinjaOneSoftwareLicenseAssignmentsLastUsage -assignmentUsage @{ assignments = @() }

			Updates software license assignment last-usage data.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarelicenseassignments-lastusage
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snooslal')]
	[MetadataAttribute(
		'/v2/software-license/assignments/last-usage',
		'put'
	)]
	param(
		# The payload containing software license assignment last-usage updates.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$assignmentUsage
	)
	process {
		try {
			$Resource = 'v2/software-license/assignments/last-usage'
			$RequestParams = @{ Resource = $Resource; Body = $assignmentUsage }
			if ($PSCmdlet.ShouldProcess('Software License Assignments', 'Update Last Usage')) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
