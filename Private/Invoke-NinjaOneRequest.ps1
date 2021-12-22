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
        Update-NinjaOneToken
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
        Write-Debug "Response object: $($Reponse | Out-String)"
        $Results = $Response.Content | ConvertFrom-Json
        if ($null -eq $Results) {
            $Results = @{}
        }
        return $Results
    } catch {
        $ExceptionResponse = $_.Exception.Response
        $TargetObject = $_.TargetObject
        $NinjaOneResponse = $_.ErrorDetails.Message | ConvertFrom-Json
        $RequestFailedError = [ErrorRecord]::New(
            [System.Net.Http.HttpRequestException]::New(
                "The NinjaOne API request `($($TargetObject.Method) $($TargetObject.RequestUri)`) responded with $($ExceptionResponse.StatusCode.Value__): $($ExceptionResponse.ReasonPhrase). NinjaOne's API said $($NinjaOneResponse.resultCode): $($NinjaOneResponse.errorMessage).",
                $_.Exception
            ),
            'NinjaRequestFailed',
            'ProtocolError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($RequestFailedError)
    }
}
