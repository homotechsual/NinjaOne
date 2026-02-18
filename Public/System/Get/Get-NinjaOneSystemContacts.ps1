function Get-NinjaOneSystemContacts {
	<#
		.SYNOPSIS
			Gets system contacts from the NinjaOne API.
		.DESCRIPTION
			Retrieves system contacts from the NinjaOne v2 API.
		.FUNCTIONALITY
			Contacts
		.EXAMPLE
			PS> Get-NinjaOneSystemContacts

			Gets all system contacts.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnosc')]
	[MetadataAttribute(
		'/v2/contacts',
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
			$Resource = 'v2/contacts'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No system contacts found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}

