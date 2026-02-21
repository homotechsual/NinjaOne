function ConvertFrom-NinjaOneDateTime {
	<#
	.SYNOPSIS
		Converts date/time values in a response object to [DateTime].
	.DESCRIPTION
		Recursively walks an object graph and converts ISO 8601 strings or Unix epoch values to [DateTime].
	.OUTPUTS
		[Object]
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	param (
		[Parameter(Mandatory = $True)]
		[Object]$InputObject
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
		param (
			[Object]$Value
		)
		if ($null -eq $Value) {
			return $null
		}
		if ($Value -is [string]) {
			if ($Value -match '^[0-9]{10}$' -or $Value -match '^[0-9]{13}$') {
				[long]$epochCandidate = 0
				if ([long]::TryParse($Value, [ref]$epochCandidate)) {
					return Convert-NinjaOneEpoch -EpochValue $epochCandidate
				}
			}
			if ($Value -match '^[0-9]{10}\.[0-9]+$' -or $Value -match '^[0-9]{13}\.[0-9]+$') {
				[double]$epochCandidate = 0
				if ([double]::TryParse($Value, [ref]$epochCandidate)) {
					return Convert-NinjaOneEpochFraction -EpochValue $epochCandidate
				}
			}
			[DateTime]$parsedDate = [DateTime]::MinValue
			if ([DateTime]::TryParseExact($Value, $isoFormats, $invariantCulture, $dateStyles, [ref]$parsedDate)) {
				return $parsedDate
			}
			if ($Value -match '^[0-9]{4}-[0-9]{2}-[0-9]{2}T') {
				$parseStyles = [System.Globalization.DateTimeStyles]::AssumeUniversal -bor [System.Globalization.DateTimeStyles]::AdjustToUniversal
				if ([DateTime]::TryParse($Value, $invariantCulture, $parseStyles, [ref]$parsedDate)) {
					return $parsedDate
				}
			}
			return $Value
		}
		if ($Value -is [int] -or $Value -is [long]) {
			return Convert-NinjaOneEpoch -EpochValue ([long]$Value)
		}
		if ($Value -is [double] -or $Value -is [decimal]) {
			return Convert-NinjaOneEpochFraction -EpochValue ([double]$Value)
		}
		if ($Value -is [System.Collections.IDictionary]) {
			foreach ($Key in @($Value.Keys)) {
				$Value[$Key] = Convert-NinjaOneValue -Value $Value[$Key]
			}
			return $Value
		}
		if ($Value -is [System.Collections.IList]) {
			for ($Index = 0; $Index -lt $Value.Count; $Index++) {
				$Value[$Index] = Convert-NinjaOneValue -Value $Value[$Index]
			}
			return $Value
		}
		if ($Value -is [psobject]) {
			foreach ($Property in $Value.PSObject.Properties) {
				$Value.$($Property.Name) = Convert-NinjaOneValue -Value $Property.Value
			}
			return $Value
		}
		return $Value
	}
	function Convert-NinjaOneEpoch {
		param (
			[Parameter(Mandatory = $True)]
			[long]$EpochValue
		)
		$minSeconds = 946684800
		$maxSeconds = 4102444800
		$minMilliseconds = 946684800000
		$maxMilliseconds = 4102444800000
		if ($EpochValue -ge $minSeconds -and $EpochValue -le $maxSeconds) {
			try {
				return [DateTimeOffset]::FromUnixTimeSeconds($EpochValue).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddSeconds($EpochValue)
			}
		}
		if ($EpochValue -ge $minMilliseconds -and $EpochValue -le $maxMilliseconds) {
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($EpochValue).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($EpochValue)
			}
		}
		return $EpochValue
	}
	function Convert-NinjaOneEpochFraction {
		param (
			[Parameter(Mandatory = $True)]
			[double]$EpochValue
		)
		$minSeconds = 946684800
		$maxSeconds = 4102444800
		$minMilliseconds = 946684800000
		$maxMilliseconds = 4102444800000
		if ($EpochValue -ge $minSeconds -and $EpochValue -le $maxSeconds) {
			$epochMilliseconds = [long][Math]::Round($EpochValue * 1000)
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($epochMilliseconds).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($epochMilliseconds)
			}
		}
		if ($EpochValue -ge $minMilliseconds -and $EpochValue -le $maxMilliseconds) {
			$epochMilliseconds = [long][Math]::Round($EpochValue)
			try {
				return [DateTimeOffset]::FromUnixTimeMilliseconds($epochMilliseconds).UtcDateTime
			} catch {
				return (Get-Date 01.01.1970).AddMilliseconds($epochMilliseconds)
			}
		}
		return $EpochValue
	}
	return Convert-NinjaOneValue -Value $InputObject
}
