function Get-NinjaOneCustomFields {
    <#
        .SYNOPSIS
            Gets the custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves the custom fields from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields

            Gets all custom field values for all devices.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields -deviceFilter 'org = 1'

            Gets all custom field values for all devices in the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields -updatedAfter (Get-Date).AddDays(-1)

            Gets all custom field values for all devices updated in the last 24 hours.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields -updatedAfterUnixEpoch 1619712000

            Gets all custom field values for all devices updated at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields -fields 'hasBatteries', 'autopilotHwid'

            Gets the custom field values for the specified fields.
        .EXAMPLE
            PS> Get-NinjaOneCustomFields -detailed

            Gets the detailed version of the custom field values.
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
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -CommaSeparatedArrays
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