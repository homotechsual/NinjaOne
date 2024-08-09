
function Get-NinjaOneCustomFieldsPolicyCondition {
	<#
        .SYNOPSIS
            Gets detailed information on a single custom field condition for a given policy from the NinjaOne API.
        .DESCRIPTION
            Retrieves the detailed information on a given custom field condition for a given policy id from the NinjaOne v2 API.
        .FUNCTIONALITY
			Custom Field Policy Condition
        .EXAMPLE
            PS> Get-NinjaOneCustomFieldsPolicyCondition -policyId 1 -conditionId 1

            Gets the custom field policy condition with id 1 for the policy with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicycondition
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnopccf')]
	[MetadataAttribute(
		'/v2/policies/{policy_id}/condition/custom-fields/{condition_id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The policy id to get the custom field conditions for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$policyId,
		# The condition id to get the custom field condition for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$conditionId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding a 'policyid=' parameter by removing it from the set parameters.
		$Parameters.Remove('policyId') | Out-Null
		# Workaround to prevent the query string processor from adding a 'conditionid=' parameter by removing it from the set parameters.
		$Parameters.Remove('conditionId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting custom field condition {0} for policy {1}.' -f $conditionId, $policyId)
			$Resource = ('v2/policies/{0}/condition/custom-fields/{1}' -f $policyId, $conditionId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$PolicyConditionCustomFieldsResults = New-NinjaOneGETRequest @RequestParams
			return $PolicyConditionCustomFieldsResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}