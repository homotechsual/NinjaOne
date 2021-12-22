using namespace System.Collections.Generic
function New-NinjaOneError {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        [Parameter(Mandatory = $true)]
        [type]$ExceptionType,
        [Parameter(Mandatory = $true)]
        [string]$ErrorMessage,
        [Parameter(Mandatory = $true)]
        [errorrecord]$ErrorRecord,
        [Parameter(Mandatory = $true)]
        [errorcategory]$ErrorCategory,
        [string]$CommandName,
        [switch]$BubbleUpDetails
    )
    $Command = $CommandName -Replace '-', ''
    $ErrorID = "NinjaOne$($Command)CommandFailed"
    
    $ExceptionMessage = [list[string]]::New()
    $ExceptionMessage.Add($ErrorMessage)
    if ($ErrorDetails.Message) {
        $NinjaOneError = $Exception.ErrorDetails.Message | ConvertFrom-Json
        if ($NinjaOneError.Message) {
            $ExceptionMessage.Add("The NinjaOne API said $($NinjaOneError.resultCode): $($NinjaOneError.errorMessage).")
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
        $ExceptionMessage.Add("The NinjaOne API provided the status code $($Response.StatusCode.Value__): $($Response.ReasonPhrase).")
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