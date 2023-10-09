function Update-NinjaOneNodeRolePolicyAssignment {
    <#
        .SYNOPSIS
            Updates policy assignment for node role(s).
        .DESCRIPTION
            Updates policy assignment for node role(s) using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Array])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to update the policy assignment for.
        [Parameter(Mandatory = $true)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The node role id to update the policy assignment for.
        [Parameter(Mandatory = $true)]
        [Int]$nodeRoleId,
        # The policy id to assign to the node role.
        [Parameter(Mandatory = $true)]
        [Int]$policyId
    )
    try {
        $Resource = "v2/organization/$organisationId/policies"
        $RequestParams = @{
            Resource = $Resource
            Body = @{
                'nodeRoleId' = $nodeRoleId
                'policyId' = $policyId
            }
            AsArray = $true
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        if ($OrganisationExists) {
            if ($PSCmdlet.ShouldProcess('Node Role Policy Assignment', 'Update')) {
                $NodeRolePolicyAssignment = New-NinjaOnePUTRequest @RequestParams
                if ($NodeRolePolicyAssignment -eq 204) {
                    Write-Information 'Node Role Policy Assignment updated successfully.'
                }
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}