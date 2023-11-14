function Get-NinjaOnePolicyOverrides {
    <#
        .SYNOPSIS
            Gets the policy overrides by device from the NinjaOne API.
        .DESCRIPTION
            Retrieves the policy override sections by device from the NinjaOne v2 API.
        .FUNCTIONALITY
            Policy Overrides Query
        .EXAMPLE
            PS> Get-NinjaOnePolicyOverrides

            Gets the policy overrides by device.
        .EXAMPLE
            PS> Get-NinjaOnePolicyOverrides -deviceFilter 'org = 1'

            Gets the policy overrides by device for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Cursor name.
        [String]$cursor,
        # Device filter.
        [Alias('df')]
        [String]$deviceFilter,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/policy-overrides'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $PolicyOverrides = New-NinjaOneGETRequest @RequestParams
        Return $PolicyOverrides
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}