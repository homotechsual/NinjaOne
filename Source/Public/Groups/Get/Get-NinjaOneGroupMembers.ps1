
function Get-NinjaOneGroupMembers {
	<#
		.SYNOPSIS
			Gets group members from the NinjaOne API.
		.DESCRIPTION
			Retrieves group members from the NinjaOne v2 API.
		.FUNCTIONALITY
			Group Members
		.EXAMPLE
			PS> Get-NinjaOneGroupMembers -groupId 1

			Gets all group members for group with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/groupmembers
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnogm')]
	[MetadataAttribute(
		'/v2/group/{id}/device-ids',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The group id to get members for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$groupId,
		# Refresh ?ToDo Query with Ninja
		[Parameter(Position = 1)]
		[string]$refresh
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'groupid=' parameter by removing it from the set parameters.
		$Parameters.Remove('groupId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting group members for group {0}.' -f $groupId)
			$Resource = ('v2/group/{0}/device-ids' -f $groupId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$GroupMemberResults = New-NinjaOneGETRequest @RequestParams
			if ($GroupMemberResults) {
				return $GroupMemberResults
			} else {
				throw ('No group members found for group {0}.' -f $groupId)
			}
			return $GroupMemberResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}