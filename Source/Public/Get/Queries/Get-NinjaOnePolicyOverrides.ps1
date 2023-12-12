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
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/policyoverridesquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnopo')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Cursor name.
        [Parameter(Position = 0)]
        [String]$cursor,
        # Device filter.
        [Parameter(Position = 1)]
        [Alias('df')]
        [String]$deviceFilter,
        # Number of results per page.
        [Parameter(Position = 2)]
        [Int]$pageSize
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = 'v2/queries/policy-overrides'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $PolicyOverrides = New-NinjaOneGETRequest @RequestParams
            if ($PolicyOverrides) {
                return $PolicyOverrides
            } else {
                throw 'No policy overrides found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}