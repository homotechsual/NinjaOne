function New-NinjaOnePolicy {
    <#
        .SYNOPSIS
            Creates a new policy using the NinjaOne API.
        .DESCRIPTION
            Create a new policy using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The mode to run in, new, child or copy.
        [Parameter(Mandatory)]
        [ValidateSet('NEW', 'CHILD', 'COPY')]
        [string]$mode,
        # An object containing the policy to create.
        [Parameter(Mandatory)]
        [object]$policy,
        # The ID of the template policy to copy from.
        [int]$templatePolicyId,
        # Show the policy that was created.
        [switch]$show
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. Please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        if ($mode -eq 'CHILD' -and $null -eq $policy.parentPolicyId) {
            throw 'The policy must have a parent policy id if using "CHILD" mode.'
        } elseif ($mode -eq 'COPY' -and $null -eq $templatePolicyId) {
            throw 'The policy must have a template policy id if using "COPY" mode.'
        }
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        if ($policy) {
            $Parameters.Remove('policy') | Out-Null
        }
        if ($templatePolicyId) {
            $Parameters.Remove('templatePolicyId') | Out-Null
        }
        if ($show) {
            $Parameters.Remove('show') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/policies'
        $RequestParams = @{
            Resource = $Resource
            Body = $policy
            QSCollection = $QSCollection
        }
        if ($PSCmdlet.ShouldProcess("Policy '$($policy.name)'", 'Create')) {
            $PolicyCreate = New-NinjaOnePOSTRequest @RequestParams
            if ($show) {
                Return $PolicyCreate
            } else {
                Write-Information "Policy '$($PolicyCreate.name)' created."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}