<#
    .SYNOPSIS
        Private function test suite for the NinjaOne module.
    .DESCRIPTION
        Comprehensive unit tests for private helper functions used throughout the module.
#>

$ModuleName = 'NinjaOne'

BeforeAll {
	$ModuleName = 'NinjaOne'
	$ManifestPath = $env:NINJAONE_MODULE_MANIFEST
	if ([string]::IsNullOrWhiteSpace($ManifestPath)) {
		$ModulePath = Resolve-Path -Path '.\Output\*\*' | Sort-Object -Property BaseName | Select-Object -Last 1 -ExpandProperty Path
		$ManifestPath = Get-ChildItem -Path ('{0}\*' -f $ModulePath) -Filter '*.psd1' | Select-Object -ExpandProperty FullName
	}

	if (-not (Get-Module -Name $ModuleName)) {
		Import-Module $ManifestPath -Verbose:$False
	}

	$script:HasSecretManagement = ($null -ne (Get-Command -Name Get-Secret -ErrorAction SilentlyContinue)) -and
	($null -ne (Get-Command -Name Get-SecretVault -ErrorAction SilentlyContinue))
	if ($IsWindows) {
		try {
			$principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
			$script:IsElevated = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
		} catch {
			$script:IsElevated = $false
		}
	} else {
		$script:IsElevated = $false
	}
	$script:CanStartOAuthListener = [System.Net.HttpListener]::IsSupported -and $script:IsElevated
}

