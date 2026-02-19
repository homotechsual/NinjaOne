function Get-NinjaOneContact {
	<#
		.SYNOPSIS
			Gets a system contact by Id.
		.DESCRIPTION
			Retrieves a system contact by Id from the NinjaOne v2 API.
		.FUNCTIONALITY
			Contacts
		.EXAMPLE
			PS> Get-NinjaOneContact -Id 123

			Gets the system contact with Id 123.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contact
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnocontact')]
	[MetadataAttribute(
		'/v2/contact/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The contact Id to retrieve.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('contactId')]
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
			$Resource = ('v2/contact/{0}' -f $id)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) {
				return $Result
			} else {
				throw ('Contact with id {0} not found.' -f $id)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
