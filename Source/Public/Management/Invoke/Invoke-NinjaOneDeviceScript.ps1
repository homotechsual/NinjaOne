function Invoke-NinjaOneDeviceScript {
	<#
		.SYNOPSIS
			Runs a script or built-in action against the given device.
		.DESCRIPTION
			Runs a script or built-in action against a single device using the NinjaOne v2 API.
		.FUNCTIONALITY
			Script or Action
		.OUTPUTS
			A powershell object containing the response.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1

			Runs the script with id 1 against the device with id 1.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'ACTION' -actionUId '00000000-0000-0000-0000-000000000000'

			Runs the built-in action with uid 00000000-0000-0000-0000-000000000000 against the device with id 1.
		.EXAMPLE

		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/scriptoraction
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('inods')]
	[MetadataAttribute(
		'/v2/device/{id}/script/run',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device to run a script on.
		[Parameter(Mandatory, ParameterSetName = 'SCRIPT', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Parameter(Mandatory, ParameterSetName = 'ACTION', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The type - script or action.
		[Parameter(Mandatory, ParameterSetName = 'SCRIPT', Position = 1, ValueFromPipelineByPropertyName)]
		[Parameter(Mandatory, ParameterSetName = 'ACTION', Position = 1, ValueFromPipelineByPropertyName)]
		[ValidateSet('SCRIPT', 'ACTION')]
		[String]$type,
		# The id of the script to run. Only used if the type is script.
		[Parameter(Mandatory, ParameterSetName = 'SCRIPT', Position = 2, ValueFromPipelineByPropertyName)]
		[Int]$scriptId,
		# The unique uid of the action to run. Only used if the type is action.
		[Parameter(Mandatory, ParameterSetName = 'ACTION', Position = 2, ValueFromPipelineByPropertyName)]
		[GUID]$actionUId,
		# The parameters to pass to the script or action.
		[Parameter(ParameterSetName = 'SCRIPT', Position = 3, ValueFromPipelineByPropertyName)]
		[Parameter(ParameterSetName = 'ACTION', Position = 3, ValueFromPipelineByPropertyName)]
		[String]$parameters,
		# The credential/role identifier to use when running the script.
		[Parameter(ParameterSetName = 'SCRIPT', Position = 4, ValueFromPipelineByPropertyName)]
		[Parameter(ParameterSetName = 'ACTION', Position = 4, ValueFromPipelineByPropertyName)]
		[ValidateScript(
			{ $_ -is [String] -OR $_ -in @('system', 'SR_MAC_SCRIPT', 'SR_LINUX_SCRIPT', 'loggedonuser', 'SR_LOCAL_ADMINISTRATOR', 'SR_DOMAIN_ADMINISTRATOR') }
		)]
		[String]$runAs
	)
	begin { }
	process {
		try {
			if ($type -eq 'SCRIPT') {
				$prettyAction = 'script'
			} else {
				$prettyAction = 'action'
			}
			$Device = Get-NinjaOneDevice -deviceId $deviceId
			if ($Device) {
				Write-Verbose ('Getting device scripting options for device {0}.' -f $Device.SystemName)
				if ($type -eq 'SCRIPT') {
					$ScriptOrAction = Get-NinjaOneDeviceScriptingOptions -deviceId $deviceId -Scripts | Where-Object { $_.id -eq $scriptId -AND $_.type -eq $type }
				} else {
					$ScriptOrAction = Get-NinjaOneDeviceScriptingOptions -deviceId $deviceId -Scripts | Where-Object { $_.uid -eq $actionUId -AND $_.type -eq $type }
				}
				if ($ScriptOrAction.Count -gt 1) {
					Write-Warning ('More than one {0} matched for device {1}.' -f $prettyAction, $Device.SystemName)
					Write-Verbose ('Raw {0} options: {1}' -f $prettyAction, ($ScriptOrAction | Out-String))
				}
				if ($ScriptOrAction) {
					Write-Verbose ('Running {0} {1} on device {2}.' -f $prettyAction, $ScriptOrAction.Name, $Device.SystemName)
					$Resource = ('v2/device/{0}/script/run' -f $deviceId)
					$RunRequest = @{
						type = $type
					}
					if ($scriptId) {
						$RunRequest.id = $scriptId
					}
					if ($actionUId) {
						$RunRequest.uid = $actionUId
					}
					if ($parameters) {
						$RunRequest.parameters = $parameters
					}
					if ($runAs) {
						$RunRequest.runAs = $runAs
					}
					Write-Verbose ('Raw run request: {0}' -f ($RunRequest | Out-String))
				} else {
					if ($scriptId) {
						throw ('Script with id {0} not found for device {1}.' -f $scriptId, $Device.SystemName)
					} elseif ($actionUId) {
						throw ('Action with uid {0} not found for device {1}.' -f $actionUId, $Device.SystemName)
					}
				}
			} else {
				throw ('Device with id {0} not found.' -f $deviceId)
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $RunRequest
			}
			$ScriptRun = New-NinjaOnePOSTRequest @RequestParams
			if ($ScriptRun -eq 204) {		
				Write-Information ('Requested run for {0} {1} on device {2} successfully.' -f $prettyAction, $ScriptOrAction.Name, $Device.SystemName)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}