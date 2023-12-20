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
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwarepatchesquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnosp')]
    [MetadataAttribute(
        '/v2/queries/software-patches',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Parameter(Position = 0)]
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter. PowerShell DateTime object.
        [Parameter(Position = 1)]
        [Alias('ts')]
        [DateTime]$timeStamp,
        # Monitoring timestamp filter. Unix Epoch time.
        [Parameter(Position = 1)]
        [Int]$timeStampUnixEpoch,
        # Filter patches by patch status.
        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by product identifier.
        [Parameter(Position = 3, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$productIdentifier,
        # Filter patches by type.
        [Parameter(Position = 4, ValueFromPipelineByPropertyName)]
        [ValidateSet('PATCH', 'INSTALLER')]
        [String]$type,
        # Filter patches by impact.
        [Parameter(Position = 5, ValueFromPipelineByPropertyName)]
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [String]$impact,
        # Cursor name.
        [Parameter(Position = 6)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 7)]
        [Int]$pageSize
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # If the [DateTime] parameter $timeStamp is set convert the value to a Unix Epoch.
        if ($timeStamp) {
            [int]$timeStamp = ConvertTo-UnixEpoch -DateTime $timeStamp
        }
        # If the Unix Epoch parameter $timeStampUnixEpoch is set assign the value to the $timeStamp variable and null $timeStampUnixEpoch.
        if ($timeStampUnixEpoch) {
            $Parameters.Remove('timeStampUnixEpoch') | Out-Null
            [int]$timeStamp = $timeStampUnixEpoch
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = 'v2/queries/software-patches'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $SoftwarePatches = New-NinjaOneGETRequest @RequestParams
            if ($SoftwarePatches) {
                return $SoftwarePatches
            } else {
                throw 'No software patches found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}