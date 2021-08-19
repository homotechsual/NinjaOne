function New-NinjaRMMGETRequest {
    <#
        .SYNOPSIS
            Builds a request for the NinjaRMM API.
        .DESCRIPTION
            Wrapper function to build web requests for the NinjaRMM API.
        .EXAMPLE
            PS C:\> New-NinjaRMMGETRequest -Method "GET" -Resource "/v2/organizations"
            Gets all Knowledgebase Articles
        .OUTPUTS
            Outputs an object containing the response from the web request.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        # The HTTP request method.
        [Parameter(
            Mandatory = $True
        )]
        [String]$Method,
        # The resource to send the request to.
        [Parameter(
            Mandatory = $True
        )]
        [String]$Resource,
        # A hashtable used to build the query string.
        [HashTable]$QSCollection
    )
    if ($null -eq $Script:NRAPIConnectionInformation) {
        Throw "Missing NinjaRMM connection information, please run 'Connect-NinjaRMM' first."
    }
    if ($null -eq $Script:NRAPIAuthenticationInformation) {
        Throw "Missing NinjaRMM authentication tokens, please run 'Connect-NinjaRMM' first."
    }
    try {
        if ($QSCollection) {
            Write-Debug "Query string in New-NinjaRMMGETRequest contains: $($QSCollection | Out-String)"
            $QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
            Write-Verbose 'Building [HttpQSCollection] for New-NinjaRMMGETRequest'
            foreach ($Key in $QSCollection.Keys) {
                $QueryStringCollection.Add($Key, $QSCollection.$Key)
            }
        } else {
            Write-Debug 'Query string collection not present...'
        }
        Write-Debug "URI is $($Script:NRAPIConnectionInformation.URL)"
        $RequestUri = [System.UriBuilder]"$($Script:NRAPIConnectionInformation.URL)"
        $RequestUri.Path = $Resource
        $RequestUri.Query = $QueryStringCollection.toString()
        $WebRequestParams = @{
            Method = $Method
            Uri = $RequestUri.ToString()
        }
        Write-Debug "Building new NinjaRMMRequest with params: $($WebRequestParams | Out-String)"
        $Result = Invoke-NinjaRMMRequest -WebRequestParams $WebRequestParams
        if ($Result) {
            Write-Debug "NinjaRMM request returned $($Result | Out-String)"
            Return $Result
        } else {
            Throw 'Failed to process GET request.'
        }
    } catch {
        Throw
    }
}