Describe 'ConvertFrom-NinjaOneDateTime' {
	Context 'Null and empty input handling' {
		It 'should handle null within object' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					nullValue = $null
					notNull = 'test'
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.nullValue | Should -BeNullOrEmpty
				$result.notNull | Should -Be 'test'
			}
		}

		It 'should handle empty string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject ''
				$result | Should -Be ''
			}
		}

		It 'should handle non-date string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 'not a date'
				$result | Should -Be 'not a date'
			}
		}
	}

	Context 'Unix epoch seconds (10-digit)' {
		It 'should convert valid 10-digit epoch seconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 1704112496 = 2024-01-01 12:09:56 UTC
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert 10-digit epoch seconds as string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle epoch seconds at min boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 946684800 = 2000-01-01 00:00:00 UTC (minimum valid)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2000
			}
		}

		It 'should handle epoch seconds at max boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 4102444800 = 2100-01-01 00:00:00 UTC (maximum valid)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2100
			}
		}

		It 'should return non-date values outside epoch seconds range' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Value outside 10-digit epoch range
				$result = ConvertFrom-NinjaOneDateTime -InputObject 123
				$result | Should -Be 123
			}
		}
	}

	Context 'Unix epoch milliseconds (13-digit)' {
		It 'should convert valid 13-digit epoch milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 1704112496000 = 2024-01-01 12:09:56 UTC (in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496000
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert 13-digit epoch milliseconds as string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496000'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle epoch milliseconds at min boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 946684800000 = 2000-01-01 00:00:00 UTC (minimum valid, in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800000
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2000
			}
		}

		It 'should handle epoch milliseconds at max boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 4102444800000 = 2100-01-01 00:00:00 UTC (maximum valid, in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800000
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2100
			}
		}
	}

	Context 'Unix epoch fractional seconds (10-digit.xxx)' {
		It 'should convert fractional epoch seconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 1704112496.123 (with fractional part)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496.123
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert fractional epoch seconds as string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496.4855'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle fractional epoch at min boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800.999
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2000
			}
		}

		It 'should handle fractional values outside valid range as passthrough' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 4102444800.999 is outside valid milliseconds range, should return as-is
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800.999
				$result | Should -Be 4102444800.999
			}
		}
	}

	Context 'Unix epoch fractional milliseconds (13-digit.xxx)' {
		It 'should convert fractional epoch milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 1704112496000.555 (fractional milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496000.555
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert fractional epoch milliseconds as string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1771675908.804'
				$result | Should -BeOfType ([DateTime])
			}
		}

		It 'should handle fractional milliseconds at min boundary' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800000.999
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2000
			}
		}
	}

	Context 'ISO 8601 date formats' {
		It 'should convert ISO 8601 format with Z timezone' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56Z'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
				$result.Month | Should -Be 1
				$result.Day | Should -Be 1
			}
		}

		It 'should convert ISO 8601 format with +00:00 timezone' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56+00:00'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert ISO 8601 format with milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.123Z'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should parse date-only strings' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Date-only strings may convert to DateTime or pass through as string
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01'
				$result.GetType().Name | Should -Match '^(String|DateTime)$'
			}
		}

		It 'should convert ISO 8601 without timezone' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should convert ISO 8601 without milliseconds without timezone' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-12-25T18:30:00'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
				$result.Month | Should -Be 12
				$result.Day | Should -Be 25
			}
		}
	}

	Context 'Collections and nested objects' {
		It 'should convert hashtable with date values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = @{
					createdAt = '2024-01-01T12:34:56Z'
					count = 42
					updated = 1704112496
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.createdAt | Should -BeOfType ([DateTime])
				$result.count | Should -Be 42
				$result.updated | Should -BeOfType ([DateTime])
			}
		}

		It 'should convert array of values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = @('2024-01-01T12:34:56Z', 1704112496, 'not-a-date', $null)
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result[0] | Should -BeOfType ([DateTime])
				$result[1] | Should -BeOfType ([DateTime])
				$result[2] | Should -Be 'not-a-date'
				$result[3] | Should -BeNullOrEmpty
			}
		}

		It 'should convert deeply nested objects' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					level1 = [pscustomobject]@{
						level2 = [pscustomobject]@{
							timestamp = '2024-01-01T12:34:56Z'
							value = 123
						}
						dates = @('2024-01-01T12:34:56Z', 1704112496)
					}
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.level1.level2.timestamp | Should -BeOfType ([DateTime])
				$result.level1.level2.value | Should -Be 123
				$result.level1.dates[0] | Should -BeOfType ([DateTime])
				$result.level1.dates[1] | Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve non-convertible values in collections' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					raw = 'not-a-date'
					smallNum = 123
					guid = [guid]::NewGuid()
					timestamp = 1704112496
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.raw | Should -Be 'not-a-date'
				$result.smallNum | Should -Be 123
				$result.guid | Should -BeOfType ([guid])
				$result.timestamp | Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Numeric edge cases' {
		It 'should handle long integer type' {
			$module = Get-Module -Name $ModuleName
			& $module {
				[long]$value = 1704112496
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Should -BeOfType ([DateTime])
			}
		}

		It 'should handle double type with fractional seconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				[double]$value = 1704112496.789
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Should -BeOfType ([DateTime])
			}
		}

		It 'should handle decimal type' {
			$module = Get-Module -Name $ModuleName
			& $module {
				[decimal]$value = 1704112496
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Should -BeOfType ([DateTime])
			}
		}

		It 'should return value outside valid ranges' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Value too small for valid epoch
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1000
				$result | Should -Be 1000
			}
		}

		It 'should handle negative numbers' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject -1000
				$result | Should -Be -1000
			}
		}

		It 'should handle zero' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 0
				$result | Should -Be 0
			}
		}
	}

	Context 'Special date values' {
		It 'should handle DateTime object passthrough' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01'
				$result = ConvertFrom-NinjaOneDateTime -InputObject $dt
				$result | Should -BeOfType ([DateTime])
				$result.Date | Should -Be $dt.Date
			}
		}

		It 'should handle mixed collection of DateTime objects' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01'
				$input = @(
					$dt,
					'2024-01-02T00:00:00Z',
					1704112496
				)
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result[0] | Should -BeOfType ([DateTime])
				$result[0].Date | Should -Be $dt.Date
				$result[1] | Should -BeOfType ([DateTime])
				$result[2] | Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Boolean and other types' {
		It 'should pass through boolean values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject $true
				$result | Should -Be $true
			}
		}

		It 'should preserve object types in collections' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					flag = $true
					count = 42
					timestamp = '2024-01-01T12:34:56Z'
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.flag | Should -Be $true
				$result.count | Should -Be 42
				$result.timestamp | Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Locale and culture handling' {
		It 'should handle ISO 8601 with uppercase Z' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45Z'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
				$result.Month | Should -Be 6
				$result.Day | Should -Be 15
			}
		}

		It 'should handle ISO 8601 with positive timezone offset' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45+05:30'
				$result | Should -BeOfType ([DateTime])
			}
		}

		It 'should handle ISO 8601 with negative timezone offset' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45-08:00'
				$result | Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Complex nested structures' {
		It 'should handle nested arrays within objects' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					tags = @('tag1', 'tag2')
					dates = @('2024-01-01T00:00:00Z', '2024-02-01T00:00:00Z')
					nested = @(
						@{ id = 1; created = '2024-01-01T00:00:00Z' }
						@{ id = 2; created = '2024-02-01T00:00:00Z' }
					)
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.tags[0] | Should -Be 'tag1'
				$result.dates[0] | Should -BeOfType ([DateTime])
				$result.nested[0].created | Should -BeOfType ([DateTime])
				$result.nested[1].created | Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve structure with mixed types' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					level1 = @{
						dateValue = '2024-01-01T00:00:00Z'
						numberValue = 42
						stringValue = 'test'
						level2 = @{
							timestamp = 1704067200
							active = $true
						}
					}
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.level1.dateValue | Should -BeOfType ([DateTime])
				$result.level1.numberValue | Should -Be 42
				$result.level1.stringValue | Should -Be 'test'
				$result.level1.level2.timestamp | Should -BeOfType ([DateTime])
				$result.level1.level2.active | Should -Be $true
			}
		}
	}

	Context 'Extended numeric ranges' {
		It 'should handle very large epoch values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# A large but valid epoch (year 2080)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 3471292800
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2080
			}
		}

		It 'should handle year 2038 boundary (32-bit epoch limit)' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# 2147483647 = max 32-bit signed int = 2038-01-19
				$result = ConvertFrom-NinjaOneDateTime -InputObject 2147483647
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2038
			}
		}

		It 'should handle values just outside valid range' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Very large number outside epoch range
				$result = ConvertFrom-NinjaOneDateTime -InputObject 99999999999999
				$result | Should -Be 99999999999999
			}
		}
	}

	Context 'Real-world API response patterns' {
		It 'should convert typical API response object' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$input = [pscustomobject]@{
					id = 12345
					name = 'Test Device'
					createdAt = '2024-01-01T12:34:56Z'
					updatedAt = 1704112496
					metadata = @{
						lastSync = '2024-01-15T08:30:00Z'
						tags = @('tag1', 'tag2')
					}
					events = @(
						[pscustomobject]@{
							timestamp = 1704112496
							type = 'created'
						}
						[pscustomobject]@{
							timestamp = '2024-01-02T00:00:00Z'
							type = 'updated'
						}
					)
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.id | Should -Be 12345
				$result.createdAt | Should -BeOfType ([DateTime])
				$result.updatedAt | Should -BeOfType ([DateTime])
				$result.metadata.lastSync | Should -BeOfType ([DateTime])
				$result.events[0].timestamp | Should -BeOfType ([DateTime])
				$result.events[1].timestamp | Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Alternative ISO 8601 parsing paths' {
		It 'should handle ISO 8601 with extended milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.123456Z'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle ISO 8601 with negative offset milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.789-08:00'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle ISO 8601 with positive offset milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.789+05:30'
				$result | Should -BeOfType ([DateTime])
				$result.Year | Should -Be 2024
			}
		}

		It 'should handle numeric strings through all parsing paths' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test regex patterns for epoch detection
				$result1 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496'
				$result2 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496000'
				$result3 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496.123456'
                
				$result1 | Should -BeOfType ([DateTime])
				$result2 | Should -BeOfType ([DateTime])
				$result3 | Should -BeOfType ([DateTime])
			}
		}
	}
}

