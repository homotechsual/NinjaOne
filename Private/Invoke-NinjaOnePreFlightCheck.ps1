using namespace System.Management.Automation
function Invoke-NinjaOnePreFlightCheck {
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
    if ($PSEdition -eq 'Desktop') {
        
        
    }
}