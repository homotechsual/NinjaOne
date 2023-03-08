function New-NinjaOneGETRequest {
    <#
        .SYNOPSIS
            Builds a request for the NinjaOne API.
        .DESCRIPTION
            Wrapper function to build web requests for the NinjaOne API.
        .EXAMPLE
            Make a GET request to the organisations endpoint.

            PS C:\> New-NinjaOneGETRequest -Resource "/v2/organizations"
        .OUTPUTS
            Outputs an object containing the response from the web request.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        # The resource to send the request to.
        [Parameter( Mandatory = $True )]
        [String]$Resource,
        # A hashtable used to build the query string.
        [HashTable]$QSCollection,
        # Don't drill down into the data property.
        [Switch]$NoDrill
    )
    if ($null -eq $Script:NRAPIConnectionInformation) {
        Throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
    }
    if ($null -eq $Script:NRAPIAuthenticationInformation) {
        Throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
    }
    try {
        if ($QSCollection) {
            Write-Debug "Query string in New-NinjaOneGETRequest contains: $($QSCollection | Out-String)"
            $QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
            Write-Verbose 'Building [HttpQSCollection] for New-NinjaOneGETRequest'
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
            Method = 'GET'
            Uri = $RequestUri.ToString()
        }
        if ($WebRequestParams) {
            Write-Debug "WebRequestParams contains: $($WebRequestParams | Out-String)"
        } else {
            Write-Debug 'WebRequestParams is empty.'
        }
        try {
            $Result = Invoke-NinjaOneRequest -WebRequestParams $WebRequestParams
            if ($Result) {
                Write-Debug "NinjaOne request returned:: $($Result | Out-String)"
            } else {
                Write-Debug 'NinjaOne request returned nothing.'
            }
            $Properties = ($Result | Get-Member -MemberType 'NoteProperty')
            if ($Properties.name -contains 'results') {
                Write-Debug "Returning 'results' property.'"
                Write-Debug "Result type is $($Result.results.GetType())"
                Return $Result.results
            } elseif ($Properties.name -contains 'result') {
                Write-Debug "Returning 'result' property."
                Write-Debug "Result type is $($Result.result.GetType())"
                Return $Result.result
            } else {
                Write-Debug 'Returning raw.'
                Write-Debug "Result type is $($Result.GetType())"
                Return $Result
            }
        } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            throw $_
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    } catch [Microsoft.PowerShell.Commands.HttpResponseException] {
        throw $_
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}