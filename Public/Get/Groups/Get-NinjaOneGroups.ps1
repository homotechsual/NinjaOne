#Requires -Version 7
function Get-NinjaOneGroups {
    <#
        .SYNOPSIS
            Gets groups from the NinjaOne API.
        .DESCRIPTION
            Retrieves groups from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by language tag.
        [Alias('lang')]
        [String]$languageTag
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving all groups.'
        $Resource = 'v2/groups'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $GroupResults = New-NinjaOneGETRequest @RequestParams
        Return $GroupResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}