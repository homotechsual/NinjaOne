
function Get-NinjaOneTasks {
	<#
		.SYNOPSIS
			Gets tasks from the NinjaOne API.
		.DESCRIPTION
			Retrieves tasks from the NinjaOne v2 API.
		.FUNCTIONALITY
			Scheduled Tasks
		.EXAMPLE
			PS> Get-NinjaOneTasks

			Gets all tasks.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/scheduledtasks
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnota')]
	[MetadataAttribute(
		'/v2/tasks',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param()
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Retrieving all tasks.'
			$Resource = 'v2/tasks'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$TaskResults = New-NinjaOneGETRequest @RequestParams
			if ($TaskResults) {
				return $TaskResults
			} else {
				throw 'No tasks found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
