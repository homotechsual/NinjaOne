function Remove-NinjaOneContact {
	<#
		.SYNOPSIS
			Removes a system contact.
		.DESCRIPTION
			Deletes a system contact via the NinjaOne v2 API.
		.FUNCTIONALITY
			Contacts
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/contact
		.EXAMPLE
			PS> Remove-NinjaOneContact -Id 123 -Confirm:$false

			Deletes the system contact with Id 123.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoc')]
	[MetadataAttribute(
		'/v2/contact/{id}',
		'delete'
	)]
	param(
		# Contact Id to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('contactId')]
		[Int]$id
	)
	process {
		try {
			$Resource = ('v2/contact/{0}' -f $id)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Contact {0}' -f $id), 'Delete')) {
				$Delete = New-NinjaOneDELETERequest @RequestParams
				if ($Delete -eq 204) {
					Write-Information ('Contact {0} deleted successfully.' -f $id)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
