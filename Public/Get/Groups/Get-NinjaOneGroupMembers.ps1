
function Get-NinjaOneGroupMembers {
    <#
        .SYNOPSIS
            Gets group members from the NinjaOne API.
        .DESCRIPTION
            Retrieves group members from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneGroupMembers -groupID 1
            
            Gets all group members for group ID 1.
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
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($groupID) {
            Write-Verbose 'Getting group from NinjaOne API.'
            $Groups = Get-NinjaOneGroups
            $Group = $Groups | Where-Object { $_.id -eq $groupID }
            if ($Group) {
                Write-Verbose "Retrieving group members for $($Group.Name)."
                $Resource = "v2/group/$($groupID)/device-ids"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $GroupMemberResults = New-NinjaOneGETRequest @RequestParams
        Return $GroupMemberResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}