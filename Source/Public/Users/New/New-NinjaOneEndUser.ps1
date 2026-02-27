function New-NinjaOneEndUser {
	<#
		.SYNOPSIS
			Creates a new end user.
		.DESCRIPTION
			Creates a new end user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> New-NinjaOneEndUser -endUser @{ firstName = 'Jane'; lastName = 'Doe'; email = 'jane@example.com' }

			Creates a new end user.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				firstName = "string"
				lastName = "string"
				email = "string"
				phone = "string"
				organizationId = 0
				fullPortalAccess = $false
			}
			PS> New-NinjaOneEndUser -endUser $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created end user.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/enduser
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoeu')]
	[MetadataAttribute(
		'/v2/user/end-users',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# End user payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$endUser,
		# Send invitation to end user during creation.
		[Switch]$sendInvitation
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($endUser) { $Parameters.Remove('endUser') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			
			$Resource = 'v2/user/end-users'
			$RequestParams = @{ Resource = $Resource; Body = $endUser }
			if ($QSCollection) { $RequestParams.QSCollection = $QSCollection }
			if ($PSCmdlet.ShouldProcess('EndUser', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}



























