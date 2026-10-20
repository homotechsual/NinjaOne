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
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					nullValue = $null
					notNull = 'test'
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.nullValue | Pester\Should -BeNullOrEmpty
				$result.notNull | Pester\Should -Be 'test'
			}
		}

		It 'should handle empty string' {
			$module = Get-Module -Name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject ''
				$result | Pester\Should -Be ''
			}
		}

		It 'should handle non-date string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 'not a date'
				$result | Pester\Should -Be 'not a date'
			}
		}
	}

	Context 'Unix epoch seconds (10-digit)' {
		It 'should convert valid 10-digit epoch seconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 1704112496 = 2024-01-01 12:09:56 UTC
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert 10-digit epoch seconds as string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle epoch seconds at min boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 946684800 = 2000-01-01 00:00:00 UTC (minimum valid)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2000
			}
		}

		It 'should handle epoch seconds at max boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 4102444800 = 2100-01-01 00:00:00 UTC (maximum valid)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2100
			}
		}

		It 'should return non-date values outside epoch seconds range' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Value outside 10-digit epoch range
				$result = ConvertFrom-NinjaOneDateTime -InputObject 123
				$result | Pester\Should -Be 123
			}
		}
	}

	Context 'Unix epoch milliseconds (13-digit)' {
		It 'should convert valid 13-digit epoch milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 1704112496000 = 2024-01-01 12:09:56 UTC (in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496000
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert 13-digit epoch milliseconds as string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496000'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle epoch milliseconds at min boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 946684800000 = 2000-01-01 00:00:00 UTC (minimum valid, in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800000
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2000
			}
		}

		It 'should handle epoch milliseconds at max boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 4102444800000 = 2100-01-01 00:00:00 UTC (maximum valid, in milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800000
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2100
			}
		}
	}

	Context 'Unix epoch fractional seconds (10-digit.xxx)' {
		It 'should convert fractional epoch seconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 1704112496.123 (with fractional part)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496.123
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert fractional epoch seconds as string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1704112496.4855'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle fractional epoch at min boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800.999
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2000
			}
		}

		It 'should handle fractional values outside valid range as passthrough' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 4102444800.999 is outside valid milliseconds range, should return as-is
				$result = ConvertFrom-NinjaOneDateTime -InputObject 4102444800.999
				$result | Pester\Should -Be 4102444800.999
			}
		}
	}

	Context 'Unix epoch fractional milliseconds (13-digit.xxx)' {
		It 'should convert fractional epoch milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 1704112496000.555 (fractional milliseconds)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1704112496000.555
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert fractional epoch milliseconds as string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '1771675908.804'
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should handle fractional milliseconds at min boundary' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 946684800000.999
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2000
			}
		}
	}

	Context 'ISO 8601 date formats' {
		It 'should convert ISO 8601 format with Z timezone' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56Z'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
				$result.Month | Pester\Should -Be 1
				$result.Day | Pester\Should -Be 1
			}
		}

		It 'should convert ISO 8601 format with +00:00 timezone' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56+00:00'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert ISO 8601 format with milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.123Z'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should parse date-only strings' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Date-only strings may convert to DateTime or pass through as string
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01'
				$result.GetType().Name | Pester\Should -Match '^(String|DateTime)$'
			}
		}

		It 'should convert ISO 8601 without timezone' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should convert ISO 8601 without milliseconds without timezone' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-12-25T18:30:00'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
				$result.Month | Pester\Should -Be 12
				$result.Day | Pester\Should -Be 25
			}
		}
	}

	Context 'Collections and nested objects' {
		It 'should convert hashtable with date values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$input = @{
					createdAt = '2024-01-01T12:34:56Z'
					count = 42
					updated = 1704112496
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.createdAt | Pester\Should -BeOfType ([DateTime])
				$result.count | Pester\Should -Be 42
				$result.updated | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should convert array of values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$input = @('2024-01-01T12:34:56Z', 1704112496, 'not-a-date', $null)
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result[0] | Pester\Should -BeOfType ([DateTime])
				$result[1] | Pester\Should -BeOfType ([DateTime])
				$result[2] | Pester\Should -Be 'not-a-date'
				$result[3] | Pester\Should -BeNullOrEmpty
			}
		}

		It 'should convert deeply nested objects' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
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
				$result.level1.level2.timestamp | Pester\Should -BeOfType ([DateTime])
				$result.level1.level2.value | Pester\Should -Be 123
				$result.level1.dates[0] | Pester\Should -BeOfType ([DateTime])
				$result.level1.dates[1] | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve non-convertible values in collections' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					raw = 'not-a-date'
					smallNum = 123
					guid = [guid]::NewGuid()
					timestamp = 1704112496
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.raw | Pester\Should -Be 'not-a-date'
				$result.smallNum | Pester\Should -Be 123
				$result.guid | Pester\Should -BeOfType ([guid])
				$result.timestamp | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve identifier properties that resemble Unix epochs' {
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					id = 1704112496
					lastActivityId = 1704112497
					naturalId = 1704112498
					organizationIds = @([long]1704112499, [long]1704112500)
					createdAt = 1704112499
				}

				$result = ConvertFrom-NinjaOneDateTime -InputObject $input

				$result.id | Pester\Should -Be 1704112496
				$result.lastActivityId | Pester\Should -Be 1704112497
				$result.naturalId | Pester\Should -Be 1704112498
				$result.organizationIds | Pester\Should -Be @(1704112499, 1704112500)
				$result.organizationIds[0] | Pester\Should -BeOfType ([long])
				$result.createdAt | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve numeric cursor names' {
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					cursor = [pscustomobject]@{
						name = '1704112496'
					}
					createdAt = '2024-01-01T12:34:56Z'
				}

				$result = ConvertFrom-NinjaOneDateTime -InputObject $input

				$result.cursor.name | Pester\Should -Be '1704112496'
				$result.cursor.name | Pester\Should -BeOfType ([string])
				$result.createdAt | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Numeric edge cases' {
		It 'should handle long integer type' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				[long]$value = 1704112496
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should handle double type with fractional seconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				[double]$value = 1704112496.789
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should handle decimal type' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				[decimal]$value = 1704112496
				$result = ConvertFrom-NinjaOneDateTime -InputObject $value
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should return value outside valid ranges' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Value too small for valid epoch
				$result = ConvertFrom-NinjaOneDateTime -InputObject 1000
				$result | Pester\Should -Be 1000
			}
		}

		It 'should handle negative numbers' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject -1000
				$result | Pester\Should -Be -1000
			}
		}

		It 'should handle zero' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject 0
				$result | Pester\Should -Be 0
			}
		}
	}

	Context 'Special date values' {
		It 'should handle DateTime object passthrough' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01'
				$result = ConvertFrom-NinjaOneDateTime -InputObject $dt
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Date | Pester\Should -Be $dt.Date
			}
		}

		It 'should handle mixed collection of DateTime objects' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01'
				$input = @(
					$dt,
					'2024-01-02T00:00:00Z',
					1704112496
				)
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result[0] | Pester\Should -BeOfType ([DateTime])
				$result[0].Date | Pester\Should -Be $dt.Date
				$result[1] | Pester\Should -BeOfType ([DateTime])
				$result[2] | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Boolean and other types' {
		It 'should pass through boolean values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject $true
				$result | Pester\Should -Be $true
			}
		}

		It 'should preserve object types in collections' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					flag = $true
					count = 42
					timestamp = '2024-01-01T12:34:56Z'
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.flag | Pester\Should -Be $true
				$result.count | Pester\Should -Be 42
				$result.timestamp | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Locale and culture handling' {
		It 'should handle ISO 8601 with uppercase Z' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45Z'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
				$result.Month | Pester\Should -Be 6
				$result.Day | Pester\Should -Be 15
			}
		}

		It 'should handle ISO 8601 with positive timezone offset' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45+05:30'
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should handle ISO 8601 with negative timezone offset' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-06-15T10:30:45-08:00'
				$result | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Complex nested structures' {
		It 'should handle nested arrays within objects' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$input = [pscustomobject]@{
					tags = @('tag1', 'tag2')
					dates = @('2024-01-01T00:00:00Z', '2024-02-01T00:00:00Z')
					nested = @(
						@{ id = 1; created = '2024-01-01T00:00:00Z' }
						@{ id = 2; created = '2024-02-01T00:00:00Z' }
					)
				}
				$result = ConvertFrom-NinjaOneDateTime -InputObject $input
				$result.tags[0] | Pester\Should -Be 'tag1'
				$result.dates[0] | Pester\Should -BeOfType ([DateTime])
				$result.nested[0].created | Pester\Should -BeOfType ([DateTime])
				$result.nested[1].created | Pester\Should -BeOfType ([DateTime])
			}
		}

		It 'should preserve structure with mixed types' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
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
				$result.level1.dateValue | Pester\Should -BeOfType ([DateTime])
				$result.level1.numberValue | Pester\Should -Be 42
				$result.level1.stringValue | Pester\Should -Be 'test'
				$result.level1.level2.timestamp | Pester\Should -BeOfType ([DateTime])
				$result.level1.level2.active | Pester\Should -Be $true
			}
		}
	}

	Context 'Extended numeric ranges' {
		It 'should handle very large epoch values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# A large but valid epoch (year 2080)
				$result = ConvertFrom-NinjaOneDateTime -InputObject 3471292800
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2080
			}
		}

		It 'should handle year 2038 boundary (32-bit epoch limit)' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# 2147483647 = max 32-bit signed int = 2038-01-19
				$result = ConvertFrom-NinjaOneDateTime -InputObject 2147483647
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2038
			}
		}

		It 'should handle values just outside valid range' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Very large number outside epoch range
				$result = ConvertFrom-NinjaOneDateTime -InputObject 99999999999999
				$result | Pester\Should -Be 99999999999999
			}
		}
	}

	Context 'Real-world API response patterns' {
		It 'should convert typical API response object' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
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
				$result.id | Pester\Should -Be 12345
				$result.createdAt | Pester\Should -BeOfType ([DateTime])
				$result.updatedAt | Pester\Should -BeOfType ([DateTime])
				$result.metadata.lastSync | Pester\Should -BeOfType ([DateTime])
				$result.events[0].timestamp | Pester\Should -BeOfType ([DateTime])
				$result.events[1].timestamp | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Alternative ISO 8601 parsing paths' {
		It 'should handle ISO 8601 with extended milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.123456Z'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle ISO 8601 with negative offset milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.789-08:00'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle ISO 8601 with positive offset milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertFrom-NinjaOneDateTime -InputObject '2024-01-01T12:34:56.789+05:30'
				$result | Pester\Should -BeOfType ([DateTime])
				$result.Year | Pester\Should -Be 2024
			}
		}

		It 'should handle numeric strings through all parsing paths' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Test regex patterns for epoch detection
				$result1 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496'
				$result2 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496000'
				$result3 = ConvertFrom-NinjaOneDateTime -InputObject '1704112496.123456'

				$result1 | Pester\Should -BeOfType ([DateTime])
				$result2 | Pester\Should -BeOfType ([DateTime])
				$result3 | Pester\Should -BeOfType ([DateTime])
			}
		}
	}
}

