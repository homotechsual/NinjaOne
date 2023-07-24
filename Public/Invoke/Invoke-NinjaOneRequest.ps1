
function Invoke-NinjaOneRequest {
    <#
        .SYNOPSIS
            Sends a request to the NinjaOne API.
        .DESCRIPTION
            Wrapper function to send web requests to the NinjaOne API.
        .EXAMPLE
            PS> Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities'
            
            Make a GET request to the activities resource.
        .OUTPUTS
            Outputs an object containing the response from the web request.
    #>
    [Cmdletbinding()]
    [OutputType([Object])]
    param (
        # HTTP method to use.
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
        [String]$Method,
        # The URI to send the request to.
        [Parameter(Mandatory)]
        [String]$Uri,
        # The body of the request.
        [String]$Body,
        # Return the raw response - don't convert from JSON.
        [Switch]$Raw

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
        $WebRequestParams = @{
            Method = $Method
            Uri = $Uri
        }
        if ($Body) {
            Write-Debug "Body is $($Body | Out-String)"
            $WebRequestParams.Add('Body', $Body)
        } else {
            Write-Debug 'No body present.'
        }
        $Response = Invoke-WebRequest @WebRequestParams -Headers $AuthHeaders -ContentType 'application/json'
        Write-Debug "Response headers: $($Response.Headers | Out-String)"
        Write-Debug "Raw response: $($Response | Out-String)"
        if ($Response.Content) {
            $ResponseContent = $Response.Content
        } else {
            $ResponseContent = 'No content'
        }
        if ($Response.Content) {
            Write-Debug "Response content: $($ResponseContent | Out-String)"
        } else {
            Write-Debug 'No response content.'
        }
        if ($Raw) {
            Write-Verbose 'Raw switch present, returning raw response.'
            $Results = $Response.Content
        } else {
            Write-Verbose 'Raw switch not present, converting response from JSON.'
            $Results = $Response.Content | ConvertFrom-Json
        }
        if ($null -eq $Results) {
            if ($Response.StatusCode -and $WebRequestParams.Method -ne 'GET') {
                Write-Verbose "Request completed with status code $($Response.StatusCode). No content in the response - returning Status Code."
                $Results = $Response.StatusCode
            } else {
                Write-Verbose 'Request completed with no results and/or no status code.'
                $Results = @{}
            }
        }
        return $Results
    } catch {
        throw $_
    }
}
