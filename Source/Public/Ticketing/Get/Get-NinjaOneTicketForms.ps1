function Get-NinjaOneTicketForms {
	<#
		.SYNOPSIS
			Gets ticket forms from the NinjaOne API.
		.DESCRIPTION
			Retrieves ticket forms from the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket Forms
		.EXAMPLE
			PS> Get-NinjaOneTicketForms

			Gets all ticket forms.
		.EXAMPLE
			PS> Get-NinjaOneTicketForms -ticketFormId 1

			Gets ticket form with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketforms
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotf')]
	[MetadataAttribute(
		'/v2/ticketing/ticket-form',
		'get',
		'/v2/ticketing/ticket-form/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Ticket form id.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$ticketFormId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($ticketFormId) {
				Write-Verbose ('Getting ticket form with id {0}.' -f $ticketFormId)
				$Resource = ('/v2/ticketing/ticket-form/{0}' -f $ticketFormId)
			} else {
				Write-Verbose 'Retrieving ticket forms'
				$Resource = '/v2/ticketing/ticket-form'
			}
			$RequestParams = @{
				QSCollection = $QSCollection
				Resource = $Resource
			}
			$TicketForms = New-NinjaOneGETRequest @RequestParams
			if ($TicketForms) {
				return $TicketForms
			} else {
				throw 'No ticket forms found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}