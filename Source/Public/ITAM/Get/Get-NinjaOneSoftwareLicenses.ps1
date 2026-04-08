function Get-NinjaOneSoftwareLicenses {
	<#
		.SYNOPSIS
			Gets software licenses.
		.DESCRIPTION
			Retrieves software licenses from the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> Get-NinjaOneSoftwareLicenses

			Gets all software licenses.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwarelicenses
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoosls')]
	[MetadataAttribute(
		'/v2/software-license/licenses',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param()
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$RequestParams = @{
				Resource = 'v2/software-license/licenses'
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No software licenses found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
