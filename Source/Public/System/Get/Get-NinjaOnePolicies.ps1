
function Get-NinjaOnePolicies {
	<#
		.SYNOPSIS
			Gets policies from the NinjaOne API.
		.DESCRIPTION
			Retrieves policies from the NinjaOne v2 API.
		.FUNCTIONALITY
			Policies
		.EXAMPLE
			PS> Get-NinjaOnePolicies

			Gets all policies.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/policies
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnop')]
	[MetadataAttribute(
		'/v2/policies',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param()
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Retrieving all policies.'
			$Resource = 'v2/policies'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$PolicyResults = New-NinjaOneGETRequest @RequestParams
			if ($PolicyResults) {
				return $PolicyResults
			} else {
				throw 'No policies found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}