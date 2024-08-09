using namespace System.Management.Automation

function Get-NinjaOneAutomations {
	<#
		.SYNOPSIS
			Gets automation scripts from the NinjaOne API.
		.DESCRIPTION
			Retrieves automation scripts from the NinjaOne v2 API.
		.FUNCTIONALITY
			Automation Scripts
		.EXAMPLE
			PS> Get-NinjaOneAutomations

			Gets all automation scripts.
		.EXAMPLE
			PS> Get-NinjaOneAlerts -lang 'en'

			Gets all automation scripts, returning the name of built in automation scripts in English.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/automationscripts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoau', 'Get-NinjaOneAutomation', 'gnoas', 'Get-NinjaOneAutomationScripts', 'Get-NinjaOneAutomationScript')]
	[MetadataAttribute(
		'/v2/automation/scripts',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Return built in automation script names in the given language.
		[Parameter(Position = 0)]
		[Alias('lang')]
		[String]$languageTag
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Retrieving all automation scripts.'
			$Resource = 'v2/automation/scripts'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			try {
				$AutomationResults = New-NinjaOneGETRequest @RequestParams
				return $AutomationResults
			} catch {
				if (-not $AutomationResults) {
					throw 'No automation scripts found.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}