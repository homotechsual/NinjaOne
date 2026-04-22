<#
.SYNOPSIS
Create Query.

.DESCRIPTION
Internal helper function for New-NinjaOneQuery operations.

This function provides supporting functionality for the NinjaOne module.

.PARAMETER CommandName
    Specifies the name of the Query resource.

.PARAMETER Parameters
    Specifies the Parameters parameter.

.PARAMETER CommaSeparatedArrays
    Specifies the CommaSeparatedArrays parameter.

.PARAMETER AsString
    Specifies the AsString parameter.

.EXAMPLE
    PS> New-NinjaOneQuery -commandName "*search*"

    create the specified Query.

.OUTPUTS
Returns information about the Query resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
function New-NinjaOneQuery {
	[CmdletBinding()]
	[OutputType([String], [HashTable])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		[Parameter(
			Mandatory = $True
		)]
		[String]$commandName,
		[Parameter(
			Mandatory = $True
		)]
		[HashTable]$parameters,
		[Switch]$commaSeparatedArrays,
		[Switch]$asString
	)
	Write-Verbose ('Building parameters for {0}. Use ''-Debug'' with ''-Verbose'' to see parameter values as they are built.' -f $commandName)
	$QSCollection = [HashTable]@{}
	Write-Verbose ('{0}' -f ($parameters.Values | Out-String))
	foreach ($Parameter in $parameters.Values) {
		# Skip system parameters.
		if (([System.Management.Automation.Cmdlet]::CommonParameters).Contains($Parameter.Name)) {
			Write-Verbose ('Excluding system parameter {0}.' -f $Parameter.Name)
			continue
		}
		# Skip optional system parameters.
		if (([System.Management.Automation.Cmdlet]::OptionalCommonParameters).Contains($Parameter.Name)) {
			Write-Verbose ('Excluding optional system parameter {0}.' -f $Parameter.Name)
			continue
		}
		$ParameterVariable = Get-Variable -Name $Parameter.Name -ErrorAction SilentlyContinue
		Write-Verbose ('Parameter variable: {0}' -f ($ParameterVariable | Out-String))
		if (($Parameter.ParameterType.Name -eq 'String') -or ($Parameter.ParameterType.Name -eq 'String[]')) {
			Write-Verbose ('Found String or String Array param {0} with value {1}.' -f $ParameterVariable.Name, $ParameterVariable.Value)
			if ([String]::IsNullOrEmpty($ParameterVariable.Value)) {
				Write-Verbose ('Skipping unset param {0}' -f $ParameterVariable.Name)
				continue
			} else {
				if ($Parameter.Aliases) {
					# Use the first alias as the query.
					$Query = ([String]$Parameter.Aliases[0])
				} else {
					# If no aliases then use the name.
					$Query = ([String]$ParameterVariable.Name)
				}
				$Value = $ParameterVariable.Value
				if (($Value -is [Array]) -and ($commaSeparatedArrays)) {
					Write-Verbose 'Building comma separated array string.'
					$QueryValue = $Value -join ','
					$QSCollection.Add($Query, $QueryValue)
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $QueryValue)
				} elseif (($Value -is [Array]) -and (-not $commaSeparatedArrays)) {
					foreach ($ArrayValue in $Value) {
						$QSCollection.Add($Query, $ArrayValue)
						Write-Verbose ('Adding parameter {0} with value(s) {1}' -f $Query, $ArrayValue)
					}
				} else {
					$QSCollection.Add($Query, $Value)
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $Value)
				}
			}
		}
		if ($Parameter.ParameterType.Name -eq 'SwitchParameter') {
			Write-Verbose ('Found Switch param {0} with value {1}.' -f $ParameterVariable.Name, $ParameterVariable.Value)
			if ($ParameterVariable.Value -eq $False) {
				Write-Verbose ('Skipping unset param {0}' -f $ParameterVariable.Name)
				continue
			} else {
				if ($Parameter.Aliases) {
					# Use the first alias as the query string name.
					$Query = ([String]$Parameter.Aliases[0])
				} else {
					# If no aliases then use the name.
					$Query = ([String]$ParameterVariable.Name)
				}
				$Value = ([String]$ParameterVariable.Value).ToLower()
				$QSCollection.Add($Query, $Value)
				Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $Value)
			}
		}
		if ($Parameter.ParameterType.Name -eq 'Boolean') {
			Write-Verbose ('Found Boolean param {0} with value {1}.' -f $ParameterVariable.Name, $ParameterVariable.Value)
			if ($Parameter.Aliases) {
				# Use the first alias as the query string name.
				$Query = ([String]$Parameter.Aliases[0])
			} else {
				# If no aliases then use the name.
				$Query = ([String]$ParameterVariable.Name)
			}
			$Value = ([String]$ParameterVariable.Value).ToLower()
			$QSCollection.Add($Query, $Value)
			Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $Value)
		}
		if (($Parameter.ParameterType.Name -eq 'Int32') -or ($Parameter.ParameterType.Name -eq 'Int64') -or ($Parameter.ParameterType.Name -eq 'Int32[]') -or ($Parameter.ParameterType.Name -eq 'Int64[]')) {
			Write-Verbose ('Found Int or Int Array param {0} with value {1}.' -f $ParameterVariable.Name, $ParameterVariable.Value)
			if (($ParameterVariable.Value -eq 0) -or ($null -eq $ParameterVariable.Value)) {
				Write-Verbose ('Skipping unset param {0}' -f $ParameterVariable.Name)
				continue
			} else {
				if ($Parameter.Aliases) {
					# Use the first alias as the query string name.
					$Query = ([String]$Parameter.Aliases[0])
				} else {
					# If no aliases then use the name.
					$Query = ([String]$ParameterVariable.Name)
				}
				$Value = $ParameterVariable.Value
				if (($Value -is [Array]) -and ($commaSeparatedArrays)) {
					Write-Verbose 'Building comma separated array string.'
					$QueryValue = $Value -join ','
					$QSCollection.Add($Query, $QueryValue)
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $QueryValue)
				} elseif (($Value -is [Array]) -and (-not $commaSeparatedArrays)) {
					foreach ($ArrayValue in $Value) {
						$QSCollection.Add($Query, $ArrayValue)
						Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $ArrayValue)
					}
				} else {
					$QSCollection.Add($Query, $Value)
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $Value)
				}
			}
		}
		if (($Parameter.ParameterType.Name -eq 'DateTime') -or ($Parameter.ParameterType.Name -eq 'DateTime[]')) {
			Write-Verbose ('Found DateTime or DateTime Array param {0} with value {1}.' -f $ParameterVariable.Name, $ParameterVariable.Value)
			if ($null -eq $ParameterVariable.Value) {
				Write-Verbose ('Skipping unset param {0}' -f $ParameterVariable.Name)
				continue
			} else {
				if ($Parameter.Aliases) {
					# Use the first alias as the query.
					$Query = ([String]$Parameter.Aliases[0])
				} else {
					# If no aliases then use the name.
					$Query = ([String]$ParameterVariable.Name)
				}
				$Value = $ParameterVariable.Value
				if (($Value -is [Array]) -and ($commaSeparatedArrays)) {
					Write-Verbose 'Building comma separated array string.'
					$QueryValue = $Value -join ','
					$QSCollection.Add($Query, $QueryValue.ToUnixEpoch())
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $QueryValue)
				} elseif (($Value -is [Array]) -and (-not $commaSeparatedArrays)) {
					foreach ($ArrayValue in $Value) {
						$QSCollection.Add($Query, $ArrayValue)
						Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $ArrayValue)
					}
				} else {
					$QSCollection.Add($Query, $Value)
					Write-Verbose ('Adding parameter {0} with value {1}' -f $Query, $Value)
				}
			}
		}
	}
	Write-Verbose ('Query collection contains {0}' -f ($QSCollection | Out-String))
	if ($asString) {
		$QSBuilder = [System.UriBuilder]::new()
		$QSBuilder.Query = $QSCollection.ToString()
		$Query = $QSBuilder.Query.ToString()
		return $Query
	} else {
		return $QSCollection
	}
}
