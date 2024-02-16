using namespace System.Management.Automation
function Invoke-NinjaOnePreFlightCheck {
    <#
        .SYNOPSIS
            Conducts pre-flight checks for the NinjaOne API.
        .DESCRIPTION
            Conducts pre-flight checks ensuring that the NinjaOne API connection information is present and that the user is authenticated.
        .EXAMPLE
            PS> Invoke-NinjaOnePreFlightCheck

            Conducts pre-flight checks for the NinjaOne API.
        .EXAMPLE
            PS> Invoke-NinjaOnePreFlightCheck -SkipConnectionChecks

            Conducts pre-flight checks for the NinjaOne API, skipping the connection checks.
        .OUTPUTS
            [System.Void]

            Returns nothing if the checks pass. Otherwise, throws an error.
    #>
    [CmdletBinding()]
    param(
        # Skip the connection checks.
        [Parameter()]
        [Switch]$SkipConnectionChecks
    )
    if (-not $SkipConnectionChecks) {
        if ($null -eq $Script:NRAPIConnectionInformation) {
            $NoConnectionInformationException = [System.Exception]::New("Missing NinjaOne connection information, please run 'Connect-NinjaOne' first.")
            $ErrorRecord = [ErrorRecord]::New($NoConnectionInformationException, 'NoConnectionInformation', 'AuthenticationError', 'NinjaOnePreFlightCheck')
            
            $PSCmdlet.throwTerminatingError($ErrorRecord)
        }
        if (($null -eq $Script:HAPIAuthToken) -and ($null -eq $AllowAnonymous)) {
            $NoAuthTokenException = [System.Exception]::New("Missing Halo authentication token, please run 'Connect-HaloAPI' first.")
            $ErrorRecord = [ErrorRecord]::New($NoAuthTokenException, 'NoAuthToken', 'AuthenticationError', 'NinjaOnePreFlightCheck')

            $PSCmdlet.throwTerminatingError($ErrorRecord)
        }
    } else {
        Write-Verbose 'Skipping connection checks.'
    }
}