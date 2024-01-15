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
    [Alias('snoop', 'Set-NinjaOneOrganizationPolicies', 'snorpa', 'Set-NinjaOneNodeRolePolicyAssignment', 'unorpa', 'Update-NinjaOneNodeRolePolicyAssignment')]
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
        function ValidateNodeRoleAndPolicy {
            [CmdletBinding()]
            param(
                [Int]$nodeRoleId,
                [Int]$policyId
            )
            Write-Verbose ('Getting node role {0} from NinjaOne API.' -f $nodeRoleId)
            $Role = Get-NinjaOneRoles | Where-Object { $_.id -eq $nodeRoleId }
            if ($Role) {
                Write-Verbose ('Getting policy {0} from NinjaOne API.' -f $policyId)
                $Policy = Get-NinjaOnePolicies | Where-Object { $_.id -eq $policyId }
                if ($Policy) {
                    return $Policy
                } else {
                    throw ('Policy with id {0} not found.' -f $policyId)
                }
            } else {
                throw ('Node role with id {0} not found in organisation {1}' -f $nodeRoleId, $Organisation.Name)
            }
        }
        try {
            $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
            if ($Organisation) {
                if ($PSCmdlet.ParameterSetName -eq 'Single') {
                    try {
                        ValidateNodeRoleAndPolicy -nodeRoleId $nodeRoleId -policyId $policyId
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
                            ValidateNodeRoleAndPolicy -nodeRoleId $_.nodeRoleId -policyId $_.policyId
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
            } else {
                throw ('Organisation with id {0} not found.' -f $organisationId)
            }
            $RequestParams = @{
                Resource = $Resource
                Body = $Body
            }
            if ($PSCmdlet.ParameterSetName -eq 'Single') {
                $RequestParams.AsArray = $true
            } elseif ($PSCmdlet.ParameterSetName -eq 'Multiple') {
                $RequestParams.AsArray = $false
            }
            if ($PSCmdlet.ShouldProcess(('Assign policy {0} to role {1} for {2}.' -f $Policy.Name, $Role.Name, $Organisation.Name), 'Update')) {
                $NodeRolePolicyAssignment = New-NinjaOnePUTRequest @RequestParams
                if ($NodeRolePolicyAssignment -eq 204) {
                    Write-Information ('Policy {0} assigned to role {1} for {2}.' -f $Policy.Name, $Role.Name, $Organisation.Name)
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}