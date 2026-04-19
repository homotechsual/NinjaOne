function Get-NinjaOneSoftwareLicenseAssignments {
	<#
		.SYNOPSIS
			Gets software license assignments.
		.DESCRIPTION
			Retrieves assignments for a software license from the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License Assignments
		.EXAMPLE
			PS> Get-NinjaOneSoftwareLicenseAssignments -licenseId 1

			Gets assignments for software license 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwarelicenseassignments
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoosla')]
	[MetadataAttribute(
		'/v2/software-license/{licenseId}/assignments',
		'get'
	)]
	param(
		# Software license ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$licenseId
	)
	process {
		try {
			$Resource = ('v2/software-license/{0}/assignments' -f $licenseId)
			$Results = New-NinjaOneGETRequest -Resource $Resource
			if ($Results) {
				return $Results
			} else {
				throw ('No assignments found for software license {0}.' -f $licenseId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
