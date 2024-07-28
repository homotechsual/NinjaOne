function Set-NinjaOneDeviceApproval {
	<#
		.SYNOPSIS
			Sets the approval status of the specified device(s)
		.DESCRIPTION
			Sets the approval status of the specified device(s) using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Approval
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/deviceapproval
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoda', 'unoda', 'Update-NinjaOneDeviceApproval')]
	[MetadataAttribute(
		'/v2/devices/approval/{mode}',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The approval mode.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('APPROVE', 'REJECT')]
		[String]$mode,
		# The device(s) to set the approval status for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'ids')]
		[Int[]]$deviceIds
	)
	begin { }
	process {
		try {
			$Resource = ('v2/devices/approval/{0}' -f $mode)
			if ($deviceIds -is [array]) {
				$devices = @{
					'devices' = $deviceIds
				}
			} else {
				$devices = @{
					'devices' = @($deviceIds)
				}
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $devices
			}
			if ($PSCmdlet.ShouldProcess('Device Approval', 'Set')) {
				$DeviceApprovals = New-NinjaOnePOSTRequest @RequestParams
				if ($DeviceApprovals -eq 204) {
					if ($mode -eq 'APPROVE') {
						$approvalResult = 'approved'
					} else {
						$approvalResult = 'rejected'
					}
					Write-Information ('Device(s) {0} {1} successfully.' -f (($DeviceResults | Select-Object -ExpandProperty SystemName) -join ', '), $approvalResult)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}