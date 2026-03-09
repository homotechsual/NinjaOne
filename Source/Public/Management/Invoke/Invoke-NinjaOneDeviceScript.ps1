function Invoke-NinjaOneDeviceScript {
	<#
		.SYNOPSIS
			Runs a script or built-in action against the given device.
		.DESCRIPTION
			Runs a script or built-in action against a single device using the NinjaOne v2 API.
		.FUNCTIONALITY
			Script or Action
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				runAs = "string"
				type = "ACTION"
				id = 0
				uid = "00000000-0000-0000-0000-000000000000"
				parameters = "string"
			}
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -deviceId $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			System.Void

			This commandlet returns no output by default. A success message will be written to the information stream if the API returns a 204 success code. Use `-InformationAction Continue` to see this message. Use the `-show` switch to return the HTTP status code.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1 -runAs 'system'

			Runs the script with id 1 against the device with id 1 with system-level permissions.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'ACTION' -actionUId '00000000-0000-0000-0000-000000000000' -runAs 'system'

			Runs the built-in action with uid 00000000-0000-0000-0000-000000000000 against the device with id 1 with system-level permissions.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1 -runAs 'loggedonuser'

			Runs the script with id 1 as the currently logged-on user on device 1.
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1 -runAs '26'

			Runs the script with id 1 using the preferred credential with ID 26.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/scriptoraction
	#>
	[CmdletBinding()]
	[OutputType([System.Void])]
	[Alias('inods')]
	[MetadataAttribute(
		'/v2/device/{id}/script/run',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
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
		# The credential/role identifier to use when running the script or action. This parameter is case-sensitive and controls the permission level.
		# Valid values are:
		# - 'system': Run with system-level permissions (maps to general.system)
		# - 'SR_MAC_SCRIPT': Run with system-level permissions on macOS (maps to general.system)
		# - 'SR_LINUX_SCRIPT': Run with system-level permissions on Linux (maps to general.system)
		# - 'loggedonuser': Run as the currently logged-on user (maps to editor.credentials.currentLoggedOnUser)
		# - 'SR_LOCAL_ADMINISTRATOR': Run as local administrator (maps to editor.credentials.preferredWindowsLocalAdmin)
		# - 'SR_DOMAIN_ADMINISTRATOR': Run as domain administrator (maps to editor.credentials.preferredWindowsDomainAdmin)
		# - A credential ID as a string (e.g., '26'): Run using a specific user credential from your account. You can find credential IDs in the NinjaOne UI under Account > Credentials (maps to editor.credentials.preferredCredential)
		[Parameter(Mandatory, ParameterSetName = 'SCRIPT', Position = 4, ValueFromPipelineByPropertyName)]
		[Parameter(Mandatory, ParameterSetName = 'ACTION', Position = 4, ValueFromPipelineByPropertyName)]
		[ValidateScript(
			{
				$preset = @('system', 'SR_MAC_SCRIPT', 'SR_LINUX_SCRIPT', 'loggedonuser', 'SR_LOCAL_ADMINISTRATOR', 'SR_DOMAIN_ADMINISTRATOR')
				$_ -in $preset -or ($_ -match '^\d+$')
			}
		)]
		[String]$runAs,
		# Show the status code returned from the API.
		[Switch]$show
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
					$ScriptOrAction = Get-NinjaOneDeviceScriptingOptions -deviceId $deviceId -Scripts | Where-Object { $_.id -eq $scriptId -and $_.type -eq $type }
				} else {
					$ScriptOrAction = Get-NinjaOneDeviceScriptingOptions -deviceId $deviceId -Scripts | Where-Object { $_.uid -eq $actionUId -and $_.type -eq $type }
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
						runAs = $runAs
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
				if ($show) {
					return $ScriptRun
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}










