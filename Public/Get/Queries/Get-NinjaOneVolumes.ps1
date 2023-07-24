function Get-NinjaOneVolumes {
    <#
        .SYNOPSIS
            Gets the volumes from the NinjaOne API.
        .DESCRIPTION
            Retrieves the volumes from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneVolumes

            Gets all volumes.
        .EXAMPLE
            PS> Get-NinjaOneVolumes -deviceFilter 'org = 1'

            Gets the volumes for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneVolumes -timeStamp 1619712000

            Gets the volumes with a monitoring timestamp at or after 1619712000.
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
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/volumes'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $Volumes = New-NinjaOneGETRequest @RequestParams
        Return $Volumes
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}