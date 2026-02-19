function Get-NinjaOneTechnician {
	<#
		.SYNOPSIS
			Gets a technician by Id.
		.DESCRIPTION
			Retrieves a specific technician via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneTechnician -Id 77

			Gets the technician with Id 77.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/technician
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotec')]
	[MetadataAttribute(
		'/v2/user/technician/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
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
			$Resource = ('v2/user/technician/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('Technician {0} not found.' -f $id) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

