function Get-NinjaOneWindowsServices {
    <#
        .SYNOPSIS
            Gets the windows services from the NinjaOne API.
        .DESCRIPTION
            Retrieves the windows services from the NinjaOne v2 API.
        .FUNCTIONALITY
            Windows Services Query
        .EXAMPLE
            PS> Get-NinjaOneWindowsServices

            Gets the windows services.
        .EXAMPLE
            PS> Get-NinjaOneWindowsServices -deviceFilter 'organization in (1,2,3)'

            Gets the windows services for devices in organisations 1, 2 and 3.
        .EXAMPLE
            PS> Get-NinjaOneWindowsServices -name 'NinjaOne'

            Gets the windows services with the name 'NinjaOne'.
        .EXAMPLE
            PS> Get-NinjaOneWindowsServices -state 'RUNNING'

            Gets the windows services with the state 'RUNNING'.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/windowsservicesquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnows')]
    [Metadata(
        '/v2/queries/windows-services',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Parameter(Position = 0)]
        [Alias('df')]
        [String]$deviceFilter,
        # Filter by service name.
        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$name,
        # Filter by service state.
        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet(
            'UNKNOWN',
            'STOPPED',
            'START_PENDING',
            'RUNNING',
            'STOP_PENDING',
            'PAUSE_PENDING',
            'PAUSED',
            'CONTINUE_PENDING'
        )]
        [String]$state,
        # Cursor name.
        [Parameter(Position = 3)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 4)]
        [Int]$pageSize
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = 'v2/queries/windows-services'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $WindowsServices = New-NinjaOneGETRequest @RequestParams
            if ($WindowsServices) {
                return $WindowsServices
            } else {
                throw 'No windows services found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}