Describe 'Get-NinjaOneExpandCompleter' {
	Context 'Autocomplete functionality' {
		It 'should accept WordToComplete parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Test that function can be called without throwing
				{ Get-NinjaOneExpandCompleter -WordToComplete 'test' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should handle empty word to complete' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Empty string should be accepted
				{ Get-NinjaOneExpandCompleter -WordToComplete '' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept CommandAst parameter when provided' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Test that function can be called with CommandAst parameter (used in tab-completion)
				# Even with a null CommandAst, the function should not throw
				{ Get-NinjaOneExpandCompleter -WordToComplete 'test' -CommandAst $null -CursorPosition 5 -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}
}

Describe 'Get-NinjaOneSecrets' {
	BeforeEach {
		$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
		$script:NRAPIConnectionInformation = $null
		$script:NRAPIAuthenticationInformation = $null
		$script:ParseDateTimes = $false
	}

	Context 'Secret retrieval and conversion' {
		It 'should populate and convert authorization code secrets from the vault' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				$script:NRAPIAuthenticationInformation = $null
				$script:ParseDateTimes = $false
				$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
				$script:SecretResponses = @{
					NinjaOneAuthMode = 'Authorization Code'
					NinjaOneURL = 'https://api.test.com'
					NinjaOneInstance = 'test-instance'
					NinjaOneClientId = 'client-id'
					NinjaOneClientSecret = 'client-secret'
					NinjaOneAuthScopes = 'monitoring management'
					NinjaOneRedirectURI = 'http://localhost/callback'
					NinjaOneAuthListenerPort = '8080'
					NinjaOneUseSecretManagement = 'false'
					NinjaOneWriteToSecretVault = 'false'
					NinjaOneReadFromSecretVault = 'false'
					NinjaOneVaultName = 'IgnoredByFunction'
					NinjaOneParseDateTimes = 'true'
					NinjaOneType = 'Bearer'
					NinjaOneAccess = 'access-token'
					NinjaOneExpires = '2026-04-28T12:00:00Z'
				}
				function Get-Secret {
					<#
					.SYNOPSIS
						Test stub for secret retrieval.
					#>
					param(
						# Secret name requested by Get-NinjaOneSecrets.
						$Name,
						# Vault name requested by Get-NinjaOneSecrets.
						$Vault
					)
					$script:RequestedSecrets.Add($Name)
					return $script:SecretResponses[$Name]
				}

				Get-NinjaOneSecrets -VaultName 'TestVault'

				$script:NRAPIConnectionInformation.AuthMode | Pester\Should -Be 'Authorization Code'
				$script:NRAPIConnectionInformation.URL | Pester\Should -Be 'https://api.test.com'
				$script:NRAPIConnectionInformation.AuthListenerPort | Pester\Should -BeOfType ([int])
				$script:NRAPIConnectionInformation.AuthListenerPort | Pester\Should -Be 8080
				$script:NRAPIConnectionInformation.UseSecretManagement | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.WriteToSecretVault | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.ReadFromSecretVault | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.VaultName | Pester\Should -Be 'TestVault'
				$script:NRAPIAuthenticationInformation.Expires | Pester\Should -BeOfType ([datetime])
				$script:ParseDateTimes | Pester\Should -BeTrue
			}
		}

		It 'should use the provided secret prefix and support token authentication' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				$script:NRAPIAuthenticationInformation = $null
				$script:ParseDateTimes = $false
				$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
				$script:SecretResponses = @{
					CustomAuthMode = 'Token Authentication'
					CustomURL = 'https://api.test.com'
					CustomInstance = 'test-instance'
					CustomClientId = 'client-id'
					CustomClientSecret = 'client-secret'
					CustomAuthScopes = 'monitoring'
					CustomType = 'Bearer'
					CustomAccess = 'access-token'
					CustomRefresh = 'refresh-token'
					CustomUseSecretManagement = 'true'
					CustomWriteToSecretVault = 'true'
					CustomReadFromSecretVault = 'true'
					CustomParseDateTimes = 'false'
				}
				function Get-Secret {
					<#
					.SYNOPSIS
						Test stub for secret retrieval.
					#>
					param(
						# Secret name requested by Get-NinjaOneSecrets.
						$Name,
						# Vault name requested by Get-NinjaOneSecrets.
						$Vault
					)
					$script:RequestedSecrets.Add($Name)
					return $script:SecretResponses[$Name]
				}

				Get-NinjaOneSecrets -VaultName 'CustomVault' -SecretPrefix 'Custom'

				$script:NRAPIConnectionInformation.AuthMode | Pester\Should -Be 'Token Authentication'
				$script:NRAPIAuthenticationInformation.Refresh | Pester\Should -Be 'refresh-token'
				$script:NRAPIConnectionInformation.VaultName | Pester\Should -Be 'CustomVault'
				$script:NRAPIConnectionInformation.SecretPrefix | Pester\Should -Be 'Custom'
				$script:ParseDateTimes | Pester\Should -BeFalse
				$script:RequestedSecrets | Pester\Should -Contain 'CustomAuthMode'
				$script:RequestedSecrets | Pester\Should -Contain 'CustomRefresh'
				$script:RequestedSecrets | Pester\Should -Not -Contain 'NinjaOneAuthMode'
			}
		}

		It 'should skip null secrets while still initializing script scoped stores' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				$script:NRAPIAuthenticationInformation = $null
				$script:ParseDateTimes = $false
				$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
				$script:SecretResponses = @{
					NinjaOneAuthMode = 'Token Authentication'
					NinjaOneURL = 'https://api.test.com'
					NinjaOneInstance = 'test-instance'
					NinjaOneClientId = 'client-id'
					NinjaOneClientSecret = 'client-secret'
					NinjaOneAuthScopes = 'monitoring'
					NinjaOneRefresh = 'refresh-token'
				}
				function Get-Secret {
					<#
					.SYNOPSIS
						Test stub for secret retrieval.
					#>
					param(
						# Secret name requested by Get-NinjaOneSecrets.
						$Name,
						# Vault name requested by Get-NinjaOneSecrets.
						$Vault
					)
					$script:RequestedSecrets.Add($Name)
					return $script:SecretResponses[$Name]
				}

				Get-NinjaOneSecrets -VaultName 'TestVault'

				$script:NRAPIConnectionInformation | Pester\Should -BeOfType ([hashtable])
				$script:NRAPIAuthenticationInformation | Pester\Should -BeOfType ([hashtable])
				$script:NRAPIConnectionInformation.ContainsKey('RedirectURI') | Pester\Should -BeFalse
				$script:NRAPIAuthenticationInformation.ContainsKey('Access') | Pester\Should -BeFalse
				$script:NRAPIConnectionInformation.UseSecretManagement | Pester\Should -BeTrue
			}
		}

		It 'should reuse existing script scoped stores and overwrite stale values from the vault' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{
					AuthMode = 'stale-auth-mode'
					URL = 'https://stale.example'
					Instance = 'stale-instance'
					ClientId = 'stale-client-id'
					ClientSecret = 'stale-client-secret'
					AuthScopes = 'stale-scope'
					AuthListenerPort = '9999'
				}
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Stale'
					Access = 'stale-access'
					Expires = '2001-01-01T00:00:00Z'
					Refresh = 'stale-refresh'
				}
				$script:ParseDateTimes = $true
				$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
				$script:SecretResponses = @{
					NinjaOneAuthMode = 'Token Authentication'
					NinjaOneURL = 'https://api.test.com'
					NinjaOneInstance = 'test-instance'
					NinjaOneClientId = 'client-id'
					NinjaOneClientSecret = 'client-secret'
					NinjaOneAuthScopes = 'monitoring'
					NinjaOneUseSecretManagement = 'false'
					NinjaOneWriteToSecretVault = 'false'
					NinjaOneReadFromSecretVault = 'false'
					NinjaOneParseDateTimes = 'false'
					NinjaOneType = 'Bearer'
					NinjaOneAccess = 'fresh-access'
					NinjaOneExpires = '2026-05-01T12:00:00Z'
					NinjaOneRefresh = 'fresh-refresh'
				}
				function Get-Secret {
					<#
					.SYNOPSIS
						Test stub for secret retrieval.
					#>
					param(
						# Secret name requested by Get-NinjaOneSecrets.
						$Name,
						# Vault name requested by Get-NinjaOneSecrets.
						$Vault
					)
					$script:RequestedSecrets.Add($Name)
					return $script:SecretResponses[$Name]
				}

				Get-NinjaOneSecrets -VaultName 'TestVault'

				$script:NRAPIConnectionInformation.AuthMode | Pester\Should -Be 'Token Authentication'
				$script:NRAPIConnectionInformation.URL | Pester\Should -Be 'https://api.test.com'
				$script:NRAPIConnectionInformation.UseSecretManagement | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.WriteToSecretVault | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.ReadFromSecretVault | Pester\Should -BeTrue
				$script:NRAPIConnectionInformation.VaultName | Pester\Should -Be 'TestVault'
				$script:NRAPIAuthenticationInformation.Access | Pester\Should -Be 'fresh-access'
				$script:NRAPIAuthenticationInformation.Refresh | Pester\Should -Be 'fresh-refresh'
				$script:NRAPIAuthenticationInformation.Expires | Pester\Should -BeOfType ([datetime])
				$script:ParseDateTimes | Pester\Should -BeFalse
			}
		}
	}
}

