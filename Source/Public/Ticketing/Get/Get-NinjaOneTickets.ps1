function Get-NinjaOneTickets {
	<#
		.SYNOPSIS
			Gets tickets from the NinjaOne API.
		.DESCRIPTION
			Retrieves tickets from the NinjaOne v2 API.
		.FUNCTIONALITY
			Tickets
		.EXAMPLE
			PS> Get-NinjaOneTickets -ticketId 1

			Gets the ticket with id 1.
		.EXAMPLE
			PS> Get-NinjaOneTickets -boardId 1

			Gets all tickets for the board with id 1.
		.EXAMPLE
			PS> Get-NinjaOneTickets -boardId 1 -filters @{status = 'open'}

			Gets all open tickets for the board with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tickets
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnot')]
	[MetadataAttribute(
		'/v2/ticketing/ticket/{ticketId}',
		'get',
		'/v2/ticketing/trigger/board/{boardId}/run',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The ticket id to get.
		[Parameter(Mandatory, ParameterSetName = 'Single', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$ticketId,
		# The board id to get tickets for.
		[Parameter(Mandatory, ParameterSetName = 'Board', Position = 0, ValueFromPipeline)]
		[String]$boardId,
		# The sort rules to apply to the request. Create these using `[NinjaOneTicketBoardSort]::new()`.
		[Parameter(ParameterSetName = 'Board', Position = 1)]
		[NinjaOneTicketBoardSort[]]$sort,
		# Any filters to apply to the request. Create these using `[NinjaOneTicketBoardFilter]::new()`.
		[Parameter(ParameterSetName = 'Board', Position = 2)]
		[NinjaOneTicketBoardFilter[]]$filters,
		# The last cursor id to use for the request.
		[Parameter(ParameterSetName = 'Board', Position = 3)]
		[String]$lastCursorId,
		# The number of results to return.
		[Parameter(ParameterSetName = 'Board', Position = 4)]
		[Int]$pageSize,
		# The search criteria to apply to the request.
		[Parameter(ParameterSetName = 'Board', Position = 5)]
		[String]$searchCriteria,
		# Inclue the given columns in the response.
		[Parameter(ParameterSetName = 'Board', Position = 6)]
		[String[]]$includeColumns,
		# Include the metadata in the response.
		[Parameter(ParameterSetName = 'Board', Position = 7)]
		[Switch]$includeMetadata
	)
	begin {
	}
	process {
		try {
			if ($ticketId) {
				Write-Verbose ('Getting ticket with id {0}.' -f $ticketId)
				$Resource = ('v2/ticketing/ticket/{0}' -f $ticketId)
				$Method = 'GET'
			} else {
				Write-Verbose ('Getting tickets for board with id {0}.' -f $boardId)
				$Resource = ('v2/ticketing/trigger/board/{0}/run' -f $boardId)
				$Method = 'POST'
			}
			$RequestParams = @{
				Resource = $Resource
			}
			if ($QSCollection) {
				$RequestParams.QSCollection = $QSCollection
			}
			if ($PSCmdlet.ParameterSetName -eq 'Board') {
				$RequestParams.Body = [hashtable]@{}
			}
			if ($sort) {
				$RequestParams.Body.sort = $sort
			}
			if ($filters) {
				$RequestParams.Body.filters = $filters
			}
			if ($pageSize) {
				$RequestParams.Body.pageSize = $pageSize
			}
			if ($searchCriteria) {
				$RequestParams.Body.searchCriteria = $searchCriteria
			}
			if ($includeColumns) {
				$RequestParams.Body.includeColumns = $includeColumns
			}
			if ($lastCursorId) {
				$RequestParams.Body.lastCursorId = $lastCursorId
			}
			if ($Method -eq 'GET') {
				$Tickets = New-NinjaOneGETRequest @RequestParams
			} elseif ($Method -eq 'POST') {
				$Tickets = New-NinjaOnePOSTRequest @RequestParams
			}
			if ($Tickets) {
				if ($includeMetadata -or $PSCmdlet.ParameterSetName -ne 'Board') {
					Write-Verbose 'Returning full response.'
					return $Tickets
				} else {
					# Return just the `data` property which lists the tickets.
					Write-Verbose 'Returning just the ticket data.'
					return $Tickets.data
				}
			} else {
				throw 'No tickets found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}