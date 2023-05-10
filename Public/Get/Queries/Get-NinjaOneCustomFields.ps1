function Get-NinjaOneCustomFields {
    <#
        .SYNOPSIS
            Gets the custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves the custom fields from the NinjaOne v2 API.
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
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize,
        # Custom fields updated after the specified date. PowerShell DateTime object.
        [DateTime]$updatedAfter,
        # Custom fields updated after the specified date. Unix Epoch time.
        [Int]$updatedAfterUnixEpoch,
        # Array of fields.
        [String[]]$fields,
        # Get the detailed version of this .
        [Switch]$detailed
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    if ($updatedAfter) {
        $Parameters.updatedAfter = ConvertTo-UnixEpoch -DateTime $updatedAfter
    }
    if ($updatedAfterUnixEpoch) {
        $Parameters.updatedAfter = $updatedAfterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($detailed) {
            $Resource = 'v2/queries/custom-fields-detailed'
        } else {
            $Resource = 'v2/queries/custom-fields'
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $CustomFields = New-NinjaOneGETRequest @RequestParams
        Return $CustomFields
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}