using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaRMMDevices {
    <#
        .SYNOPSIS
            Gets devices from the NinjaRMM API.
        .DESCRIPTION
            Retrieves devices from the NinjaRMM v2 API.
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
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose "Retrieving information on device with ID $($deviceID)"
            $Resource = "v2/device/$($deviceID)"
        } elseif ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaRMM API.'
            $Organisation = Get-NinjaRMMOrganisation -organisationID $organisationID -ErrorAction SilentlyContinue
            if ($Organisation) {
                Write-Verbose "Retrieving devices for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/devices"
            } else {
                $OrganisationNotFoundError = [ErrorRecord]::New(
                    [ItemNotFoundException]::new("Organisation with ID $($organisationID) was not found in NinjaRMM."),
                    'NinjaOrganisationNotFound',
                    'ObjectNotFound',
                    $organisationID
                )
                $PSCmdlet.ThrowTerminatingError($OrganisationNotFoundError)
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
        $DeviceResults = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceResults
    } catch {
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'Failed to get devices from NinjaRMM. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaCommandFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}