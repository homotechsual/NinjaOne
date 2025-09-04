function Remove-NinjaOneTechnician {
	<#
		.SYNOPSIS
			Removes a technician user.
		.DESCRIPTION
			Deletes a technician user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/technician
		.EXAMPLE
			PS> Remove-NinjaOneTechnician -Id 7 -Confirm:$false

			Deletes the technician user with Id 7.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnot')]
	[MetadataAttribute(
		'/v2/user/technician/{id}',
		'delete'
	)]
	Param(
		# Technician Id to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$id
	)
	process {
		try {
			$Resource = ('v2/user/technician/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Technician {0}' -f $id), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Technician {0} deleted successfully.' -f $id) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