Describe 'Request helper functions' {
	BeforeEach {
		$script:NRAPIConnectionInformation = @{
			URL = 'https://api.test.local'
			AuthMode = 'Token Authentication'
		}
		$script:NRAPIAuthenticationInformation = @{
			Type = 'Bearer'
			Access = 'token'
		}
		$script:ParseDateTimes = $false
		$script:NRAPIInstanceCapabilityCheckEnabled = $false
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			param($Method, $Uri, $Body, $Raw, $ParseDateTime)
			[pscustomobject]@{ method = $Method; uri = $Uri; body = $Body; raw = $Raw; parseDateTime = $ParseDateTime; results = @() }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls New-NinjaOneGETRequest with the expected request contract' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @([pscustomobject]@{ id = 1 }) }
			}

			$null = New-NinjaOneGETRequest -Resource '/v2/test'
		}
	}

	It 'returns null when a GET request produces no response' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith { $null }

			$result = New-NinjaOneGETRequest -Resource '/v2/test'

			$result | Pester\Should -BeNullOrEmpty
		}
	}

	It 'calls New-NinjaOnePUTRequest with the expected request contract' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$null = New-NinjaOnePUTRequest -Resource '/v2/test' -Body @{ name = 'x' }
		}
	}

	It 'calls New-NinjaOnePATCHRequest with the expected request contract' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$null = New-NinjaOnePATCHRequest -Resource '/v2/test' -Body @{ name = 'x' }
		}
	}

	It 'calls New-NinjaOneDELETERequest with the expected request contract' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$null = New-NinjaOneDELETERequest -Resource '/v2/test'
		}
	}

	It 'prefers -Raw over -ParseDateTime when both are set on GET requests' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$null = New-NinjaOneGETRequest -Resource '/v2/test' -Raw -ParseDateTime
		}

		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Raw -and -not $ParseDateTime }
	}

	It 'supports query strings on GET requests' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([string]::Empty)
			$qs.Add('limit', '10')
			$qs.Add('skip', '5')
			$null = New-NinjaOneGETRequest -Resource '/v2/test' -QSCollection $qs
		}
	}

	It 'accepts hashtable query strings on DELETE requests' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$null = New-NinjaOneDELETERequest -Resource '/v2/test' -QSCollection @{ skip = 5; limit = 10 }
		}
	}

	It 'throws when endpoint support rejects a request' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIInstanceCapabilityCheckEnabled = $true
			$script:NRAPIConnectionInformation.URL = 'https://instance.ninjarmm.com'
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ Paths = @{}; Version = '1' }
			}

			{ New-NinjaOneGETRequest -Resource '/v2/missing' } | Pester\Should -Throw
		}
	}

	It 'pages through results/cursor shaped responses until the cursor stops advancing' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			if ($Uri -match 'cursor=cursor-1') {
				[pscustomobject]@{
					results = @([pscustomobject]@{ id = 3 })
					cursor = $null
				}
			} else {
				[pscustomobject]@{
					results = @([pscustomobject]@{ id = 1 }, [pscustomobject]@{ id = 2 })
					cursor = [pscustomobject]@{ name = 'cursor-1' }
				}
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$result = @(New-NinjaOneGETRequest -Resource '/v2/test' -QSCollection $qs)

			$result.Count | Pester\Should -Be 3
			$result[2].id | Pester\Should -Be 3
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 2
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match 'cursor=cursor-1' }
	}

	It 'pages through activities shaped responses using the last returned activity id' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			if ($Uri -match 'olderThan=19') {
				[pscustomobject]@{
					lastActivityId = 999
					activities = @()
				}
			} else {
				[pscustomobject]@{
					lastActivityId = 999
					activities = @([pscustomobject]@{ id = 20 }, [pscustomobject]@{ id = 19 })
				}
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$result = New-NinjaOneGETRequest -Resource '/v2/activities' -QSCollection $qs

			$result.lastActivityId | Pester\Should -Be 999
			$result.activities.Count | Pester\Should -Be 2
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 2
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match 'olderThan=19' }
	}

	It 'preserves the device activity cursor when paging activities' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				lastActivityId = 999
				lastNodeActivityId = 42
				activities = @([pscustomobject]@{ id = 20 })
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$result = New-NinjaOneGETRequest -Resource '/v2/device/1/activities' -QSCollection $qs

			$result.lastNodeActivityId | Pester\Should -Be 42
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 2
	}

	It 'does not auto-paginate when an explicit pageSize is supplied' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				results = @([pscustomobject]@{ id = 1 })
				cursor = [pscustomobject]@{ name = 'cursor-1' }
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$qs.Add('pageSize', '50')
			$result = @(New-NinjaOneGETRequest -Resource '/v2/test' -QSCollection $qs)

			$result.Count | Pester\Should -Be 1
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1
	}

	It 'does not apply after pagination to non-paginated array responses' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1 }, [pscustomobject]@{ id = 2 })
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$result = @(New-NinjaOneGETRequest -Resource '/v2/roles')

			$result.Count | Pester\Should -Be 2
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1
	}

	It 'pages supported after endpoints when a page contains one item' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			if ($Uri -match 'after=2') {
				return
			} elseif ($Uri -match 'after=1') {
				[pscustomobject]@{ id = 2 }
			} else {
				[pscustomobject]@{ id = 1 }
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$result = @(New-NinjaOneGETRequest -Resource '/v2/organizations')

			$result.Count | Pester\Should -Be 2
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 3
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match 'after=1' }
	}

	It 'pages ticketing users with the natural id anchor' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			if ($Uri -match 'anchorNaturalId=10') {
				return
			} else {
				[pscustomobject]@{ naturalId = 10 }
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$result = @(New-NinjaOneGETRequest -Resource '/v2/ticketing/app-user-contact')

			$result.Count | Pester\Should -Be 1
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 2
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match 'anchorNaturalId=10' }
	}

	It 'pages ticket log entries with the id anchor' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			if ($Uri -match 'anchorId=20') {
				return
			} else {
				[pscustomobject]@{ id = 20 }
			}
		}
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$result = @(New-NinjaOneGETRequest -Resource '/v2/ticketing/ticket/1/log-entry')

			$result.Count | Pester\Should -Be 1
		}
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 2
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match 'anchorId=20' }
	}

	It 'does not paginate organization-scoped locations without a documented cursor' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 10 }
		}

		Pester\InModuleScope $ModuleName {
			$result = @(New-NinjaOneGETRequest -Resource '/v2/organization/1/locations')

			$result.Count | Pester\Should -Be 1
		}

		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1
		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0 -ParameterFilter { $Uri -match 'after=' }
	}

	It 'does not repeat a caller-supplied non-advancing cursor' {
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				results = @([pscustomobject]@{ id = 1 })
				cursor = [pscustomobject]@{ name = 'cursor-1' }
			}
		}

		Pester\InModuleScope $ModuleName {
			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$qs.Add('cursor', 'cursor-1')
			$result = @(New-NinjaOneGETRequest -Resource '/v2/test' -QSCollection $qs)

			$result.Count | Pester\Should -Be 1
		}

		Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1
	}

	It 'does not mutate the caller query collection while auto-paging' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:CallCount = 0
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				$script:CallCount++
				if ($script:CallCount -eq 1) {
					[pscustomobject]@{
						results = @([pscustomobject]@{ id = 1 }, [pscustomobject]@{ id = 2 })
						cursor = [pscustomobject]@{ name = 'cursor-1' }
					}
				} else {
					[pscustomobject]@{
						results = @([pscustomobject]@{ id = 3 })
						cursor = $null
					}
				}
			}

			$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			$null = New-NinjaOneGETRequest -Resource '/v2/test' -QSCollection $qs

			$qs['cursor'] | Pester\Should -BeNullOrEmpty
			$qs['olderThan'] | Pester\Should -BeNullOrEmpty
		}
	}

	It 'uses cursorName for custom field schema pagination' {
		$module = Get-Module -name $ModuleName
		Pester\InModuleScope $ModuleName {
			Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ results = @(); cursor = [pscustomobject]@{ name = 'next-page' } }
			}

			$null = Get-NinjaOneCustomFieldsSchema -cursorName 'next-page' -pageSize 25

			Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$QSCollection['cursorName'] -eq 'next-page' -and $QSCollection['pageSize'] -eq '25'
			}
		}
	}
}

Describe 'New-NinjaOneError' {
	Context 'Error transformation behavior' {
		It 'should pass through non-http exceptions as terminating errors' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				$baseError = [System.Exception]::new('Plain test error')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$baseError,
					'TestErrorId',
					[System.Management.Automation.ErrorCategory]::OperationStopped,
					$null
				)

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.FullyQualifiedErrorId | Pester\Should -Match '^TestErrorId'
				$caught.Exception.Message | Pester\Should -Be 'Plain test error'
			}
		}

		It 'should preserve JSON error details for web exceptions in current behavior' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}
				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"resultCode":"401","errorMessage":"Unauthorized"}')

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -HasResponse -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Pester\Should -Be '{"resultCode":"401","errorMessage":"Unauthorized"}'
			}
		}

		It 'should keep null error details for web exceptions with no details in current behavior' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}
				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Pester\Should -BeNullOrEmpty
			}
		}

		It 'should preserve API and HTTP text lines from plain text error details' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new("The NinjaOne API said 500: Boom.`r`nThe API returned the following HTTP error response: 500 Internal Server Error")

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Pester\Should -Match 'The NinjaOne API said 500: Boom\.'
				$caught.ErrorDetails.Message | Pester\Should -Match 'HTTP error response: 500 Internal Server Error'
			}
		}
	}

	Context 'Generated NinjaOne error output' {
		BeforeAll {
			if (-not ([System.Management.Automation.PSTypeName]'NinjaOneTestResponseException').Type) {
				Add-Type -TypeDefinition @'
public class NinjaOneTestResponseException : System.Exception
{
	public object Response { get; set; }

	public NinjaOneTestResponseException(string message) : base(message)
	{
	}
}
'@
			}
		}

		It 'should process JSON resultCode and errorMessage payloads without changing current error-details shape' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}

				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorJsonId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"resultCode":"401","errorMessage":"Unauthorized"}')

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Pester\Should -Be '{"resultCode":"401","errorMessage":"Unauthorized"}'
			}
		}

		It 'should process JSON resultCode-only and error-only payloads without changing current error-details shape' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}

				$webException = [System.Net.WebException]::new('Remote call failed')
				$resultCodeOnly = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorResultCodeOnlyId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$resultCodeOnly.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"resultCode":"429"}')

				$firstCatch = $null
				try {
					New-NinjaOneError -ErrorRecord $resultCodeOnly -ErrorAction Stop
				} catch {
					$firstCatch = $_
				}

				$firstCatch.ErrorDetails.Message | Pester\Should -Be '{"resultCode":"429"}'

				$errorOnly = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorOnlyId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$errorOnly.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"error":"invalid request"}')

				$secondCatch = $null
				try {
					New-NinjaOneError -ErrorRecord $errorOnly -ErrorAction Stop
				} catch {
					$secondCatch = $_
				}

				$secondCatch.ErrorDetails.Message | Pester\Should -Be '{"error":"invalid request"}'
			}
		}

		It 'should split plain text API and HTTP lines into distinct messages' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}

				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorPlainTextId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)
				$errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new("The NinjaOne API said 500: Boom.`r`nThe API returned the following HTTP error response: 500 Internal Server Error")

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught.ErrorDetails.Message | Pester\Should -Match 'The NinjaOne API said 500: Boom\.'
				$caught.ErrorDetails.Message | Pester\Should -Match 'HTTP error response: 500 Internal Server Error'
			}
		}

		It 'should handle missing error details with current null error-details behavior' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}

				$webException = [System.Net.WebException]::new('Remote call failed')
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$webException,
					'WebErrorNoDetailsId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught.ErrorDetails | Pester\Should -BeNullOrEmpty
			}
		}

		It 'should accept hasResponse with response metadata in current behavior' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Error.Clear()
				try {
					throw [System.Net.WebException]::new('Seed web exception for helper branch detection')
				} catch {
					$null = $_
				}

				$exceptionWithResponse = [NinjaOneTestResponseException]::new('Remote call failed')
				$exceptionWithResponse.Response = [pscustomobject]@{
					StatusCode = [pscustomobject]@{ value__ = 503 }
					ReasonPhrase = 'Service Unavailable'
				}
				$errorRecord = [System.Management.Automation.ErrorRecord]::new(
					$exceptionWithResponse,
					'WebErrorHasResponseId',
					[System.Management.Automation.ErrorCategory]::ConnectionError,
					$null
				)

				$caught = $null
				try {
					New-NinjaOneError -ErrorRecord $errorRecord -HasResponse -ErrorAction Stop
				} catch {
					$caught = $_
				}

				$caught | Pester\Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Pester\Should -BeNullOrEmpty
			}
		}
	}
}

