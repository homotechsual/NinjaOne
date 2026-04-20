function ConvertFrom-NinjaOneDateTime {
	<#
	.SYNOPSIS
		Converts date/time values in a response object to [DateTime].
	.DESCRIPTION
		Recursively walks an object graph and converts ISO 8601 strings or Unix epoch values to [DateTime].
	.OUTPUTS
		[Object]
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[CmdletBinding()]
	[OutputType([Object])]
	param (
		[Parameter(Mandatory = $True)]
		[Object]$inputObject
	)
	$isoFormats = @(
		'o',
		'yyyy-MM-ddTHH:mm:ssK',
		'yyyy-MM-ddTHH:mm:ss.fffK',
		'yyyy-MM-ddTHH:mm:ss',
		'yyyy-MM-dd'
	)
	$invariantCulture = [System.Globalization.CultureInfo]::InvariantCulture
	$dateStyles = [System.Globalization.DateTimeStyles]::RoundtripKind
	function Convert-NinjaOneValue {
		<#
		.SYNOPSIS
			Converts individual values to [DateTime] where possible.
		.DESCRIPTION
			Handles strings, numeric epoch values, and nested collections, returning converted values when they
			match known date formats or epoch ranges.
		.OUTPUTS
			[Object]
		#>
		param (
			[Object]$value
		)
		if ($null -eq $value) {
			return $null
		}
		if ($value -is [string]) {
			if ($value -match '^[0-9]{10}$' -or $value -match '^[0-9]{13}$') {
				[long]$epochCandidate = 0
				if ([long]::TryParse($value, [ref]$epochCandidate)) {
					return Convert-NinjaOneEpoch -epochValue $epochCandidate
				}
			}
			if ($value -match '^[0-9]{10}\.[0-9]+$' -or $value -match '^[0-9]{13}\.[0-9]+$') {
				[double]$epochCandidate = 0
				if ([double]::TryParse($value, [ref]$epochCandidate)) {
					return Convert-NinjaOneEpochFraction -epochValue $epochCandidate
				}
			}
			[DateTime]$parsedDate = [DateTime]::MinValue
			if ([DateTime]::TryParseExact($value, $isoFormats, $invariantCulture, $dateStyles, [ref]$parsedDate)) {
				return $parsedDate
			}
			if ($value -match '^[0-9]{4}-[0-9]{2}-[0-9]{2}T') {
				$parseStyles = [System.Globalization.DateTimeStyles]::AssumeUniversal -bor [System.Globalization.DateTimeStyles]::AdjustToUniversal
				if ([DateTime]::TryParse($value, $invariantCulture, $parseStyles, [ref]$parsedDate)) {
					return $parsedDate
				}
			}
			return $value
		}
		if ($value -is [int] -or $value -is [long]) {
			return Convert-NinjaOneEpoch -epochValue ([long]$value)
		}
		if ($value -is [double] -or $value -is [decimal]) {
			return Convert-NinjaOneEpochFraction -epochValue ([double]$value)
		}
		if ($value -is [System.Collections.IDictionary]) {
			foreach ($Key in @($value.Keys)) {
				$value[$Key] = Convert-NinjaOneValue -value $value[$Key]
			}
			return $value
		}
		if ($value -is [System.Collections.IList]) {
			for ($Index = 0; $Index -lt $value.Count; $Index++) {
				$value[$Index] = Convert-NinjaOneValue -value $value[$Index]
			}
			return $value
		}
		if ($value -is [DateTime]) {
			return $value
		}
		if ($value -is [psobject]) {
			foreach ($Property in $value.PSObject.Properties) {
				$value.$($Property.Name) = Convert-NinjaOneValue -value $Property.Value
			}
			return $value
		}
		return $value
	}
	function Convert-NinjaOneEpoch {
		<#
		.SYNOPSIS
			Converts Unix epoch integer values to [DateTime].
		.DESCRIPTION
			Helper function to convert Unix epoch values (seconds or milliseconds) to PowerShell DateTime objects.
		#>
		param (
			[Parameter(Mandatory = $True)]
			[long]$epochValue
		)
		$minSeconds = 946684800
		$maxSeconds = 4102444800
		$minMilliseconds = 946684800000
		$maxMilliseconds = 4102444800000
		if ($epochValue -ge $minSeconds -and $epochValue -le $maxSeconds) {
			try {
				return [DateTimeOffset]::FromUnixTimeSeconds($epochValue).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddSeconds($epochValue)
			}
		}
		if ($epochValue -ge $minMilliseconds -and $epochValue -le $maxMilliseconds) {
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($epochValue).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($epochValue)
			}
		}
		return $epochValue
	}
	function Convert-NinjaOneEpochFraction {
		<#
		.SYNOPSIS
			Converts Unix epoch fractional values to [DateTime].
		.DESCRIPTION
			Helper function to convert Unix epoch values with fractional seconds (as double) to PowerShell DateTime objects.
		#>
		param (
			[Parameter(Mandatory = $True)]
			[double]$epochValue
		)
		$minSeconds = 946684800
		$maxSeconds = 4102444800
		$minMilliseconds = 946684800000
		$maxMilliseconds = 4102444800000
		if ($epochValue -ge $minSeconds -and $epochValue -le $maxSeconds) {
			$epochMilliseconds = [long][Math]::Round($epochValue * 1000)
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($epochMilliseconds).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($epochMilliseconds)
			}
		}
		if ($epochValue -ge $minMilliseconds -and $epochValue -le $maxMilliseconds) {
			$epochMilliseconds = [long][Math]::Round($epochValue)
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($epochMilliseconds).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($epochMilliseconds)
			}
		}
		return $epochValue
	}
	return Convert-NinjaOneValue -value $inputObject
}
