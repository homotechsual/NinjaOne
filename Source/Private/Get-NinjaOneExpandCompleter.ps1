function Get-NinjaOneExpandCompleter {
	<#
	.SYNOPSIS
		ArgumentCompleter for the expand parameter.
	.DESCRIPTION
		Provides autocomplete suggestions for expand parameters while allowing free-form input.
	.OUTPUTS
		[System.Management.Automation.CompletionResult[]]
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[CmdletBinding()]
	param(
		[String]$wordToComplete,
		[System.Management.Automation.Language.CommandAst]$commandAst,
		[Int]$cursorPosition
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
	Where-Object { $_ -like "$wordToComplete*" } |
	ForEach-Object {
		[System.Management.Automation.CompletionResult]::new(
			$_,
			$_,
			'ParameterValue',
			$_
		)
	}
}