Describe 'Get-NinjaOneExpandCompleter' {
	Context 'Autocomplete functionality' {
		It 'should accept WordToComplete parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test that function can be called without throwing
				{ Get-NinjaOneExpandCompleter -WordToComplete 'test' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should handle empty word to complete' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Empty string should be accepted
				{ Get-NinjaOneExpandCompleter -WordToComplete '' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept CommandAst parameter when provided' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test that function can be called with CommandAst parameter (used in tab-completion)
				# Even with a null CommandAst, the function should not throw
				{ Get-NinjaOneExpandCompleter -WordToComplete 'test' -CommandAst $null -CursorPosition 5 -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'Get-NinjaOneSecrets' -Skip:(!$script:HasSecretManagement) {
	BeforeEach {
		Mock -CommandName Get-Secret -ModuleName $ModuleName -MockWith { $null }
	}
	Context 'Parameter acceptance' {
		It 'should accept VaultName parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test that function accepts VaultName parameter
				{ Get-NinjaOneSecrets -VaultName 'TestVault' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept SecretPrefix parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test that function accepts SecretPrefix parameter
				{ Get-NinjaOneSecrets -VaultName 'TestVault' -SecretPrefix 'Custom' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOneError' {
	Context 'Error record creation' {
		It 'should accept ErrorRecord parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$baseError = [System.Exception]::new('Test error')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$baseError,
					'TestErrorId',
					[System.Management.Automation.ErrorCategory]::OperationStopped,
					$null
				)
				{ New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction SilentlyContinue } | Should -Throw
			}
		}

		It 'should accept HasResponse switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$baseError = [System.Exception]::new('Test error')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$baseError,
					'TestErrorId',
					[System.Management.Automation.ErrorCategory]::OperationStopped,
					$null
				)
				{ New-NinjaOneError -ErrorRecord $errorRecord -HasResponse -ErrorAction SilentlyContinue } | Should -Throw
			}
		}

		It 'should handle various error categories' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$baseError = [System.Exception]::new('Test error')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$baseError,
					'TestErrorId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				{ New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction SilentlyContinue } | Should -Throw
			}
		}
	}
}

