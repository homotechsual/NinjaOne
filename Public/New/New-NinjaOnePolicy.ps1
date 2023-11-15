function New-NinjaOnePolicy {
    <#
        .SYNOPSIS
            Creates a new policy using the NinjaOne API.
        .DESCRIPTION
            Create a new policy using the NinjaOne v2 API.
        .FUNCTIONALITY
            Create Policy
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The mode to run in, new, child or copy.
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('NEW', 'CHILD', 'COPY')]
        [String]$mode,
        # An object containing the policy to create.
        [Parameter(Mandatory, Position = 1)]
        [Object]$policy,
        # The Id of the template policy to copy from.
        [Parameter(Position = 2)]
        [Int]$templatePolicyId,
        # Show the policy that was created.
        [Switch]$show
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
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
        if ($PSCmdlet.ShouldProcess(('Policy {0}' -f $policy.Name), 'Create')) {
            $PolicyCreate = New-NinjaOnePOSTRequest @RequestParams
            if ($show) {
                return $PolicyCreate
            } else {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Policy {0} created.' -f $PolicyCreate.name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}