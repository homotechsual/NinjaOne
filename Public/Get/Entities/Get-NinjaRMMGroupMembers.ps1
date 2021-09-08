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
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
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
            $Groups = Get-NinjaRMMGroups
            $Group = $Groups | Where-Object { $_.id -eq $groupID }
            if ($Group) {
                Write-Verbose "Retrieving group members for $($Group.Name)."
                $Resource = "v2/group/$($groupID)/device-ids"
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
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaRMMError @ErrorRecord
    }
}