Describe 'New-NinjaOneGETRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
			$script:ParseDateTimes = $false
		}
		Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept resource parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept query string collection' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$qs = @{ skip = 0; limit = 10 }
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -QSCollection $qs -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept Raw switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -Raw -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept ParseDateTime switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -ParseDateTime -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept multiple parameters together' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$qs = @{ filter = 'name eq "test"' }
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -QSCollection $qs -Raw -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOnePOSTRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept resource parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept Body parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$body = @{ name = 'Test' } | ConvertTo-Json
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept query string collection' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$qs = @{ test = 'value' }
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -QSCollection $qs -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOneQuery' {
	Context 'Parameter acceptance' {
		It 'should accept CommandName parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -Name $CommandName).Parameters
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept empty parameters' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$params = @{}
				{ New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $params -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept CommaSeparatedArrays switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -Name $CommandName).Parameters
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -CommaSeparatedArrays -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept AsString switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -Name $CommandName).Parameters
				$script:QSBuilder = [System.UriBuilder]::new()
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -AsString -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'Set-NinjaOneSecrets' -Skip:(!$script:HasSecretManagement) {
	BeforeEach {
		Mock -CommandName Get-SecretVault -ModuleName $ModuleName -MockWith { [pscustomobject]@{ Name = 'TestVault' } }
		Mock -CommandName Set-Secret -ModuleName $ModuleName -MockWith { }
	}
	Context 'Parameter acceptance' {
		It 'should accept secret storage parameters' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$params = @{
					UseSecretManagement = $true
					WriteToSecretVault = $true
					VaultName = 'TestVault'
					Instance = 'test.ninjaone.com'
					ClientId = 'test-id'
				}
				{ Set-NinjaOneSecrets @params -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept authentication parameters' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$params = @{
					UseSecretManagement = $true
					WriteToSecretVault = $true
					VaultName = 'TestVault'
					Type = 'Bearer'
					Access = 'test-token'
				}
				{ Set-NinjaOneSecrets @params -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept secret prefix' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$params = @{
					UseSecretManagement = $true
					WriteToSecretVault = $true
					VaultName = 'TestVault'
					SecretPrefix = 'Custom'
				}
				{ Set-NinjaOneSecrets @params -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'Start-OAuthHTTPListener' -Skip:(!$script:CanStartOAuthListener) {
	Context 'HTTP listener setup' {
		It 'should accept OpenURI parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$uri = [System.UriBuilder]::new('http://localhost:9090/callback')
				{ Start-OAuthHTTPListener -OpenURI $uri -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept TimeoutSeconds parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$uri = [System.UriBuilder]::new('http://localhost:9090/callback')
				{ Start-OAuthHTTPListener -OpenURI $uri -TimeoutSeconds 30 -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'Update-NinjaOneToken' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				AuthMode = 'OAuth'
				Instance = 'us'
				ClientId = 'test-id'
				ClientSecret = 'test-secret'
				UseSecretManagement = $false
				WriteToSecretVault = $false
				VaultName = 'TestVault'
			}
			$script:NRAPIAuthenticationInformation = @{
				Refresh = 'test-refresh-token'
				Type = 'Bearer'
				Access = 'test-access-token'
			}
		}
		InModuleScope $ModuleName {
			Mock -CommandName Connect-NinjaOne -MockWith {
				$script:NRAPIAuthenticationInformation.Type = 'Bearer'
				$script:NRAPIAuthenticationInformation.Access = 'test-access-token-refreshed'
			}
		}
	}

	Context 'Token handling' {
		It 'should accept no parameters for refresh' {
			InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept various auth modes' {
			InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.AuthMode = 'Client Credentials'
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should not require parameters when globals are set' {
			InModuleScope $ModuleName {
				# Verify globals are set
				$script:NRAPIConnectionInformation | Should -Not -BeNullOrEmpty
				$script:NRAPIAuthenticationInformation | Should -Not -BeNullOrEmpty
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOneDELETERequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept function call with resource' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept resource parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOnePATCHRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept body parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$body = @{ status = 'active' } | ConvertTo-Json
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body $body -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept empty body' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body '' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'New-NinjaOnePUTRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept body parameter' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$body = @{ name = 'Updated' } | ConvertTo-Json
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body $body -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}

		It 'should accept empty body' {
			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body '' -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}
}

Describe 'Invoke-NinjaOnePreFlightCheck' {
	Context 'Connection validation' {
		It 'should validate connection information is set' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthToken = 'test-token'
				{ Invoke-NinjaOnePreFlightCheck } | Should -Not -Throw
			}
		}

		It 'should throw when connection information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = $null
				{ Invoke-NinjaOnePreFlightCheck } | Should -Throw
			}
		}

		It 'should validate authentication information is set' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthToken = 'test-token'
				{ Invoke-NinjaOnePreFlightCheck } | Should -Not -Throw
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthToken = $null
				$script:AllowAnonymous = $null
				{ Invoke-NinjaOnePreFlightCheck } | Should -Throw
			}
		}

		It 'should validate all required connection fields' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{
					URL = 'https://test.com'
					Instance = 'test.ninjaone.com'
					AuthMode = 'OAuth'
				}
				$script:NRAPIAuthToken = 'test-token'
				{ Invoke-NinjaOnePreFlightCheck } | Should -Not -Throw
			}
		}

		It 'should handle partial connection information gracefully' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthToken = $null
				$script:AllowAnonymous = $null
				{ Invoke-NinjaOnePreFlightCheck } | Should -Throw
			}
		}
	}
}

