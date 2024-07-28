function Set-NinjaOneOrganisationPolicies {
	<#
		.SYNOPSIS
			Sets policy assignment for node role(s) for an organisation.
		.DESCRIPTION
			Sets policy assignment for node role(s) for an organisation using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Policies
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/set/organisationpolicies
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Array])]
	[Alias('snoop', 'Set-NinjaOneOrganizationPolicies', 'snorpa', 'Set-NinjaOneNodeRolePolicyAssignment', 'unorpa', 'Update-NinjaOneNodeRolePolicyAssignment', 'snopm', 'Set-NinjaOneOrganisationPolicyMappings', 'Set-NinjaOneOrganizationPolicyMappings', 'Set-NinjaOneOrganisationPolicyMapping', 'Set-NinjaOneOrganizationPolicyMapping', 'unopm', 'Update-NinjaOneOrganisationPolicyMappings', 'Update-NinjaOneOrganisationPolicyMapping', 'Update-NinjaOneOrganizationPolicyMappings', 'Update-NinjaOneOrganizationPolicyMapping')]
	[MetadataAttribute(
		'/v2/organization/{id}/policies',
		'put'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The organisation to update the policy assignment for.
		[Parameter(Mandatory, ParameterSetName = 'Single', Position = 0, ValueFromPipelineByPropertyName)]
		[Parameter(Mandatory, ParameterSetName = 'Multiple', Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The node role id to update the policy assignment for.
		[Parameter(Mandatory, ParameterSetName = 'Single', Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$nodeRoleId,
		# The policy id to assign to the node role.
		[Parameter(Mandatory, ParameterSetName = 'Single', Position = 2, ValueFromPipelineByPropertyName)]
		[Int]$policyId,
		# The node role policy assignments to update. Should be an array of objects with the following properties: nodeRoleId, policyId.
		[Parameter(Mandatory, ParameterSetName = 'Multiple', Position = 1, ValueFromPipelineByPropertyName)]
		[Object[]]$policyAssignments
	)
	process {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'Single') {
				try {
					$Body = @{
						'nodeRoleId' = $nodeRoleId
						'policyId' = $policyId
					}
				} catch {
					New-NinjaOneError -ErrorRecord $_
				}
			} elseif ($PSCmdlet.ParameterSetName -eq 'Multiple') {
				$Body = [System.Collections.Generic.List[Object]]::new()
				$policyAssignments | ForEach-Object {
					try {
						$Body.Add(
							@{
								'nodeRoleId' = $_.nodeRoleId
								'policyId' = $_.policyId
							}
						) | Out-Null
					} catch {
						New-NinjaOneError -ErrorRecord $_
					}
				}
			}
			$Resource = ('v2/organization/{0}/policies' -f $organisation.id)
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ParameterSetName -eq 'Single') {
				$RequestParams.AsArray = $true
			} elseif ($PSCmdlet.ParameterSetName -eq 'Multiple') {
				$RequestParams.AsArray = $false
			}
			if ($PSCmdlet.ShouldProcess(('Assign policy {0} to role {1} for {2}.' -f $policyId, $nodeRoleId, $organisationId), 'Update')) {
				$NodeRolePolicyAssignment = New-NinjaOnePUTRequest @RequestParams
				if ($NodeRolePolicyAssignment -eq 204) {
					Write-Information ('Policy {0} assigned to role {1} for {2}.' -f $policyId, $nodeRoleId, $organisationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}