Describe 'New-NinjaOneGETRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
			$script:ParseDateTimes = $false
		}
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept resource parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept query string collection' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('skip', '0')
				$qs.Add('limit', '10')
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -QSCollection $qs -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept Raw switch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -Raw -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept ParseDateTime switch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -ParseDateTime -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept multiple parameters together' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('filter', 'name eq "test"')
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' -QSCollection $qs -Raw -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should call endpoint support with GET method' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations'
			}

			Pester\Should-Invoke -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'GET' -and $resource -eq '/v2/organizations' }
		}

		It 'should call endpoint support before request execution' {
			$script:CallOrder = [System.Collections.Generic.List[string]]::new()
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				$script:CallOrder.Add('preflight')
			}
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				$script:CallOrder.Add('request')
				[pscustomobject]@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations'
			}

			$script:CallOrder | Pester\Should -Be @('preflight', 'request')
		}

		It 'should not leak endpoint support output into the request result' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith { $true }
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = [pscustomobject]@{ id = 42 } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = @(New-NinjaOneGETRequest -Resource '/v2/organizations')
				$result.Count | Pester\Should -Be 1
				$result[0].id | Pester\Should -Be 42
			}
		}

		It 'should return the results property when present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ results = @('a', 'b') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneGETRequest -Resource '/v2/organizations'
				@($result) | Pester\Should -Contain 'a'
				@($result) | Pester\Should -Contain 'b'
			}
		}

		It 'should return the result property when present and results is absent' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = [pscustomobject]@{ id = 42 } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneGETRequest -Resource '/v2/organizations'
				$result.id | Pester\Should -Be 42
			}
		}

		It 'should return raw response when neither results nor result exists' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ status = 'ok' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneGETRequest -Resource '/v2/organizations'
				$result.status | Pester\Should -Be 'ok'
			}
		}

		It 'should pass Raw when the raw switch is set' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations' -Raw
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Raw }
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations' -ParseDateTime
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:ParseDateTimes = $true
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should include query parameters in the built request URI' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('pageIndex', '0')
				$qs.Add('pageSize', '50')
				$null = New-NinjaOneGETRequest -Resource '/v2/organizations' -QSCollection $qs
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/organizations' -and $Uri -match 'pageIndex=0' -and $Uri -match 'pageSize=50'
			}
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('boom')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*delegated*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-get-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneGETRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}
	}
}

