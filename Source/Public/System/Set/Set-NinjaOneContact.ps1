function Set-NinjaOneContact {
	<#
		.SYNOPSIS
			Updates a system contact.
		.DESCRIPTION
			Updates a system contact via the NinjaOne v2 API.
		.FUNCTIONALITY
			Contacts
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/contact
		.EXAMPLE
			PS> Set-NinjaOneContact -Id 123 -contact @{ phone = '+3100000000' }

			Updates the system contact with Id 123.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoc')]
	[MetadataAttribute(
		'/v2/contact/{id}',
		'patch'
	)]
	param(
		# Contact Id to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		# Contact patch payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$contact
	)
	process {
		try {
			$Resource = ('v2/contact/{0}' -f $id)
			$RequestParams = @{
				Resource = $Resource
				Body = $contact
			}
			if ($PSCmdlet.ShouldProcess(('Contact {0}' -f $id), 'Update')) {
				$Update = New-NinjaOnePATCHRequest @RequestParams
				return $Update
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
