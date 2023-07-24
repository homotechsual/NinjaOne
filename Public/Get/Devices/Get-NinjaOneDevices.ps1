using namespace System.Management.Automation

function Get-NinjaOneDevices {
    <#
        .SYNOPSIS
            Gets devices from the NinjaOne API.
        .DESCRIPTION
            Retrieves devices from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDevices

            Gets all devices.
        .EXAMPLE
            PS> Get-NinjaOneDevices -deviceId 1

            Gets the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDevices -organisationId 1

            Gets all devices for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDevices -deviceFilter 'status eq APPROVED'

            Gets all approved devices.
        .EXAMPLE
            PS> Get-NinjaOneDevices -deviceFilter 'class in (WINDOWS_WORKSTATION,MAC,LINUX_WORKSTATION)'

            Gets all WINDOWS_WORKSTATION, MAC or LINUX_WORKSTATION devices.
        .EXAMPLE
            PS> Get-NinjaOneDevices -deviceFilter 'class eq WINDOWS_WORKSTATION AND online'

            Gets all online WINDOWS_WORKSTATION devices.
        .LINK
            Device filters: https://docs.homotechsual.dev/modules/ninjaone/misc/device-filters
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Multi' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to retrieve
        [Parameter( ParameterSetName = 'Single', Mandatory )]
        [Int]$deviceId,
        # Filter devices.
        [Parameter( ParameterSetName = 'Multi' )]
        [Alias('df')]
        [String]$deviceFilter,
        # Number of results per page.
        [Parameter( ParameterSetName = 'Multi' )]
        [Int]$pageSize,
        # Start results from organisation ID.
        [Parameter( ParameterSetName = 'Multi' )]
        [Int]$after,
        # Include locations and policy mappings.
        [Parameter( ParameterSetName = 'Multi' )]
        [Switch]$detailed,
        # Filter by Organisation ID.
        [Parameter( ParameterSetName = 'Organisation', Mandatory )]
        [Alias('organizationId')]
        [Int]$organisationId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Similarly we don't want a `detailed=` parameter since we're targetting a different resource.
    if ($detailed) {
        $Parameters.Remove('detailed') | Out-Null
    }
    # Similarly we don't want an `organisationid=` parameter since we're targetting a different resource.
    if ($organisationID) {
        $Parameters.Remove('organisationId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose "Retrieving information on device with ID $($deviceId)"
            $Resource = "v2/device/$($deviceId)"
        } elseif ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationID
            if ($Organisation) {
                Write-Verbose "Retrieving devices for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/devices"
            }
        } else {
            if ($Detailed) {
                Write-Verbose 'Retrieving detailed information on all devices.'
                $Resource = 'v2/devices-detailed'
            } else {
                Write-Verbose 'Retrieving all devices.'
                $Resource = 'v2/devices'
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}