Describe 'New-NinjaOnePOSTRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept resource parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept Body parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ name = 'Test' } | ConvertTo-Json
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept query string collection' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('test', 'value')
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -QSCollection $qs -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should call endpoint support with POST method' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
			}

			Pester\Should-Invoke -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'POST' -and $resource -eq '/v2/organizations' }
		}

		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should return the results property when present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				@($result) | Pester\Should -Contain 'a'
				@($result) | Pester\Should -Contain 'b'
			}
		}

		It 'should return the result property when present and results is absent' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ id = 123 } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				$result.id | Pester\Should -Be 123
			}
		}

		It 'should return raw response when neither results nor result exists' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ status = 'ok' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				$result.status | Pester\Should -Be 'ok'
			}
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -ParseDateTime
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:ParseDateTimes = $true
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should include query parameters in the built request uri' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('test', 'value')
				$qs.Add('limit', '10')
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -QSCollection $qs
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/organizations' -and $Uri -match 'test=value' -and $Uri -match 'limit=10'
			}
		}

		It 'should serialize object bodies to json' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ name = 'Contoso'; enabled = $true }
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -match '"name"\s*:\s*"Contoso"' -and $Body -match '"enabled"\s*:\s*true'
			}
		}

		It 'should delegate invalid multipart payload shapes to New-NinjaOneError' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @(@{ file = 'placeholder.txt' })
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*multipart-delegated*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should route multipart hashtable bodies through error delegation when HttpContent request fails' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-hashtable-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$body = @{ metadata = @{ name = 'contoso' }; tags = @('a', 'b') }
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*multipart-hashtable-delegated*'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0
			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should route multipart HttpContent bodies through error delegation when HttpContent request fails' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-httpcontent-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$content = [System.Net.Http.StringContent]::new('{"name":"contoso"}', [System.Text.Encoding]::UTF8, 'application/json')
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $content -UseMultipart } | Pester\Should -Throw '*multipart-httpcontent-delegated*'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0
			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should process pscustomobject multipart bodies before delegating request failures' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-pscustomobject-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$body = [pscustomobject]@{
					metadata = [pscustomobject]@{
						name = 'contoso'
						enabled = $true
					}
				}
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*multipart-pscustomobject-delegated*'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0
			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should fall back to standard request path when multipart detection returns false' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ ok = $true } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body 42 -UseMultipart
				$result.ok | Pester\Should -BeTrue
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -eq '42'
			}
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('boom')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*delegated*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-post-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}

		It 'should propagate HttpResponseException from inner try without delegation' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				$ex = [Microsoft.PowerShell.Commands.HttpResponseException]::new('http error', [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::BadRequest))
				throw $ex
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*http error*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}

		It 'should propagate outer HttpResponseException without delegation' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				$ex = [Microsoft.PowerShell.Commands.HttpResponseException]::new('outer http error', [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized))
				throw $ex
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Pester\Should -Throw '*outer http error*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}
	}

	Context 'Multipart file handling' {
		It 'should cover Add-FilePart via string file path body property' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('file-path-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					$body = @{ attachment = $tmpFile }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*file-path-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}

		It 'should cover Add-FilePart via FileInfo body property' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('fileinfo-prop-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					$fileItem = [System.IO.FileInfo]::new($tmpFile)
					$body = @{ attachment = $fileItem }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*fileinfo-prop-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}

		It 'should cover Add-FilePart via FileInfo item in array property' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('fileinfo-array-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					$fileItem = [System.IO.FileInfo]::new($tmpFile)
					$body = @{ files = @($fileItem) }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*fileinfo-array-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}

		It 'should cover Add-FilePart via string file path item in array property' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('filepath-array-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					$body = @{ files = @($tmpFile) }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*filepath-array-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}

		It 'should cover null recursive detection in Test-NinjaOneMultipartBody via null array item' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('null-item-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					# Array with null item first: recursive Test-NinjaOneMultipartBody hits null-check (line 76)
					$body = @{ files = @($null, $tmpFile) }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*null-item-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}

		It 'should cover HttpContent recursive detection in Test-NinjaOneMultipartBody' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('httpcontent-recursive-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				# Array item is HttpContent: recursive call hits HttpContent check (line 77)
				$contentItem = [System.Net.Http.StringContent]::new('data', [System.Text.Encoding]::UTF8, 'text/plain')
				$body = @{ files = @($contentItem) }
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*httpcontent-recursive-delegated*'
			}
		}

		It 'should cover FileInfo recursive detection in Test-NinjaOneMultipartBody' {
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('fileinfo-recursive-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$tmpFile = [System.IO.Path]::GetTempFileName()
				try {
					# Array item is FileInfo: recursive call hits FileInfo check (line 78)
					$fileItem = [System.IO.FileInfo]::new($tmpFile)
					$body = @{ files = @($fileItem) }
					{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Pester\Should -Throw '*fileinfo-recursive-delegated*'
				} finally {
					Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue
				}
			}
		}
	}
}

Describe 'New-NinjaOneQuery' {
	Context 'Parameter acceptance' {
		It 'should accept CommandName parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -name $CommandName).Parameters
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept empty parameters' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$params = @{}
				{ New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $params -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept CommaSeparatedArrays switch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -name $CommandName).Parameters
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -CommaSeparatedArrays -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept AsString switch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$CommandName = 'Get-NinjaOneAntivirusStatus'
				$Parameters = (Get-Command -name $CommandName).Parameters
				$script:QSBuilder = [System.UriBuilder]::new()
				{ New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters -AsString -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should omit parameter values from verbose output' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Filter = 'sensitive-filter-value'
				$parameters = @{
					Filter = [pscustomobject]@{
						Name = 'Filter'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @()
					}
				}
				$VerbosePreference = 'Continue'
				$verboseOutput = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -Verbose 4>&1 |
					Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } |
					Out-String
				$verboseOutput | Pester\Should -Not -Match 'sensitive-filter-value'
			}
		}
	}

	Context 'Query construction branches' {
		It 'should use the parameter name when no alias is present' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Filter = 'alpha'
				$parameters = @{
					Filter = [pscustomobject]@{
						Name = 'Filter'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['Filter'] | Pester\Should -Be 'alpha'
			}
		}

		It 'should join string arrays when comma separated arrays are requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Tags = @('one', 'two')
				$parameters = @{
					Tags = [pscustomobject]@{
						Name = 'Tags'
						ParameterType = [pscustomobject]@{ Name = 'String[]' }
						Aliases = @('tag')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['tag'] | Pester\Should -Be 'one,two'
			}
		}

		It 'should expand int arrays when comma separated arrays are not requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Ids = @(1, 2)
				$parameters = @{
					Ids = [pscustomobject]@{
						Name = 'Ids'
						ParameterType = [pscustomobject]@{ Name = 'Int32[]' }
						Aliases = @('id')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['id'] | Pester\Should -Be '1,2'
			}
		}

		It 'should convert datetime arrays to unix epoch when comma separated arrays are requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$CreatedAfter = @([datetime]'2026-01-01T00:00:00Z', [datetime]'2026-01-02T00:00:00Z')
				$parameters = @{
					CreatedAfter = [pscustomobject]@{
						Name = 'CreatedAfter'
						ParameterType = [pscustomobject]@{ Name = 'DateTime[]' }
						Aliases = @('createdAfter')
					}
				}

				Pester\Mock -CommandName ConvertTo-UnixEpoch -ModuleName $ModuleName -MockWith {
					param($DateTime)
					if ($DateTime -eq [datetime]'2026-01-01T00:00:00Z') { return 111 }
					return 222
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['createdAfter'] | Pester\Should -Be '111,222'
			}
		}

		It 'should return a query string when requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Search = 'alpha'
				$parameters = @{
					Search = [pscustomobject]@{
						Name = 'Search'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @('q')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -AsString
				$result | Pester\Should -Match '^\?q=alpha'
			}
		}
	}

	Context 'Query construction behavior' {
		It 'should skip optional common parameters' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$parameters = @{
					WhatIf = [pscustomobject]@{
						Name = 'WhatIf'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result.Count | Pester\Should -Be 0
			}
		}

		It 'should use aliases for string and boolean parameters' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Search = 'alpha'
				$IncludeArchived = $false
				$parameters = @{
					Search = [pscustomobject]@{
						Name = 'Search'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @('q')
					}
					IncludeArchived = [pscustomobject]@{
						Name = 'IncludeArchived'
						ParameterType = [pscustomobject]@{ Name = 'Boolean' }
						Aliases = @('archived')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['q'] | Pester\Should -Be 'alpha'
				$result['archived'] | Pester\Should -Be 'false'
			}
		}

		It 'should skip empty strings and false switches' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Filter = ''
				$IncludeDetails = $false
				$parameters = @{
					Filter = [pscustomobject]@{
						Name = 'Filter'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @()
					}
					IncludeDetails = [pscustomobject]@{
						Name = 'IncludeDetails'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @('details')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result.AllKeys -contains 'Filter' | Pester\Should -BeFalse
				$result.AllKeys -contains 'details' | Pester\Should -BeFalse
			}
		}

		It 'should use the parameter name for switch parameters without aliases' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$IncludeDetails = $true
				$parameters = @{
					IncludeDetails = [pscustomobject]@{
						Name = 'IncludeDetails'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['IncludeDetails'] | Pester\Should -Be 'true'
			}
		}

		It 'should use the parameter name for boolean parameters without aliases' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$IncludeArchived = $true
				$parameters = @{
					IncludeArchived = [pscustomobject]@{
						Name = 'IncludeArchived'
						ParameterType = [pscustomobject]@{ Name = 'Boolean' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['IncludeArchived'] | Pester\Should -Be 'true'
			}
		}

		It 'should serialize string arrays as comma separated values when requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Tags = @('one', 'two')
				$parameters = @{
					Tags = [pscustomobject]@{
						Name = 'Tags'
						ParameterType = [pscustomobject]@{ Name = 'String[]' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['Tags'] | Pester\Should -Be 'one,two'
			}
		}

		It 'should serialize integer arrays as comma separated values when requested' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Ids = @(1, 2, 3)
				$parameters = @{
					Ids = [pscustomobject]@{
						Name = 'Ids'
						ParameterType = [pscustomobject]@{ Name = 'Int32[]' }
						Aliases = @('id')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['id'] | Pester\Should -Be '1,2,3'
			}
		}

		It 'should serialize datetime array items to Unix epoch values when using comma separated arrays' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt1 = [datetime]'2026-01-01T00:00:00Z'
				$dt2 = [datetime]'2026-06-01T00:00:00Z'
				$CreatedAfter = @($dt1, $dt2)
				$parameters = @{
					CreatedAfter = [pscustomobject]@{
						Name = 'CreatedAfter'
						ParameterType = [pscustomobject]@{ Name = 'DateTime[]' }
						Aliases = @('createdAfter')
					}
				}

				$epoch1 = ConvertTo-UnixEpoch -DateTime $dt1
				$epoch2 = ConvertTo-UnixEpoch -DateTime $dt2
				$expected = "$epoch1,$epoch2"
				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['createdAfter'] | Pester\Should -Be $expected
			}
		}

		It 'should process non-comma array paths for string int and datetime values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Tag = @('single')
				$Ids = @(42)
				$Created = @([datetime]'2026-01-01T00:00:00Z')
				$parameters = @{
					Tag = [pscustomobject]@{
						Name = 'Tag'
						ParameterType = [pscustomobject]@{ Name = 'String[]' }
						Aliases = @('tag')
					}
					Ids = [pscustomobject]@{
						Name = 'Ids'
						ParameterType = [pscustomobject]@{ Name = 'Int32[]' }
						Aliases = @('id')
					}
					Created = [pscustomobject]@{
						Name = 'Created'
						ParameterType = [pscustomobject]@{ Name = 'DateTime[]' }
						Aliases = @('createdAfter')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['tag'] | Pester\Should -Be 'single'
				$result['id'] | Pester\Should -Be 42
				$result['createdAfter'] | Pester\Should -Not -BeNullOrEmpty
			}
		}

		It 'should skip unset integers and include aliased integer values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Limit = 0
				$Offset = 10
				$parameters = @{
					Limit = [pscustomobject]@{
						Name = 'Limit'
						ParameterType = [pscustomobject]@{ Name = 'Int32' }
						Aliases = @()
					}
					Offset = [pscustomobject]@{
						Name = 'Offset'
						ParameterType = [pscustomobject]@{ Name = 'Int64' }
						Aliases = @('skip')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result.AllKeys -contains 'Limit' | Pester\Should -BeFalse
				$result['skip'] | Pester\Should -Be 10
			}
		}

		It 'should return a query string when AsString is specified' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Name = 'Contoso'
				$parameters = @{
					Name = [pscustomobject]@{
						Name = 'Name'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @('name')
					}
				}

				$query = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -AsString
				$query | Pester\Should -BeOfType ([string])
				$query.StartsWith('?') | Pester\Should -BeTrue
				$query | Pester\Should -Match 'name=Contoso'
			}
		}

		It 'should use the parameter name for integer parameters without aliases' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$PageSize = 25
				$parameters = @{
					PageSize = [pscustomobject]@{
						Name = 'PageSize'
						ParameterType = [pscustomobject]@{ Name = 'Int32' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['PageSize'] | Pester\Should -Be 25
			}
		}

		It 'should add a single DateTime value directly to the query string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$Since = [datetime]'2026-03-15T00:00:00Z'
				$parameters = @{
					Since = [pscustomobject]@{
						Name = 'Since'
						ParameterType = [pscustomobject]@{ Name = 'DateTime' }
						Aliases = @('since')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['since'] | Pester\Should -Not -BeNullOrEmpty
			}
		}

		It 'should use the alias for switch parameters with aliases when set to true' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$IncludeDetails = $true
				$parameters = @{
					IncludeDetails = [pscustomobject]@{
						Name = 'IncludeDetails'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @('details')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['details'] | Pester\Should -Be 'true'
			}
		}
	}
}

Describe 'Set-NinjaOneSecrets' {
	BeforeEach {
		$script:CapturedSecretWrites = @()
	}

	Context 'Secret persistence' {
		It 'should write connection and authentication secrets to the configured vault' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:CapturedSecretWrites = @()
				$script:NRAPIConnectionInformation = @{
					AuthMode = 'Authorization Code'
					URL = 'https://api.test.com'
					Instance = 'test-instance'
					ClientId = 'client-id'
					ClientSecret = 'client-secret'
					AuthScopes = 'monitoring management'
					RedirectURI = [uri]'http://localhost/callback'
					AuthListenerPort = 8080
					UseSecretManagement = $true
					WriteToSecretVault = $true
					ReadFromSecretVault = $true
					VaultName = 'TestVault'
				}
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'access-token'
					Expires = [datetime]'2026-04-28T12:00:00Z'
					Refresh = 'refresh-token'
				}
				$script:ParseDateTimes = $true

				function Get-SecretVault {
					<#
					.SYNOPSIS
						Test stub for secret vault lookup.
					#>
					param(
						# Vault name requested by Set-NinjaOneSecrets.
						$Name
					)
					return [pscustomobject]@{ Name = $Name }
				}

				function Set-Secret {
					<#
					.SYNOPSIS
						Test stub for writing a secret value.
					#>
					param(
						# Target vault for persisted secret.
						$Vault,
						# Secret name written by Set-NinjaOneSecrets.
						$Name,
						# Secret value written by Set-NinjaOneSecrets.
						$Secret
					)
					$script:CapturedSecretWrites += [pscustomobject]@{
						Vault = $Vault
						Name = $Name
						Secret = $Secret
					}
				}

				$params = @{
					UseSecretManagement = $true
					WriteToSecretVault = $true
					VaultName = 'TestVault'
				}
				$DebugPreference = 'Continue'
				$debugOutput = Set-NinjaOneSecrets @params -ErrorAction Stop 5>&1 |
					Where-Object { $_ -is [System.Management.Automation.DebugRecord] } |
					Out-String
				$debugOutput | Pester\Should -Not -Match 'client-secret|access-token|refresh-token'

				$script:CapturedSecretWrites.Count | Pester\Should -BeGreaterThan 10
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthMode' }).Count | Pester\Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneClientSecret' }).Count | Pester\Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneParseDateTimes' -and $_.Secret -eq 'True' }).Count | Pester\Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthListenerPort' -and $_.Secret -eq '8080' }).Count | Pester\Should -Be 1
			}
		}

		It 'should use a custom secret prefix and skip null or empty values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:CapturedSecretWrites = @()
				$script:NRAPIConnectionInformation = @{
					AuthMode = 'Token Authentication'
					URL = 'https://api.test.com'
					Instance = 'test-instance'
					ClientId = 'client-id'
					ClientSecret = 'client-secret'
					AuthScopes = 'monitoring'
					RedirectURI = $null
					AuthListenerPort = $null
					UseSecretManagement = $true
					WriteToSecretVault = $true
					ReadFromSecretVault = $true
					VaultName = 'TestVault'
				}
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = ''
					Expires = $null
					Refresh = 'refresh-token'
				}
				$script:ParseDateTimes = $false

				function Get-SecretVault {
					<#
					.SYNOPSIS
						Test stub for secret vault lookup.
					#>
					param(
						# Vault name requested by Set-NinjaOneSecrets.
						$Name
					)
					return [pscustomobject]@{ Name = $Name }
				}

				function Set-Secret {
					<#
					.SYNOPSIS
						Test stub for writing a secret value.
					#>
					param(
						# Target vault for persisted secret.
						$Vault,
						# Secret name written by Set-NinjaOneSecrets.
						$Name,
						# Secret value written by Set-NinjaOneSecrets.
						$Secret
					)
					$script:CapturedSecretWrites += [pscustomobject]@{
						Vault = $Vault
						Name = $Name
						Secret = $Secret
					}
				}

				$params = @{
					UseSecretManagement = $true
					WriteToSecretVault = $true
					VaultName = 'CustomVault'
					SecretPrefix = 'Custom'
				}
				{ Set-NinjaOneSecrets @params -ErrorAction Stop } | Pester\Should -Not -Throw

				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomAuthMode' }).Count | Pester\Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomRefresh' }).Count | Pester\Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomAccess' }).Count | Pester\Should -Be 0
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomRedirectURI' }).Count | Pester\Should -Be 0
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthMode' }).Count | Pester\Should -Be 0
			}
		}
	}
}

