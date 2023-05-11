function Get-NinjaOnePolicyOverrides {
    <#
        .SYNOPSIS
            Gets the policy overrides by device from the NinjaOne API.
        .DESCRIPTION
            Retrieves the policy override sections by device from the NinjaOne v2 API.
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