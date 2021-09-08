using namespace System.Collections.Generic
function New-NinjaRMMError {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        [Parameter(Mandatory = $true)]
        [type]$ExceptionType,
        [Parameter(Mandatory = $true)]
        [string]$ErrorMessage,
        [Parameter(Mandatory = $true)]
        [exception]$ErrorRecord,
        [Parameter(Mandatory = $true)]
        [errorcategory]$ErrorCategory,
        [string]$CommandName,
        [switch]$BubbleUpDetails
    )
    $Command = $CommandName -Replace '-', ''
    $ErrorID = "NinjaRMM$($Command)CommandFailed"
    
    $ExceptionMessage = [list[string]]::New()
    $ExceptionMessage.Add($ErrorMessage)
    if ($ErrorDetails.Message) {
        $NinjaRMMError = $Exception.ErrorDetails.Message | ConvertFrom-Json
        if ($NinjaRMMError.Message) {
            $ExceptionMessage.Add("The NinjaRMM API said $($NinjaRMMError.resultCode): $($NinjaRMMError.errorMessage).")
        }
    }
    if ($Exception.Response) {
        $Response = $ErrorRecord.Exception.Response
    }
    if ($InnerException.InnerException.Response) {
        $Response = $ErrorRecord.Exception.InnerException.Response
    }
    if ($InnerException.InnerException.InnerException.Response) {
        $Response = $ErrorRecord.Exception.InnerException.InnerException.Response
    }
    if ($Response) {
        $ExceptionMessage.Add("The NinjaRMM API provided the status code $($Response.StatusCode.Value__): $($Response.ReasonPhrase).")
    }
    $Exception = $ExceptionType::New(
        $ExceptionMessage,
        $ErrorRecord.Exception
    )
    $ExceptionMessage.Add('You can use "Get-Error" for detailed error information.')
    $MSGraphError = [ErrorRecord]::New(
        $Exception,
        $ErrorID,
        $ErrorCategory,
        $TargetObject
    )
    if ($BubbleUpDetails) {
        $MSGraphError.ErrorDetails = $ErrorDetails
    }
    $PSCmdlet.ThrowTerminatingError($RequestError)
}