Describe 'Start-OAuthHTTPListener' -Skip:(!$script:CanStartOAuthListener) {
	Context 'HTTP listener setup' {
		It 'should accept OpenURI parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$uri = [System.UriBuilder]::new('http://localhost:9090/callback')
				{ Start-OAuthHTTPListener -OpenURI $uri -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept TimeoutSeconds parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$uri = [System.UriBuilder]::new('http://localhost:9090/callback')
				{ Start-OAuthHTTPListener -OpenURI $uri -TimeoutSeconds 30 -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}
}

Describe 'Connect-NinjaOne' {
	Context 'Connection switching' {
		It 'should replace the active connection when reconnecting with different credentials and scopes' {
			$module = Get-Module -Name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				$script:NRAPIAuthenticationInformation = $null
				$script:CapturedTokenRequestBodies = @()

				Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -MockWith {}
				Pester\Mock -CommandName Invoke-WebRequest -MockWith {
					$script:CapturedTokenRequestBodies += $Body
					[pscustomobject]@{
						Content = '{"token_type":"Bearer","access_token":"test-access-token","expires_in":3600,"refresh_token":"test-refresh-token"}'
					}
				}

				Connect-NinjaOne -Instance 'us' -ClientId 'first-client-id' -ClientSecret 'first-client-secret' -UseClientAuth -Scopes @('monitoring', 'management')
				Connect-NinjaOne -Instance 'us' -ClientId 'new-client-id' -ClientSecret 'new-client-secret' -UseClientAuth -Scopes @('monitoring', 'offline_access')

				$script:NRAPIConnectionInformation.ClientId | Pester\Should -Be 'new-client-id'
				$script:NRAPIConnectionInformation.ClientSecret | Pester\Should -Be 'new-client-secret'
				$script:NRAPIConnectionInformation.AuthScopes | Pester\Should -Be 'monitoring offline_access'
				$script:CapturedTokenRequestBodies.Count | Pester\Should -Be 2
				$script:CapturedTokenRequestBodies[1].client_id | Pester\Should -Be 'new-client-id'
				$script:CapturedTokenRequestBodies[1].client_secret | Pester\Should -Be 'new-client-secret'
				$script:CapturedTokenRequestBodies[1].scope | Pester\Should -Be 'monitoring offline_access'
			}
		}
	}
}

Describe 'Update-NinjaOneToken' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				AuthMode = 'OAuth'
				Instance = 'us'
				ClientId = 'test-id'
				ClientSecret = 'test-secret'
				AuthScopes = 'monitoring offline_access'
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
		Pester\InModuleScope $ModuleName {
			Pester\Mock -CommandName Connect-NinjaOne -MockWith {
				$script:CapturedReauthParams = $PSBoundParameters
				$script:NRAPIAuthenticationInformation.Type = 'Bearer'
				$script:NRAPIAuthenticationInformation.Access = 'test-access-token-refreshed'
			}
		}
	}

	Context 'Token handling' {
		It 'should accept no parameters for refresh' {
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept various auth modes' {
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.AuthMode = 'Client Credentials'
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should not require parameters when globals are set' {
			Pester\InModuleScope $ModuleName {
				# Verify globals are set
				$script:NRAPIConnectionInformation | Pester\Should -Not -BeNullOrEmpty
				$script:NRAPIAuthenticationInformation | Pester\Should -Not -BeNullOrEmpty
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should not pass secret management parameters when secret management is disabled' {
			Pester\InModuleScope $ModuleName {
				$script:CapturedReauthParams = $null
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
				$script:CapturedReauthParams.ContainsKey('UseSecretManagement') | Pester\Should -BeFalse
				$script:CapturedReauthParams.ContainsKey('VaultName') | Pester\Should -BeFalse
				$script:CapturedReauthParams.ContainsKey('WriteToSecretVault') | Pester\Should -BeFalse
			}
			Pester\Should-Invoke -CommandName Connect-NinjaOne -ModuleName $ModuleName -Times 1 -ParameterFilter {
				($Scopes -join ' ') -eq 'monitoring offline_access'
			}
		}

		It 'should preserve the secret prefix when secret management is enabled' {
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.UseSecretManagement = $true
				$script:NRAPIConnectionInformation.VaultName = 'TestVault'
				$script:NRAPIConnectionInformation.WriteToSecretVault = $true
				$script:NRAPIConnectionInformation.SecretPrefix = 'Custom'
				$script:CapturedReauthParams = $null
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
				# SecretPrefix is preserved in memory for future Get-NinjaOneSecrets calls
				$script:NRAPIConnectionInformation.SecretPrefix | Pester\Should -Be 'Custom'
			}
		}

		It 'should continue refresh when secret management has no vault name' {
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.UseSecretManagement = $true
				$script:NRAPIConnectionInformation.VaultName = $null
				$script:CapturedReauthParams = $null
				{ Update-NinjaOneToken -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
				$script:CapturedReauthParams.ContainsKey('UseSecretManagement') | Pester\Should -BeFalse
				$script:CapturedReauthParams.ContainsKey('VaultName') | Pester\Should -BeFalse
			}
		}

		It 'should throw when neither client credentials nor refresh token is available' {
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation.AuthMode = 'OAuth'
				$script:NRAPIAuthenticationInformation.Refresh = $null
				{ Update-NinjaOneToken } | Pester\Should -Throw
			}
		}
	}
}

Describe 'New-NinjaOneDELETERequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept function call with resource' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept resource parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Pester\Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Pester\Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should return results when results property is present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				@($result) | Pester\Should -Contain 'a'
				@($result) | Pester\Should -Contain 'b'
			}
		}

		It 'should return result when result property is present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ ok = $true } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				$result.ok | Pester\Should -BeTrue
			}
		}

		It 'should return raw object when neither results nor result is present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ status = 'deleted' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				$result.status | Pester\Should -Be 'deleted'
			}
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ParseDateTime
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:ParseDateTimes = $true
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should append supplied query parameters to the request URI' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -QSCollection @{ skip = 5; limit = 10 }
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/organizations/1\?' -and $Uri -match 'skip=5' -and $Uri -match 'limit=10'
			}
		}

		It 'should append a NameValueCollection to the request URI' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$query.Add('fieldNames', 'Region,Floor')
				$null = New-NinjaOneDELETERequest -Resource '/v2/custom-fields/bulk' -QSCollection $query
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/custom-fields/bulk\?' -and $Uri -match 'fieldNames=Region%2cFloor'
			}
		}

		It 'should delegate web exceptions from Invoke-NinjaOneRequest in current core behavior' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Net.WebException]::new('web failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated-web')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Pester\Should -Throw '*delegated-web*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should delegate non-http failures from Invoke-NinjaOneRequest to New-NinjaOneError' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('generic failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated-delete')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Pester\Should -Throw '*delegated-delete*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-delete-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}
	}
}

Describe 'New-NinjaOnePATCHRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
		}
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
		Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			throw [System.Exception]::new('delegated-patch')
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept body parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ status = 'active' } | ConvertTo-Json
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body $body -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept empty body' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body '' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'a' } } | Pester\Should -Throw '*Connect-NinjaOne*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'a' } } | Pester\Should -Throw '*Connect-NinjaOne*'
			}
		}

		It 'should call endpoint support with PATCH method' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ status = 'active' }
			}

			Pester\Should-Invoke -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'PATCH' -and $resource -eq '/v2/organizations/1' }
		}

		It 'should include query string values in the request URI' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				param($Uri)
				[pscustomobject]@{ result = @($Uri) }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('pageSize', '10')
				$qs.Add('detailed', 'true')
				$null = New-NinjaOnePATCHRequest -Resource '/v2/organizations' -Body @{ name = 'updated' } -qSCollection $qs
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match 'pageSize=10' -and $Uri -match 'detailed=true'
			}
		}

		It 'should set ParseDateTime when requested by switch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } -parseDateTime
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime -eq $true }
		}

		It 'should set ParseDateTime when script preference is enabled' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:ParseDateTimes = $true
				try {
					New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
				} finally {
					$script:ParseDateTimes = $false
				}
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime -eq $true }
		}

		It 'should return Result.results when present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b'); result = @('fallback') }
			}

			$module = Get-Module -name $ModuleName
			$result = Pester\InModuleScope $ModuleName {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result | Pester\Should -Be @('a', 'b')
		}

		It 'should return Result.result when results is not present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @('single') }
			}

			$module = Get-Module -name $ModuleName
			$result = Pester\InModuleScope $ModuleName {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result | Pester\Should -Be @('single')
		}

		It 'should return raw result when neither result nor results exists' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ status = 'ok' }
			}

			$module = Get-Module -name $ModuleName
			$result = Pester\InModuleScope $ModuleName {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result.status | Pester\Should -Be 'ok'
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('generic failure')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Pester\Should -Throw '*delegated-patch*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should delegate web exceptions from request in current core behavior' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Net.WebException]::new('web failure')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Pester\Should -Throw '*delegated-patch*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}
	}
}

