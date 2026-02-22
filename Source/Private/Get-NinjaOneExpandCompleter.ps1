function Get-NinjaOneExpandCompleter {
	<#
	.SYNOPSIS
		ArgumentCompleter for the expand parameter.
	.DESCRIPTION
		Provides autocomplete suggestions for expand parameters while allowing free-form input.
	.OUTPUTS
		[System.Management.Automation.CompletionResult[]]
	#>
	[CmdletBinding()]
	param(
		[String]$WordToComplete,
		[System.Management.Automation.Language.CommandAst]$CommandAst,
		[Int]$CursorPosition
	)
	
	# Known expansion options for NinjaOne API
	$KnownExpansions = @(
		'location',
		'organization',
		'rolePolicy',
		'policy',
		'role',
		'backupUsage',
		'warranty',
		'assignedOwner',
		'backupBandwidthThrottle'
	)
	
	$KnownExpansions |
	Where-Object { $_ -like "$WordToComplete*" } |
	ForEach-Object {
		[System.Management.Automation.CompletionResult]::new(
			$_,
			$_,
			'ParameterValue',
			$_
		)
	}
}
