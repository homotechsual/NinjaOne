function New-NinjaOneContact {
	<#
		.SYNOPSIS
			Creates a new system contact.
		.DESCRIPTION
			Creates a new system contact via the NinjaOne v2 API.
		.FUNCTIONALITY
			Contacts
		.OUTPUTS
			A PowerShell object containing the created contact.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/contact
		.EXAMPLE
			PS> New-NinjaOneContact -contact @{ firstName = 'Jane'; lastName = 'Doe'; email = 'jane@example.com' }

			Creates a new system contact.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoc')]
	[MetadataAttribute(
		'/v2/contacts',
		'post'
	)]
	param(
		# Contact object payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$contact
	)
	process {
		try {
			$Resource = 'v2/contacts'
			$RequestParams = @{
				Resource = $Resource
				Body = $contact
			}
			if ($PSCmdlet.ShouldProcess('Contact', 'Create')) {
				$Create = New-NinjaOnePOSTRequest @RequestParams
				return $Create
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
