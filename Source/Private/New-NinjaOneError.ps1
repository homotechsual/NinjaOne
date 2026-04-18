<#
.SYNOPSIS
Create Error.

.DESCRIPTION
Internal helper function for New-NinjaOneError operations.

This function provides supporting functionality for the NinjaOne module.

.PARAMETER ErrorRecord
    Specifies the ErrorRecord parameter.

.PARAMETER HasResponse
    Specifies the HasResponse parameter.

.EXAMPLE
    PS> New-NinjaOneError -errorRecord "value"

    create the specified Error.

.OUTPUTS
Returns information about the Error resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
function New-NinjaOneError {
	[CmdletBinding()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		[Parameter(Mandatory = $true)]
		[errorrecord]$errorRecord,
		[Parameter()]
		[switch]$hasResponse
	)
	if (($Error.Exception -is [System.Net.Http.HttpRequestException]) -or ($Error.Exception -is [System.Net.WebException])) {
		Write-Verbose 'Generating NinjaOne error output.'
		$ExceptionMessage = [Hashset[String]]::New()
		$APIResultMatchString = '*The NinjaOne API said*'
		$HTTPResponseMatchString = '*The API returned the following HTTP*'
		if ($errorRecord.ErrorDetails) {
			Write-Verbose 'ErrorDetails contained in error record.'
			$ErrorDetailsIsJson = Test-Json -Json $errorRecord.ErrorDetails -ErrorAction SilentlyContinue
			if ($ErrorDetailsIsJson) {
				Write-Verbose 'ErrorDetails is JSON.'
				$ErrorDetails = $errorRecord.ErrorDetails | ConvertFrom-Json
				Write-Verbose "Raw error details: $($ErrorDetails | Out-String)"
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
						$ExceptionMessage.Add("The NinjaOne API said $($errorRecord.ErrorDetails).") | Out-Null
					} else {
						Write-Verbose 'ErrorDetails is null.'
						$ExceptionMessage.Add('The NinjaOne API returned an error.') | Out-Null
					}
				}
			} elseif ($errorRecord.ErrorDetails -like $APIResultMatchString -and $errorRecord.ErrorDetails -like $HTTPResponseMatchString) {
				$Errors = $errorRecord.ErrorDetails -split "`r`n"
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
		if (($errorRecord.Exception.Response -and $hasResponse) -or $ExceptionMessage -notlike $HTTPResponseMatchString) {
			$Response = $errorRecord.Exception.Response
			Write-Verbose "Raw HTTP response: $($Response | Out-String)"
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
			$errorRecord.Exception
		)
		$NinjaOneError = [ErrorRecord]::New(
			$errorRecord,
			$Exception
		)
		$UniqueExceptions = $ExceptionMessage | Get-Unique
		$NinjaOneError.ErrorDetails = [String]::Join("`r`n", $UniqueExceptions)
	} else {
		Write-Verbose 'Not generating NinjaOne error output.'
		$NinjaOneError = $errorRecord
	}
	$PSCmdlet.throwTerminatingError($NinjaOneError)
}
