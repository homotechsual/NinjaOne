function Get-NinjaOneEndUser {
	<#
		.SYNOPSIS
			Gets an end user by Id.
		.DESCRIPTION
			Retrieves a specific end user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneEndUser -Id 101

			Gets the end user with Id 101.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/enduser
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoeu')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$id
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($id) { $Parameters.Remove('id') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/user/end-user/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) {
				return $Result
			} else {
				throw ('End user {0} not found.' -f $id)
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

