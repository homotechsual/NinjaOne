function Get-NinjaOneEndUserCustomFields {
	<#
		.SYNOPSIS
			Gets custom fields for an end user.
		.DESCRIPTION
			Retrieves the list of custom fields for an end user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneEndUserCustomFields -Id 101

			Gets custom fields for end user 101.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/enduser-customfields
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoeucf')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}/custom-fields',
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
			$Resource = ('v2/user/end-user/{0}/custom-fields' -f $id)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('No custom fields found for end user {0}.' -f $id) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

