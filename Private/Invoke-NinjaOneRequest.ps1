#Requires -Version 7
function Invoke-NinjaOneRequest {
    <#
        .SYNOPSIS
            Sends a request to the NinjaOne API.
        .DESCRIPTION
            Wrapper function to send web requests to the NinjaOne API.
        .OUTPUTS
            Outputs an object containing the response from the web request.
    #>
    [Cmdletbinding()]
    [OutputType([Object])]
    param (
        # Hashtable containing the web request parameters.
        [HashTable]$WebRequestParams
    )
    if ($null -eq $Script:NRAPIConnectionInformation) {
        Throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
    }
    if ($null -eq $Script:NRAPIAuthenticationInformation) {
        Throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
    }
    $Now = Get-Date
    if ($Script:NRAPIAuthenticationInformation.Expires -le $Now) {
        Write-Verbose 'The auth token has expired, renewing.'
        Update-NinjaOneToken -Verbose:$VerbosePreference
    }
    if ($null -ne $Script:NRAPIAuthenticationInformation) {
        $AuthHeaders = @{
            Authorization = "$($Script:NRAPIAuthenticationInformation.Type) $($Script:NRAPIAuthenticationInformation.Access)"
        }
    } else {
        $AuthHeaders = $null
    }
    try {
        Write-Verbose "Making a $($WebRequestParams.Method) request to $($WebRequestParams.Uri)"
        $Response = Invoke-WebRequest @WebRequestParams -Headers $AuthHeaders -ContentType 'application/json'
        Write-Debug "Response headers: $($Response.Headers | Out-String)"
        Write-Debug "Response object: $($Response.Content ?? 'No content' | Out-String)"
        $Results = $Response.Content | ConvertFrom-Json
        if ($null -eq $Results) {
            if ($Response.StatusCode) {
                Write-Verbose "Request completed with status code $($Response.StatusCode)"
                $Results = $Response.StatusCode
            } else {
                Write-Verbose 'Request completed with no status code'
                $Results = @{}
            }
            

        }
        
        return $Results
    } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
        throw $_
    } catch {
        throw $_
    }
}
