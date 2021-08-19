#Requires -Version 7
function Get-NinjaRMMLocations {
    <#
        .SYNOPSIS
            Gets locations from the NinjaRMM API.
        .DESCRIPTION
            Retrieves locations from the NinjaRMM v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Number of results per page.
        [Int]$pageSize,
        # Start results from location ID.
        [Int]$after,
        # Filter by organisation ID.
        [Alias('organizationID')]
        [Int]$organisationID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaRMM API.'
            $Organisation = Get-NinjaRMMOrganisations -organisationID $organisationID -ErrorAction SilentlyContinue
            if ($Organisation) {
                Write-Verbose "Retrieving locations for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/locations"
            } else {
                $DeviceNotFoundError = [ErrorRecord]::New(
                    "Organisation with ID $($organisationID) was not found in NinjaRMM.",
                    'NinjaDeviceNotFound',
                    'ObjectNotFound',
                    $organisationID
                )
                $PSCmdlet.ThrowTerminatingError($DeviceNotFoundError)
            }
        } else {
            Write-Verbose 'Retrieving all locations.'
            $Resource = 'v2/locations'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $LocationResults = New-NinjaRMMGETRequest @RequestParams
        Return $LocationResults
    } catch {
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'Failed to get locations from NinjaRMM. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaCommandFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}