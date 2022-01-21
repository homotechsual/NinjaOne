using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneDevices {
    <#
        .SYNOPSIS
            Gets devices from the NinjaOne API.
        .DESCRIPTION
            Retrieves devices from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Multi' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device ID
        [Parameter( ParameterSetName = 'Single', Mandatory = $True )]
        [Int]$deviceID,
        # Filter devices.
        [Parameter(ParameterSetName = 'Multi')]
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
        [Parameter( ParameterSetName = 'Multi' )]
        [Alias('organizationID')]
        [Int]$organisationID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceID) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    # Similarly we don't want a `detailed=` parameter since we're targetting a different resource.
    if ($detailed) {
        $Parameters.Remove('Detailed') | Out-Null
    }
    # Similarly we don't want an `organisationid=` parameter since we're targetting a different resource.
    if ($organisationID) {
        $Parameters.Remove('organisationID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose "Retrieving information on device with ID $($deviceID)"
            $Resource = "v2/device/$($deviceID)"
        } elseif ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationID $organisationID
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
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}
