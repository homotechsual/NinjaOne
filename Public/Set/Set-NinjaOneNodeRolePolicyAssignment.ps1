function Set-NinjaOneNodeRolePolicyAssignment {
    <#
        .SYNOPSIS
            Sets policy assignment for node role(s).
        .DESCRIPTION
            Sets policy assignment for node role(s) using the NinjaOne v2 API.
        .FUNCTIONALITY
            Node Role Policy Assignment
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Array])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to update the policy assignment for.
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The node role id to update the policy assignment for.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$nodeRoleId,
        # The policy id to assign to the node role.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [Int]$policyId
    )
    try {
        $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
        if ($Organisation) {
            Write-Verbose ('Getting node role {0} from NinjaOne API.' -f $nodeRoleId)
            $Role = Get-NinjaOneRoles | Where-Object { $_.id -eq $nodeRoleId }
            if ($Role) {
                Write-Verbose ('Getting policy {0} from NinjaOne API.' -f $policyId)
                $Policy = Get-NinjaOnePolicies | Where-Object { $_.id -eq $policyId }
                if ($Policy) {
                    Write-Verbose ('Setting policy assignment for node role {0}.' -f $Role.name)
                    $Resource = ('v2/organization/{0}/policies' -f $organisationId)
                } else {
                    throw ('Policy with id {0} not found.' -f $policyId)
                }
            } else {
                throw ('Node role with id {0} not found in organisation {1}' -f $nodeRoleId, $Organisation.Name)
            }
        } else {
            throw ('Organisation with id {0} not found.' -f $organisationId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = @{
                'nodeRoleId' = $nodeRoleId
                'policyId' = $policyId
            }
            AsArray = $true
        }
        if ($PSCmdlet.ShouldProcess(('Assign policy {0} to role {1} for {2}.' -f $Policy.Name, $Role.Name, $Organisation.Name), 'Update')) {
            $NodeRolePolicyAssignment = New-NinjaOnePUTRequest @RequestParams
            if ($NodeRolePolicyAssignment -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Policy {0} assigned to role {1} for {2}.' -f $Policy.Name, $Role.Name, $Organisation.Name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}