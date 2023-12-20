
function Get-NinjaOneJobs {
    <#
        .SYNOPSIS
            Gets jobs from the NinjaOne API.
        .DESCRIPTION
            Retrieves jobs from the NinjaOne v2 API.
        .FUNCTIONALITY
            Jobs
        .EXAMPLE
            PS> Get-NinjaOneJobs

            Gets all jobs.
        .EXAMPLE
            PS> Get-NinjaOneJobs -jobType SOFTWARE_PATCH_MANAGEMENT

            Gets software patch management jobs.
        .EXAMPLE
            PS> Get-NinjaOneJobs -deviceFilter 'organization in (1,2,3)'

            Gets jobs for devices in organisations 1, 2 and 3.
        .EXAMPLE
            PS> Get-NinjaOneJobs -deviceId 1

            Gets jobs for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/jobs/
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoj')]
    [MetadataAttribute(
        '/v2/jobs',
        'get',
        '/v2/device/{id}/jobs',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by device id.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter by job type.
        [Parameter(Position = 1)]
        [String]$jobType,
        # Filter by device triggering the alert.
        [Parameter(Position = 2)]
        [Alias('df')]
        [String]$deviceFilter,
        # Filter by language tag.
        [Parameter(Position = 3)]
        [Alias('lang')]
        [String]$languageTag,
        # Filter by timezone.
        [Parameter(Position = 4)]
        [Alias('ts')]
        [String]$timeZone
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
        if ($deviceId) {
            $Parameters.Remove('deviceId') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            if ($deviceId) {
                Write-Verbose 'Getting device from NinjaOne API.'
                $Device = Get-NinjaOneDevices -deviceId $deviceId
                if ($Device) {
                    Write-Verbose ('Getting jobs for device {0}.' -f $Device.SystemName)
                    $Resource = ('v2/device/{0}/jobs' -f $deviceId)
                }
            } else {
                Write-Verbose 'Retrieving all jobs.'
                $Resource = 'v2/jobs'
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
                NoDrill = $True
            }
            $JobResults = New-NinjaOneGETRequest @RequestParams
            if ($JobResults) {
                return $JobResults
            } else {
                if ($Device) {
                    throw ('No jobs found for device {0}.' -f $Device.SystemName)
                } else {
                    throw 'No jobs found.'
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}