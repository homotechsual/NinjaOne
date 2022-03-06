using namespace System.Collections.Generic
using namespace System.Management.Automation
function New-NinjaOneError {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        [Parameter(Mandatory = $true)]
        [errorrecord]$ErrorRecord,
        [Parameter()]
        [switch]$HasResponse

    )
    Write-Verbose 'Generating NinjaOne error output.'
    $ExceptionMessage = [Hashset[String]]::New()
    $APIResultMatchString = '*The NinjaOne API said*'
    $HTTPResponseMatchString = '*The API returned the following HTTP*'
    if ($ErrorRecord.ErrorDetails) {
        Write-Verbose 'ErrorDetails contained in error record.'
        $ErrorDetailsIsJson = Test-Json -Json $ErrorRecord.ErrorDetails -ErrorAction SilentlyContinue
        if ($ErrorDetailsIsJson) {
            Write-Verbose 'ErrorDetails is JSON.'
            $ErrorDetails = $ErrorRecord.ErrorDetails | ConvertFrom-Json
            Write-Debug "Raw error details: $($ErrorDetails | Out-String)"
            if ($null -ne $ErrorDetails) {
                if (($null -ne $ErrorDetails.resultCode) -and ($null -ne $ErrorDetails.errorMessage)) {
                    Write-Verbose 'ErrorDetails contains resultCode and errorMessage.'
                    $ExceptionMessage.Add("The NinjaOne API said $($ErrorDetails.resultCode): $($ErrorDetails.errorMessage).") | Out-Null
                } elseif ($null -ne $ErrorDetails.resultCode) {
                    Write-Verbose 'ErrorDetails contains resultCode.'
                    $ExceptionMessage.Add("The NinjaOne API said $($ErrorDetails.resultCode).") | Out-Null
                } elseif ($null -ne $ErrorDetails.error) {
                    Write-Verbose 'ErrorDetails contains error.'
                    $ExceptionMessage.Add("The NinjaOne API said $($ErrorDetails.error).") | Out-Null
                } elseif ($null -ne $ErrorDetails) {
                    Write-Verbose 'ErrorDetails is not null.'
                    $ExceptionMessage.Add("The NinjaOne API said $($ErrorRecord.ErrorDetails).") | Out-Null
                } else {
                    Write-Verbose 'ErrorDetails is null.'
                    $ExceptionMessage.Add('The NinjaOne API returned an error.') | Out-Null
                }
            }
        } elseif ($ErrorRecord.ErrorDetails -like $APIResultMatchString -and $ErrorRecord.ErrorDetails -like $HTTPResponseMatchString) {
            $Errors = $ErrorRecord.ErrorDetails -Split "`r`n"
            if ($Errors -is [array]) {
                ForEach-Object -InputObject $Errors {
                    $ExceptionMessage.Add($_) | Out-Null
                }
            } elseif ($Errors -is [string]) {
                $ExceptionMessage.Add($_)
            }
        }
    } else {
        $ExceptionMessage.Add('The NinjaOne API returned an error but did not provide a result code or error message.') | Out-Null
    }
    if (($ErrorRecord.Exception.Response -and $HasResponse) -or $ExceptionMessage -notlike $HTTPResponseMatchString) {
        $Response = $ErrorRecord.Exception.Response
        Write-Debug "Raw HTTP response: $($Response | Out-String)"
        if ($Response.StatusCode.value__ -and $Response.ReasonPhrase) {
            $ExceptionMessage.Add("The API returned the following HTTP error response: $($Response.StatusCode.value__) $($Response.ReasonPhrase)") | Out-Null
        } else {
            $ExceptionMessage.Add('The API returned an HTTP error response but did not provide a status code or reason phrase.')
        }
    } else {
        $ExceptionMessage.Add('The API did not provide a response code or status.') | Out-Null
    }
    $Exception = [System.Exception]::New(
        $ExceptionMessage,
        $ErrorRecord.Exception
    )
    $NinjaOneError = [ErrorRecord]::New(
        $ErrorRecord,
        $Exception
    )
    $UniqueExceptions = $ExceptionMessage | Get-Unique
    $NinjaOneError.ErrorDetails = [String]::Join("`r`n", $UniqueExceptions)
    $PSCmdlet.ThrowTerminatingError($NinjaOneError)
}