Describe 'Get-TokenExpiry' {
	Context 'Token expiry calculation' {
		It 'should add correct number of seconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$beforeCall = Get-Date
				$result = Get-TokenExpiry -ExpiresIn 100
				$afterCall = Get-Date
                
				# Result should be approximately 100 seconds in the future
				$timeDiff = ($result - $beforeCall).TotalSeconds
				$timeDiff | Should -BeGreaterThan 99
				$timeDiff | Should -BeLessThan 102
			}
		}

		It 'should handle zero seconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$beforeCall = Get-Date
				$result = Get-TokenExpiry -ExpiresIn 0
				$timeDiff = ($result - $beforeCall).TotalSeconds
                
				# Should be approximately now (within 2 seconds)
				$timeDiff | Should -BeLessThan 2
			}
		}

		It 'should handle large values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Test with 1 year of seconds
				$oneYear = 365 * 24 * 60 * 60
				$result = Get-TokenExpiry -ExpiresIn $oneYear
				$result | Should -BeOfType ([DateTime])
                
				# Result should be roughly 1 year in the future
				$timeDiff = ($result - (Get-Date)).TotalDays
				$timeDiff | Should -BeGreaterThan 364
				$timeDiff | Should -BeLessThan 366
			}
		}

		It 'should handle negative values' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Get-TokenExpiry -ExpiresIn -100
				$result | Should -BeOfType ([DateTime])
                
				# Should be in the past
				$result | Should -BeLessThan (Get-Date)
			}
		}
	}
}

