
function Get-NinjaOnePolicies {
    <#
        .SYNOPSIS
            Gets policies from the NinjaOne API.
        .DESCRIPTION
            Retrieves policies from the NinjaOne v2 API.
        .FUNCTIONALITY
            Policies
        .EXAMPLE
            PS> Get-NinjaOnePolicies

            Gets all policies.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving all policies.'
        $Resource = 'v2/policies'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $PolicyResults = New-NinjaOneGETRequest @RequestParams
        Return $PolicyResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}