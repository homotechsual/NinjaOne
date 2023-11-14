function Get-NinjaOneSoftwarePatches {
    <#
        .SYNOPSIS
            Gets the software patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software patches from the NinjaOne v2 API.
        .FUNCTIONALITY
            Software Patches Query
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches

            Gets all software patches.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -deviceFilter 'org = 1'

            Gets the software patches for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -timeStamp 1619712000

            Gets the software patches with a monitoring timestamp at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -status 'FAILED'

            Gets the software patches with a status of 'FAILED'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -productIdentifier 23e4567-e89b-12d3-a456-426614174000

            Gets the software patches with a product identifier of '23e4567-e89b-12d3-a456-426614174000'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -type 'PATCH'

            Gets the software patches with a type of 'PATCH'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatches -impact 'OPTIONAL'

            Gets the software patches with an impact of 'OPTIONAL'.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter.
        [Alias('ts')]
        [string]$timeStamp,
        # Filter patches by patch status.
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by product identifier.
        [string]$productIdentifier,
        # Filter patches by type.
        [ValidateSet('PATCH', 'INSTALLER')]
        [String]$type,
        # Filter patches by impact.
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [String]$impact,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/software-patches'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwarePatches = New-NinjaOneGETRequest @RequestParams
        Return $SoftwarePatches
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}