function Remove-NinjaOneEndUser {
	<#
		.SYNOPSIS
			Removes an end-user.
		.DESCRIPTION
			Deletes an end-user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/enduser
		.EXAMPLE
			PS> Remove-NinjaOneEndUser -Id 42 -Confirm:$false

			Deletes the end-user with Id 42.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoeu')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}',
		'delete'
	)]
	Param(
		# End-user Id to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$id
	)
	process {
		try {
			$Resource = ('v2/user/end-user/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('End-user {0}' -f $id), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('End-user {0} deleted successfully.' -f $id) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
