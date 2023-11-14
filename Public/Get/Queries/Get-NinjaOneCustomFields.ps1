function Get-NinjaOneCustomFields {
    <#
        .SYNOPSIS
            Gets the custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves the custom fields from the NinjaOne v2 API.
        .FUNCTIONALITY
            Custom Fields Query
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
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Parameter(ParameterSetName = 'Default')]
        [Alias('df')]
        [String]$deviceFilter,
        # Cursor name.
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [String]$cursor,
        # Number of results per page.
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [Int]$pageSize,
        # Custom field scopes to filter by.
        [Parameter(ParameterSetName = 'Scoped')]
        [ValidateSet('NODE', 'ORGANIZATION', 'LOCATION', 'ALL')]
        [String[]]$scopes,
        # Custom fields updated after the specified date. PowerShell DateTime object.
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [DateTime]$updatedAfter,
        # Custom fields updated after the specified date. Unix Epoch time.
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [Int]$updatedAfterUnixEpoch,
        # Array of fields.
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [String[]]$fields,
        # Get the detailed custom fields report(s).
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Scoped')]
        [Switch]$detailed
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'detailed=' parameter as we use this param to targed an alternative resource.
    if ($detailed) {
        $Parameters.Remove('detailed') | Out-Null
    }
    # If the [DateTime] parameter $updatedAfter is set convert the value to a Unix Epoch.
    if ($updatedAfter) {
        [int]$Parameters.updatedAfter = ConvertTo-UnixEpoch -DateTime $updatedAfter
    }
    # If the Unix Epoch parameter $updatedAfterUnixEpoch is set assign the value to the $updatedAfter variable and null $updatedAfterUnixEpoch.
    if ($updatedAfterUnixEpoch) {
        [int]$Parameters.updatedAfter = $updatedAfterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -CommaSeparatedArrays
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            if ($detailed) {
                $Resource = 'v2/queries/custom-fields-detailed'
            } else {
                $Resource = 'v2/queries/custom-fields'
            }
        } elseif ($PSCmdlet.ParameterSetName -eq 'Scoped') {
            if ($detailed) {
                $Resource = 'v2/queries/scoped-custom-fields-detailed'
            } else {
                $Resource = 'v2/queries/scoped-custom-fields'
            }
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