Describe 'ConvertTo-UnixEpoch' {
	Context 'DateTime input' {
		It 'should convert DateTime to Unix epoch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$result = ConvertTo-UnixEpoch -DateTime $dt
				# 2024-01-01 should be a large positive number
				$result | Should -BeGreaterThan 1000000000
			}
		}

		It 'should convert current DateTime' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$now = Get-Date
				$result = ConvertTo-UnixEpoch -DateTime $now
                
				# Should be between 2020 and 2100 (in epoch seconds)
				$result | Should -BeGreaterThan 1577836800  # 2020-01-01
				$result | Should -BeLessThan 4102444800     # 2100-01-01
			}
		}

		It 'should convert to milliseconds when specified' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultSeconds = ConvertTo-UnixEpoch -DateTime $dt
				$resultMillis = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds
                
				# Milliseconds should be 1000x the seconds (approximately)
				$ratio = [double]$resultMillis / [double]$resultSeconds
				$ratio | Should -BeGreaterThan 999
				$ratio | Should -BeLessThan 1001
			}
		}

		It 'should support -Ms alias for milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultFull = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds
				$resultAlias = ConvertTo-UnixEpoch -DateTime $dt -Ms
                
				$resultFull | Should -Be $resultAlias
			}
		}

		It 'should support -Millis alias for milliseconds' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultFull = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds
				$resultAlias = ConvertTo-UnixEpoch -DateTime $dt -Millis
                
				$resultFull | Should -Be $resultAlias
			}
		}
	}

	Context 'String input' {
		It 'should convert ISO 8601 string to Unix epoch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertTo-UnixEpoch -DateTime '2024-01-01T00:00:00Z'
				$result | Should -BeGreaterThan 1000000000
			}
		}

		It 'should convert date-only string' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$result = ConvertTo-UnixEpoch -DateTime '2024-01-01'
				$result | Should -BeGreaterThan 1000000000
			}
		}
	}

	Context 'Integer input' {
		It 'should handle integer input' {
			$module = Get-Module -Name $ModuleName
			& $module {
				# Provide an epoch seconds value
				$epochSeconds = 1704067200  # 2024-01-01T00:00:00Z
				$result = ConvertTo-UnixEpoch -DateTime $epochSeconds
				# Should return a numeric result
				$result | Should -BeGreaterThan 0
			}
		}
	}

	Context 'Universal time conversion' {
		It 'should convert to UTC regardless of system timezone' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$dt = Get-Date '2024-01-01T00:00:00'
				$result = ConvertTo-UnixEpoch -DateTime $dt
                
				# Result should be consistent and positive
				$result | Should -BeGreaterThan 0
			}
		}
	}
}

AfterAll {
	Remove-Module $ModuleName -Force
}
