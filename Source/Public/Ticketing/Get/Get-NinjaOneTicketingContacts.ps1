function Get-NinjaOneTicketingContacts {
	<#
		.SYNOPSIS
			Gets ticketing contacts from the NinjaOne API.
		.DESCRIPTION
			Retrieves ticketing contacts from the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticketing Contacts
		.EXAMPLE
			PS> Get-NinjaOneTicketingContacts

			Gets all ticketing contacts.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketingcontacts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotc')]
	[MetadataAttribute(
		'/v2/ticketing/contact/contacts',
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
			$Resource = 'v2/ticketing/contact/contacts'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Contacts = New-NinjaOneGETRequest @RequestParams
			if ($Contacts) {
				return $Contacts
			}

			throw 'No ticketing contacts found.'
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