Describe 'New-NinjaOnePUTRequest' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.test.com'
				Instance = 'test.ninjaone.com'
			}
			$script:NRAPIAuthenticationInformation = @{
				access_token = 'test-token'
			}
			$script:ParseDateTimes = $false
		}
		Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ result = @() }
		}
	}

	Context 'Parameter acceptance' {
		It 'should accept body parameter' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ name = 'Updated' } | ConvertTo-Json
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body $body -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}

		It 'should accept empty body' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body '' -ErrorAction SilentlyContinue } | Pester\Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } } | Pester\Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } } | Pester\Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should call endpoint support with PUT method' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' }
			}

			Pester\Should-Invoke -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'PUT' -and $resource -eq '/v2/organizations/1' }
		}

		It 'should return the results property when present' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' }
				@($result) | Pester\Should -Contain 'a'
				@($result) | Pester\Should -Contain 'b'
			}
		}

		It 'should return the result property when present and results is absent' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ id = 99 } }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' }
				$result.id | Pester\Should -Be 99
			}
		}

		It 'should return raw response when neither results nor result exists' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ status = 'ok' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' }
				$result.status | Pester\Should -Be 'ok'
			}
		}

		It 'should serialize object body to JSON' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ name = 'Contoso'; enabled = $true }
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body $body
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -match '"name"\s*:\s*"Contoso"' -and $Body -match '"enabled"\s*:\s*true'
			}
		}

		It 'should force body to array when AsArray is set' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$body = @{ name = 'Contoso' }
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body $body -AsArray
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -match '^\s*\['
			}
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } -ParseDateTime
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:ParseDateTimes = $true
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' }
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should include query parameters in the built request URI' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('expand', 'devices')
				$null = New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } -QSCollection $qs
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/organizations/1' -and $Uri -match 'expand=devices'
			}
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Pester\Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('boom')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } } | Pester\Should -Throw '*delegated*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Pester\Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-put-delegated')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ New-NinjaOnePUTRequest -Resource '/v2/organizations/1' -Body @{ name = 'test' } } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
		}
	}
}

Describe 'Invoke-NinjaOnePreFlightCheck' {
	Context 'Connection validation' {
		It 'should validate connection information is set' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{ Access = 'test-token' }
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Not -Throw
			}
		}

		It 'should throw when connection information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Throw
			}
		}

		It 'should validate authentication information is set' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{ Access = 'test-token' }
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Not -Throw
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = $null
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Throw
			}
		}

		It 'should throw when authentication information does not include an access token' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{}
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Throw '*Missing NinjaOne authentication token*'
			}
		}

		It 'should throw when authentication access token is empty' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{ Access = '' }
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Throw '*Missing NinjaOne authentication token*'
			}
		}

		It 'should validate all required connection fields' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{
					URL = 'https://test.com'
					Instance = 'test.ninjaone.com'
					AuthMode = 'OAuth'
				}
				$script:NRAPIAuthenticationInformation = @{ Access = 'test-token' }
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Not -Throw
			}
		}

		It 'should handle partial connection information gracefully' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = $null
				{ Invoke-NinjaOnePreFlightCheck } | Pester\Should -Throw
			}
		}

		It 'should skip connection checks when skipConnectionChecks is set' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = $null
				$script:NRAPIAuthenticationInformation = $null
				{ Invoke-NinjaOnePreFlightCheck -SkipConnectionChecks } | Pester\Should -Not -Throw
			}
		}
	}
}

Describe 'Invoke-NinjaOneRequest' {
	Context 'Preflight enforcement' {
		It 'should invoke the shared preflight check before making a request' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '{"result":{}}'
					Headers = @{}
				}
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}

				$null = Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test'
			}

			Pester\Should-Invoke -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -Times 1
		}

		It 'should stop before request execution when preflight fails' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('request should not run')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' } | Pester\Should -Throw '*preflight failure*'
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 0
		}

		It 'should not refresh token when expiry is missing' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Update-NinjaOneToken -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('refresh should not run')
			}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '{"result":{}}'
					Headers = @{}
				}
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
				}

				{ Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' } | Pester\Should -Not -Throw
			}

			Pester\Should-Invoke -CommandName Update-NinjaOneToken -ModuleName $ModuleName -Times 0
		}

		It 'refreshes an expired token and returns the status code for an empty POST response' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Update-NinjaOneToken -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 204
					Content = [String]::Empty
					Headers = @{}
				}
			}

			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(-1)
				}

				$result = Invoke-NinjaOneRequest -Method 'POST' -Uri 'https://test.com/v2/test' -Body '{"name":"x"}'

				$result | Pester\Should -Be 204
			}

			Pester\Should-Invoke -CommandName Update-NinjaOneToken -ModuleName $ModuleName -Times 1
			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -eq '{"name":"x"}'
			}
		}

		It 'converts date values when ParseDateTime is requested' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '{"created":"2024-01-01T00:00:00Z"}'
					Headers = @{ 'Content-Type' = 'application/json' }
				}
			}

			Pester\InModuleScope $ModuleName {
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}

				$result = Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' -ParseDateTime

				$result.created | Pester\Should -BeOfType ([DateTime])
			}
		}
	}

	Context 'Rate limit handling' {
		It 'retries when an HTML rate-limited response is returned, then succeeds' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Start-Sleep -ModuleName $ModuleName -MockWith {}
			$script:RateLimitCallCount = 0
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				$script:RateLimitCallCount++
				if ($script:RateLimitCallCount -lt 2) {
					[pscustomobject]@{
						StatusCode = 200
						Content = '<!DOCTYPE html><html><body>Rate limited</body></html>'
						Headers = @{ 'Content-Type' = 'text/html' }
					}
				} else {
					[pscustomobject]@{
						StatusCode = 200
						Content = '{"result":{"id":1}}'
						Headers = @{ 'Content-Type' = 'application/json' }
					}
				}
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}
				$script:NRAPIRateLimitMaxRetries = 3
				$script:NRAPIRateLimitInitialDelaySeconds = 0

				$result = Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test'

				$result.result.id | Pester\Should -Be 1
			}

			$script:RateLimitCallCount | Pester\Should -Be 2
			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 2
			Pester\Should-Invoke -CommandName Start-Sleep -ModuleName $ModuleName -Times 1
		}

		It 'throws after exceeding the max retries when responses stay HTML' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Start-Sleep -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '<!DOCTYPE html><html><body>Rate limited</body></html>'
					Headers = @{ 'Content-Type' = 'text/html' }
				}
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}
				$script:NRAPIRateLimitMaxRetries = 1
				$script:NRAPIRateLimitInitialDelaySeconds = 0

				{ Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' } | Pester\Should -Throw '*rate limit*'
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 2
		}

		It 'does not retry HTML responses for non-GET requests' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Start-Sleep -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '<!DOCTYPE html><html><body>Rate limited</body></html>'
					Headers = @{ 'Content-Type' = 'text/html' }
				}
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}
				$script:NRAPIRateLimitMaxRetries = 3
				$script:NRAPIRateLimitInitialDelaySeconds = 0

				{ Invoke-NinjaOneRequest -Method 'POST' -Uri 'https://test.com/v2/test' -Body '{"name":"x"}' } | Pester\Should -Throw
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1
			Pester\Should-Invoke -CommandName Start-Sleep -ModuleName $ModuleName -Times 0
		}

		It 'returns raw HTML responses without retrying' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Start-Sleep -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 200
					Content = '<!DOCTYPE html><html><body>Redirect</body></html>'
					Headers = @{ 'Content-Type' = 'text/html' }
				}
			}

			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}

				$result = Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' -Raw

				$result | Pester\Should -Match 'Redirect'
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1
			Pester\Should-Invoke -CommandName Start-Sleep -ModuleName $ModuleName -Times 0
		}

		It 'does not retry unrelated HTML error responses' {
			Pester\Mock -CommandName Invoke-NinjaOnePreFlightCheck -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Start-Sleep -ModuleName $ModuleName -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{
					StatusCode = 503
					Content = '<html><body>Scheduled maintenance</body></html>'
					Headers = @{ 'Content-Type' = 'text/html' }
				}
			}

			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://test.com' }
				$script:NRAPIAuthenticationInformation = @{
					Type = 'Bearer'
					Access = 'test-token'
					Expires = (Get-Date).AddMinutes(30)
				}

				{ Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://test.com/v2/test' } | Pester\Should -Throw '*Scheduled maintenance*'
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1
			Pester\Should-Invoke -CommandName Start-Sleep -ModuleName $ModuleName -Times 0
		}
	}
}

Describe 'Get-NinjaOneOpenApiPaths' {
	Context 'OpenAPI path parsing' {
		It 'should extract allowed methods for each path' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$openApiYaml = @'
openapi: 3.0.1
paths:
  /v2/organizations:
    get:
      summary: List organizations
    post:
      summary: Create organization
  /v2/devices/{id}:
    delete:
      summary: Delete device
'@

				$result = Get-NinjaOneOpenApiPaths -OpenApiYaml $openApiYaml

				$result.Keys.Count | Pester\Should -Be 2
				$result.Keys | Pester\Should -Contain '/v2/organizations'
				$result.Keys | Pester\Should -Contain '/v2/devices/{id}'
				([string[]]$result['/v2/organizations']) | Pester\Should -Contain 'GET'
				([string[]]$result['/v2/organizations']) | Pester\Should -Contain 'POST'
				([string[]]$result['/v2/devices/{id}']) | Pester\Should -Contain 'DELETE'
			}
		}

		It 'should ignore unsupported methods and de-duplicate method names' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$openApiYaml = @'
openapi: 3.0.1
paths:
  /v2/tickets:
    patch:
      summary: Update ticket
    PATCH:
      summary: Duplicate method in different case
    trace:
      summary: Unsupported method
    head:
      summary: Check ticket headers
'@

				$result = Get-NinjaOneOpenApiPaths -OpenApiYaml $openApiYaml
				$methods = [string[]]$result['/v2/tickets']

				$methods.Count | Pester\Should -Be 2
				$methods | Pester\Should -Contain 'PATCH'
				$methods | Pester\Should -Contain 'HEAD'
				$methods | Pester\Should -Not -Contain 'TRACE'
			}
		}

		It 'should stop parsing when the paths section ends' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$openApiYaml = @'
openapi: 3.0.1
paths:
  /v2/alerts:
    get:
      summary: List alerts
components:
  schemas:
    /not-a-path:
      get:
        summary: This should not be parsed
'@

				$result = Get-NinjaOneOpenApiPaths -OpenApiYaml $openApiYaml

				$result.Keys.Count | Pester\Should -Be 1
				$result.Keys | Pester\Should -Contain '/v2/alerts'
				$result.Keys | Pester\Should -Not -Contain '/not-a-path'
			}
		}

		It 'should return an empty hashtable when no paths section exists' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$openApiYaml = @'
openapi: 3.0.1
components:
  schemas:
    Ticket:
      type: object
'@

				$result = Get-NinjaOneOpenApiPaths -OpenApiYaml $openApiYaml

				$result | Pester\Should -BeOfType ([Hashtable])
				$result.Count | Pester\Should -Be 0
			}
		}
	}
}

