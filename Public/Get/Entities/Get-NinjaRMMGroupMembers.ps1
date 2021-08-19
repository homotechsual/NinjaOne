#Requires -Version 7
function Get-NinjaRMMGroupMembers {
    <#
        .SYNOPSIS
            Gets group members from the NinjaRMM API.
        .DESCRIPTION
            Retrieves group members from the NinjaRMM v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Group ID
        [Parameter(Mandatory = $True)]
        [Int]$groupID,
        # Refresh ?TODO Query with Ninja
        [string]$refresh
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'groupid=' parameter by removing it from the set parameters.
    if ($groupID) {
        $Parameters.Remove('groupID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($groupID) {
            Write-Verbose 'Getting group from NinjaRMM API.'
            $Groups = Get-NinjaRMMGroups -ErrorAction SilentlyContinue
            $Group = $Groups | Where-Object { $_.id -eq $groupID }
            if ($Group) {
                Write-Verbose "Retrieving group members for $($Group.Name)."
                $Resource = "v2/group/$($groupID)/device-ids"
            } else {
                $GroupNotFoundError = [ErrorRecord]::New(
                    [ItemNotFoundException]::new("Group with ID $($groupID) was not found in NinjaRMM."),
                    'NinjaGroupNotFound',
                    'ObjectNotFound',
                    $groupID
                )
                $PSCmdlet.ThrowTerminatingError($GroupNotFoundError)
            }
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $GroupMemberResults = New-NinjaRMMGETRequest @RequestParams
        Return $GroupMemberResults
    } catch {
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'Failed to get group members from NinjaRMM. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaCommandFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}