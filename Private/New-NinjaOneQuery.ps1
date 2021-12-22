function New-NinjaOneQuery {
    [CmdletBinding()]
    [OutputType([String], [HashTable])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param (
        [Parameter(
            Mandatory = $True
        )]
        [String]$CommandName,
        [Parameter(
            Mandatory = $True
        )]
        [HashTable]$Parameters,
        [Switch]$CommaSeparatedArrays,
        [Switch]$AsString
    )
    Write-Verbose "Building parameters for $($CommandName). Use '-Debug' with '-Verbose' to see parameter values as they are built."
    $QSCollection = [HashTable]@{}
    foreach ($Parameter in $Parameters.Values) {
        # Skip system parameters.
        if (([System.Management.Automation.Cmdlet]::CommonParameters).Contains($Parameter.Name)) {
            Write-Debug "Excluding system parameter $($Parameter.Name)."
            Continue
        }
        $ParameterVariable = Get-Variable -Name $Parameter.Name -ErrorAction SilentlyContinue
        if (($Parameter.ParameterType.Name -eq 'String') -or ($Parameter.ParameterType.Name -eq 'String[]')) {
            Write-Debug "Found String or String Array param $($ParameterVariable.Name)"
            if ([String]::IsNullOrEmpty($ParameterVariable.Value)) {
                Write-Debug "Skipping unset param $($ParameterVariable.Name)"
                Continue
            } else {
                if ($Parameter.Aliases) {
                    # Use the first alias as the query.
                    $Query = ([String]$Parameter.Aliases[0])
                } else {
                    # If no aliases then use the name.
                    $Query = ([String]$ParameterVariable.Name)
                }
                $Value = $ParameterVariable.Value
                if (($Value -is [Array]) -and ($CommaSeparatedArrays)) {
                    Write-Debug 'Building comma separated array string.'
                    $QueryValue = $Value -join ','
                    $QSCollection.Add($Query, $QueryValue)
                    Write-Debug "Adding parameter $($Query) with value $($QueryValue)"
                } elseif (($Value -is [Array]) -and (-not $CommaSeparatedArrays)) {
                    foreach ($ArrayValue in $Value) {
                        $QSCollection.Add($Query, $ArrayValue)
                        Write-Debug "Adding parameter $($Query) with value $($ArrayValue)"
                    }
                } else {
                    $QSCollection.Add($Query, $Value)
                    Write-Debug "Adding parameter $($Query) with value $($Value)"
                }
            }
        }
        if ($Parameter.ParameterType.Name -eq 'SwitchParameter') {
            Write-Debug "Found Switch param $($ParameterVariable.Name)"
            if ($ParameterVariable.Value -eq $False) {
                Write-Debug "Skipping unset param $($ParameterVariable.Name)"
                Continue
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
                Write-Debug "Adding parameter $($Query) with value $($Value)"
            }
        }
        if (($Parameter.ParameterType.Name -eq 'Int32') -or ($Parameter.ParameterType.Name -eq 'Int64') -or ($Parameter.ParameterType.Name -eq 'Int32[]') -or ($Parameter.ParameterType.Name -eq 'Int64[]')) {
            Write-Debug "Found Int or Int Array param $($ParameterVariable.Name)"
            if (($ParameterVariable.Value -eq 0) -or ($null -eq $ParameterVariable.Value)) {
                Write-Debug "Skipping unset param $($ParameterVariable.Name)"
                Continue
            } else {
                if ($Parameter.Aliases) {
                    # Use the first alias as the query string name.
                    $Query = ([String]$Parameter.Aliases[0])
                } else {
                    # If no aliases then use the name.
                    $Query = ([String]$ParameterVariable.Name)
                }
                $Value = $ParameterVariable.Value
                if (($Value -is [Array]) -and ($CommaSeparatedArrays)) {
                    Write-Debug 'Building comma separated array string.'
                    $QueryValue = $Value -join ','
                    $QSCollection.Add($Query, $QueryValue)
                    Write-Debug "Adding parameter $($Query) with value $($QueryValue)"
                } elseif (($Value -is [Array]) -and (-not $CommaSeparatedArrays)) {
                    foreach ($ArrayValue in $Value) {
                        $QSCollection.Add($Query, $ArrayValue)
                        Write-Debug "Adding parameter $($Query) with value $($ArrayValue)"
                    }
                } else {
                    $QSCollection.Add($Query, $Value)
                    Write-Debug "Adding parameter $($Query) with value $($Value)"
                }
            }
        }
        if (($Parameter.ParameterType.Name -eq 'DateTime') -or ($Parameter.ParameterType.Name -eq 'DateTime[]')) {
            Write-Debug "Found DateTime or DateTime Array param $($ParameterVariable.Name)"
            if ($null -eq $ParameterVariable.Value) {
                Write-Debug "Skipping unset param $($ParameterVariable.Name)"
                Continue
            } else {
                if ($Parameter.Aliases) {
                    # Use the first alias as the query.
                    $Query = ([String]$Parameter.Aliases[0])
                } else {
                    # If no aliases then use the name.
                    $Query = ([String]$ParameterVariable.Name)
                }
                $Value = $ParameterVariable.Value
                if (($Value -is [Array]) -and ($CommaSeparatedArrays)) {
                    Write-Debug 'Building comma separated array string.'
                    $QueryValue = $Value -join ','
                    $QSCollection.Add($Query, $QueryValue.ToUnixEpoch())
                    Write-Debug "Adding parameter $($Query) with value $($QueryValue)"
                } elseif (($Value -is [Array]) -and (-not $CommaSeparatedArrays)) {
                    foreach ($ArrayValue in $Value) {
                        $QSCollection.Add($Query, $ArrayValue)
                        Write-Debug "Adding parameter $($Query) with value $($ArrayValue)"
                    }
                } else {
                    $QSCollection.Add($Query, $Value)
                    Write-Debug "Adding parameter $($Query) with value $($Value)"
                }
            }
        }
    }
    Write-Debug "Query collection contains $($QSCollection | Out-String)"
    if ($AsString) {
        $QSBuilder.Query = $QSCollection.ToString()
        $Query = $QSBuilder.Query.ToString()
        Return $Query
    } else {
        Return $QSCollection
    }
}