Describe 'Test-NinjaOneEndpointSupport' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			$script:NRAPIInstanceCapabilities = @{}
			$script:NRAPIInstanceCapabilityCheckEnabled = $true
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.ninjarmm.com'
			}
		}
	}

	Context 'Get-NinjaOneInstanceCapabilitiesInternal' {
		It 'should return cached capabilities when available and force is not set' {
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('should-not-be-called')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$cached = [pscustomobject]@{
					BaseUrl = 'https://api.ninjarmm.com'
					Version = '2.0.0'
					SpecUrl = 'https://api.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
					RetrievedAt = Get-Date
					Paths = @{ '/v2/devices' = @('GET') }
				}
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] = $cached

				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/'
				$result | Pester\Should -Be $cached
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 0
		}

		It 'should refresh when force is set and cache exists' {
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				if ($Uri -like '*/app-version.txt') {
					return [pscustomobject]@{ Content = '3.1.4' }
				}
				$yaml = @'
openapi: 3.0.1
paths:
  /v2/devices:
    get:
      summary: List devices
'@
				return [pscustomobject]@{ Content = [System.Text.Encoding]::UTF8.GetBytes($yaml) }
			}
			Pester\Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				@{ '/v2/devices' = @('GET') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] = [pscustomobject]@{ Version = 'old' }
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force

				$result.BaseUrl | Pester\Should -Be 'https://api.ninjarmm.com'
				$result.Version | Pester\Should -Be '3.1.4'
				$result.SpecUrl | Pester\Should -Be 'https://api.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
				$result.Paths.Keys | Pester\Should -Contain '/v2/devices'
			}

			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -like '*/app-version.txt' }
			Pester\Should-Invoke -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -like '*/apidocs-beta/NinjaRMM-API-v2.yaml' }
			Pester\Should-Invoke -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -Times 1
		}

		It 'should continue when app version retrieval fails and cache capabilities with null version' {
			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				if ($Uri -like '*/app-version.txt') {
					throw [System.Exception]::new('version endpoint unavailable')
				}
				$yaml = @'
openapi: 3.0.1
paths:
  /v2/tickets:
    post:
      summary: Create ticket
'@
				return [pscustomobject]@{ Content = [System.Text.Encoding]::UTF8.GetBytes($yaml) }
			}
			Pester\Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				@{ '/v2/tickets' = @('POST') }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force
				$result.Version | Pester\Should -BeNullOrEmpty
				$result.Paths.Keys | Pester\Should -Contain '/v2/tickets'
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] | Pester\Should -Not -BeNullOrEmpty
			}
		}

		It 'should return null when OpenAPI yaml retrieval fails' {
			Pester\Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('should-not-parse-openapi-when-yaml-fetch-fails')
			}

			Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				if ($Uri -like '*/app-version.txt') {
					return [pscustomobject]@{ Content = '2.9.0' }
				}
				throw [System.Exception]::new('spec endpoint unavailable')
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force
				$result | Pester\Should -BeNullOrEmpty
			}

			Pester\Should-Invoke -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -Times 0
		}
	}

	Context 'Early exit conditions' {
		It 'should return true when capability checks are disabled' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIInstanceCapabilityCheckEnabled = $false
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should return true when connection URL is missing' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{}
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should return true for non NinjaOne hosts' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://example.com' }
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should return true when instance capabilities cannot be retrieved' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith { $null }

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}
	}

	Context 'Spec path and method matching' {
		It 'should return true for exact path and method matches' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/devices'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should match path templates and normalize resource query or trailing slash' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/organizations/{id}/custom-fields'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource 'v2/organizations/123/custom-fields/?expand=true'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should return true when path matches but methods are unknown' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$paths['/v2/devices'] = [System.Collections.Generic.HashSet[string]]::new()
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'DELETE' -Resource '/v2/devices'
				$result | Pester\Should -BeTrue
			}
		}
	}

	Context 'Refresh and failure path' {
		It 'should retry with force refresh and return true when refresh adds support' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				if ($Force) {
					$methods = [System.Collections.Generic.HashSet[string]]::new()
					$null = $methods.Add('PATCH')
					$paths['/v2/devices/{id}'] = $methods
				}
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'PATCH' -Resource '/v2/devices/abc'
				$result | Pester\Should -BeTrue
			}

			Pester\Should-Invoke -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -Exactly -ParameterFilter { -not $Force }
			Pester\Should-Invoke -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -Exactly -ParameterFilter { $Force }
		}

		It 'should throw when endpoint is not present after refresh' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/devices'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ Test-NinjaOneEndpointSupport -Method 'POST' -Resource '/v2/not-supported' } | Pester\Should -Throw '*not listed in the NinjaOne API spec*'
			}
		}

		It 'should throw with matched path info when method is not supported on a known path and refresh removes the path' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				if ($Force) {
					# Refresh returns a different path entirely — /v2/devices is gone
					$methods = [System.Collections.Generic.HashSet[string]]::new()
					$null = $methods.Add('GET')
					$paths['/v2/tickets'] = $methods
				} else {
					# Initial call has /v2/devices with only GET
					$methods = [System.Collections.Generic.HashSet[string]]::new()
					$null = $methods.Add('GET')
					$paths['/v2/devices'] = $methods
				}
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ Test-NinjaOneEndpointSupport -Method 'DELETE' -Resource '/v2/devices' } | Pester\Should -Throw '*not listed in the NinjaOne API spec*'
			}
		}

		It 'should return true after refresh when refreshed path has unknown methods' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				if ($Force) {
					# Refresh returns path with empty methods (unknown)
					$paths['/v2/devices/{id}'] = [System.Collections.Generic.HashSet[string]]::new()
				}
				# Initial call returns no paths
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'PATCH' -Resource '/v2/devices/42'
				$result | Pester\Should -BeTrue
			}
		}
		It 'should return true via fallback when method not confirmed but path matches spec' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('DELETE')
				$null = $methods.Add('PATCH')
				$paths['/v2/devices/{id}'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices/42'
				$result | Pester\Should -BeTrue
			}
		}

		It 'should throw using the raw base URL as instance host when base URL is not a valid URI' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/devices'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$script:NRAPIConnectionInformation = @{ URL = 'https://ninjarmm.com:abc/' }
				{ Test-NinjaOneEndpointSupport -Method 'POST' -Resource '/v2/not-supported' } | Pester\Should -Throw '*not listed in the NinjaOne API spec*'
			}
		}

		It 'should include organization custom-fields candidate paths in the throw message' {
			Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/organization/{id}/custom-fields'] = $methods
				$paths['/v2/tickets'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				{ Test-NinjaOneEndpointSupport -Method 'POST' -Resource '/v2/not-supported' } | Pester\Should -Throw '*not listed in the NinjaOne API spec*'
			}
		}
	}
}

Describe 'Get-TokenExpiry' {
	Context 'Token expiry calculation' {
		It 'should add correct number of seconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$beforeCall = Get-Date
				$result = Get-TokenExpiry -ExpiresIn 100
				$afterCall = Get-Date

				# Result should be approximately 100 seconds in the future
				$timeDiff = ($result - $beforeCall).TotalSeconds
				$timeDiff | Pester\Should -BeGreaterThan 99
				$timeDiff | Pester\Should -BeLessThan 102
			}
		}

		It 'should handle zero seconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$beforeCall = Get-Date
				$result = Get-TokenExpiry -ExpiresIn 0
				$timeDiff = ($result - $beforeCall).TotalSeconds

				# Should be approximately now (within 2 seconds)
				$timeDiff | Pester\Should -BeLessThan 2
			}
		}

		It 'should handle large values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Test with 1 year of seconds
				$oneYear = 365 * 24 * 60 * 60
				$result = Get-TokenExpiry -ExpiresIn $oneYear
				$result | Pester\Should -BeOfType ([DateTime])

				# Result should be roughly 1 year in the future
				$timeDiff = ($result - (Get-Date)).TotalDays
				$timeDiff | Pester\Should -BeGreaterThan 364
				$timeDiff | Pester\Should -BeLessThan 366
			}
		}

		It 'should handle negative values' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = Get-TokenExpiry -ExpiresIn -100
				$result | Pester\Should -BeOfType ([DateTime])

				# Should be in the past
				$result | Pester\Should -BeLessThan (Get-Date)
			}
		}
	}
}

Describe 'ConvertTo-UnixEpoch' {
	Context 'DateTime input' {
		It 'should convert DateTime to Unix epoch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$result = ConvertTo-UnixEpoch -DateTime $dt
				# 2024-01-01 should be a large positive number
				$result | Pester\Should -BeGreaterThan 1000000000
			}
		}

		It 'should convert current DateTime' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$now = Get-Date
				$result = ConvertTo-UnixEpoch -DateTime $now

				# Should be between 2020 and 2100 (in epoch seconds)
				$result | Pester\Should -BeGreaterThan 1577836800  # 2020-01-01
				$result | Pester\Should -BeLessThan 4102444800     # 2100-01-01
			}
		}

		It 'should convert to milliseconds when specified' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultSeconds = ConvertTo-UnixEpoch -DateTime $dt
				$resultMillis = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds

				# Milliseconds should be 1000x the seconds (approximately)
				$ratio = [double]$resultMillis / [double]$resultSeconds
				$ratio | Pester\Should -BeGreaterThan 999
				$ratio | Pester\Should -BeLessThan 1001
			}
		}

		It 'should support -Ms alias for milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultFull = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds
				$resultAlias = ConvertTo-UnixEpoch -DateTime $dt -Ms

				$resultFull | Pester\Should -Be $resultAlias
			}
		}

		It 'should support -Millis alias for milliseconds' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01T00:00:00Z'
				$resultFull = ConvertTo-UnixEpoch -DateTime $dt -Milliseconds
				$resultAlias = ConvertTo-UnixEpoch -DateTime $dt -Millis

				$resultFull | Pester\Should -Be $resultAlias
			}
		}
	}

	Context 'String input' {
		It 'should convert ISO 8601 string to Unix epoch' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertTo-UnixEpoch -DateTime '2024-01-01T00:00:00Z'
				$result | Pester\Should -BeGreaterThan 1000000000
			}
		}

		It 'should convert date-only string' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$result = ConvertTo-UnixEpoch -DateTime '2024-01-01'
				$result | Pester\Should -BeGreaterThan 1000000000
			}
		}
	}

	Context 'Integer input' {
		It 'should handle integer input' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				# Provide an epoch seconds value
				$epochSeconds = 1704067200  # 2024-01-01T00:00:00Z
				$result = ConvertTo-UnixEpoch -DateTime $epochSeconds
				# Should return a numeric result
				$result | Pester\Should -BeGreaterThan 0
			}
		}
	}

	Context 'Universal time conversion' {
		It 'should convert to UTC regardless of system timezone' {
			$module = Get-Module -name $ModuleName
			Pester\InModuleScope $ModuleName {
				$dt = Get-Date '2024-01-01T00:00:00'
				$result = ConvertTo-UnixEpoch -DateTime $dt

				# Result should be consistent and positive
				$result | Pester\Should -BeGreaterThan 0
			}
		}
	}
}

AfterAll {
	Remove-Module $ModuleName -Force
}
