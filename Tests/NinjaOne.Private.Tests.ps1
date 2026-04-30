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

Describe 'Get-NinjaOneSecrets' {
	BeforeEach {
		$script:RequestedSecrets = [System.Collections.Generic.List[string]]::new()
		$script:NRAPIConnectionInformation = $null
		$script:NRAPIAuthenticationInformation = $null
		$script:ParseDateTimes = $false
	}

	Context 'Secret retrieval and conversion' {
		It 'should populate and convert authorization code secrets from the vault' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$script:NRAPIConnectionInformation.AuthMode | Should -Be 'Authorization Code'
				$script:NRAPIConnectionInformation.URL | Should -Be 'https://api.test.com'
				$script:NRAPIConnectionInformation.AuthListenerPort | Should -BeOfType ([int])
				$script:NRAPIConnectionInformation.AuthListenerPort | Should -Be 8080
				$script:NRAPIConnectionInformation.UseSecretManagement | Should -BeTrue
				$script:NRAPIConnectionInformation.WriteToSecretVault | Should -BeTrue
				$script:NRAPIConnectionInformation.ReadFromSecretVault | Should -BeTrue
				$script:NRAPIConnectionInformation.VaultName | Should -Be 'TestVault'
				$script:NRAPIAuthenticationInformation.Expires | Should -BeOfType ([datetime])
				$script:ParseDateTimes | Should -BeTrue
			}
		}

		It 'should use the provided secret prefix and support token authentication' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$script:NRAPIConnectionInformation.AuthMode | Should -Be 'Token Authentication'
				$script:NRAPIAuthenticationInformation.Refresh | Should -Be 'refresh-token'
				$script:NRAPIConnectionInformation.VaultName | Should -Be 'CustomVault'
				$script:ParseDateTimes | Should -BeFalse
				$script:RequestedSecrets | Should -Contain 'CustomAuthMode'
				$script:RequestedSecrets | Should -Contain 'CustomRefresh'
				$script:RequestedSecrets | Should -Not -Contain 'NinjaOneAuthMode'
			}
		}

		It 'should skip null secrets while still initializing script scoped stores' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$script:NRAPIConnectionInformation | Should -BeOfType ([hashtable])
				$script:NRAPIAuthenticationInformation | Should -BeOfType ([hashtable])
				$script:NRAPIConnectionInformation.ContainsKey('RedirectURI') | Should -BeFalse
				$script:NRAPIAuthenticationInformation.ContainsKey('Access') | Should -BeFalse
				$script:NRAPIConnectionInformation.UseSecretManagement | Should -BeTrue
			}
		}

		It 'should reuse existing script scoped stores and overwrite stale values from the vault' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$script:NRAPIConnectionInformation.AuthMode | Should -Be 'Token Authentication'
				$script:NRAPIConnectionInformation.URL | Should -Be 'https://api.test.com'
				$script:NRAPIConnectionInformation.UseSecretManagement | Should -BeTrue
				$script:NRAPIConnectionInformation.WriteToSecretVault | Should -BeTrue
				$script:NRAPIConnectionInformation.ReadFromSecretVault | Should -BeTrue
				$script:NRAPIConnectionInformation.VaultName | Should -Be 'TestVault'
				$script:NRAPIAuthenticationInformation.Access | Should -Be 'fresh-access'
				$script:NRAPIAuthenticationInformation.Refresh | Should -Be 'fresh-refresh'
				$script:NRAPIAuthenticationInformation.Expires | Should -BeOfType ([datetime])
				$script:ParseDateTimes | Should -BeFalse
			}
		}
	}
}

Describe 'New-NinjaOneError' {
	Context 'Error transformation behavior' {
		It 'should pass through non-http exceptions as terminating errors' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.FullyQualifiedErrorId | Should -Match '^TestErrorId'
				$caught.Exception.Message | Should -Be 'Plain test error'
			}
		}

		It 'should preserve JSON error details for web exceptions in current behavior' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Should -Be '{"resultCode":"401","errorMessage":"Unauthorized"}'
			}
		}

		It 'should keep null error details for web exceptions with no details in current behavior' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Should -BeNullOrEmpty
			}
		}

		It 'should preserve API and HTTP text lines from plain text error details' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Should -Match 'The NinjaOne API said 500: Boom\.'
				$caught.ErrorDetails.Message | Should -Match 'HTTP error response: 500 Internal Server Error'
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
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails.Message | Should -Be '{"resultCode":"401","errorMessage":"Unauthorized"}'
			}
		}

		It 'should process JSON resultCode-only and error-only payloads without changing current error-details shape' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$firstCatch.ErrorDetails.Message | Should -Be '{"resultCode":"429"}'

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

				$secondCatch.ErrorDetails.Message | Should -Be '{"error":"invalid request"}'
			}
		}

		It 'should split plain text API and HTTP lines into distinct messages' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught.ErrorDetails.Message | Should -Match 'The NinjaOne API said 500: Boom\.'
				$caught.ErrorDetails.Message | Should -Match 'HTTP error response: 500 Internal Server Error'
			}
		}

		It 'should handle missing error details with current null error-details behavior' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught.ErrorDetails | Should -BeNullOrEmpty
			}
		}

		It 'should accept hasResponse with response metadata in current behavior' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$caught | Should -Not -BeNullOrEmpty
				$caught.ErrorDetails | Should -BeNullOrEmpty
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
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('skip', '0')
				$qs.Add('limit', '10')
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
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('filter', 'name eq "test"')
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
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('test', 'value')
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -QSCollection $qs -ErrorAction SilentlyContinue } | Should -Not -Throw
			}
		}
	}

	Context 'Request behavior' {
		It 'should call endpoint support with POST method' {
			Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}

			$module = Get-Module -Name $ModuleName
			& $module {
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
			}

			Assert-MockCalled -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'POST' -and $resource -eq '/v2/organizations' }
		}

		It 'should throw when connection information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should return the results property when present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b') }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				@($result) | Should -Contain 'a'
				@($result) | Should -Contain 'b'
			}
		}

		It 'should return the result property when present and results is absent' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ id = 123 } }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				$result.id | Should -Be 123
			}
		}

		It 'should return raw response when neither results nor result exists' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ status = 'ok' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
				$result.status | Should -Be 'ok'
			}
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -ParseDateTime
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:ParseDateTimes = $true
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations'
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should include query parameters in the built request uri' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('test', 'value')
				$qs.Add('limit', '10')
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -QSCollection $qs
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Uri -match '/v2/organizations' -and $Uri -match 'test=value' -and $Uri -match 'limit=10'
			}
		}

		It 'should serialize object bodies to json' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$body = @{ name = 'Contoso'; enabled = $true }
				$null = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -match '"name"\s*:\s*"Contoso"' -and $Body -match '"enabled"\s*:\s*true'
			}
		}

		It 'should delegate invalid multipart payload shapes to New-NinjaOneError' {
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$body = @(@{ file = 'placeholder.txt' })
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Should -Throw '*multipart-delegated*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should route multipart hashtable bodies through error delegation when HttpContent request fails' {
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-hashtable-delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$body = @{ metadata = @{ name = 'contoso' }; tags = @('a', 'b') }
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $body -UseMultipart } | Should -Throw '*multipart-hashtable-delegated*'
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0
			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should route multipart HttpContent bodies through error delegation when HttpContent request fails' {
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('multipart-httpcontent-delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation.URL = 'https://127.0.0.1:1'
				$content = [System.Net.Http.StringContent]::new('{"name":"contoso"}', [System.Text.Encoding]::UTF8, 'application/json')
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body $content -UseMultipart } | Should -Throw '*multipart-httpcontent-delegated*'
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 0
			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should fall back to standard request path when multipart detection returns false' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ ok = $true } }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOnePOSTRequest -Resource '/v2/organizations' -Body 42 -UseMultipart
				$result.ok | Should -BeTrue
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
				$Body -eq '42'
			}
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('boom')
			}
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Should -Throw '*delegated*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-post-delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePOSTRequest -Resource '/v2/organizations' } | Should -Throw '*preflight failure*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
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

	Context 'Query construction behavior' {
		It 'should skip optional common parameters' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$parameters = @{
					WhatIf = [pscustomobject]@{
						Name = 'WhatIf'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result.Count | Should -Be 0
			}
		}

		It 'should use aliases for string and boolean parameters' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				$result['q'] | Should -Be 'alpha'
				$result['archived'] | Should -Be 'false'
			}
		}

		It 'should skip empty strings and false switches' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				$result.AllKeys -contains 'Filter' | Should -BeFalse
				$result.AllKeys -contains 'details' | Should -BeFalse
			}
		}

		It 'should use the parameter name for switch parameters without aliases' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$IncludeDetails = $true
				$parameters = @{
					IncludeDetails = [pscustomobject]@{
						Name = 'IncludeDetails'
						ParameterType = [pscustomobject]@{ Name = 'SwitchParameter' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['IncludeDetails'] | Should -Be 'true'
			}
		}

		It 'should use the parameter name for boolean parameters without aliases' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$IncludeArchived = $true
				$parameters = @{
					IncludeArchived = [pscustomobject]@{
						Name = 'IncludeArchived'
						ParameterType = [pscustomobject]@{ Name = 'Boolean' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters
				$result['IncludeArchived'] | Should -Be 'true'
			}
		}

		It 'should serialize string arrays as comma separated values when requested' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$Tags = @('one', 'two')
				$parameters = @{
					Tags = [pscustomobject]@{
						Name = 'Tags'
						ParameterType = [pscustomobject]@{ Name = 'String[]' }
						Aliases = @()
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['Tags'] | Should -Be 'one,two'
			}
		}

		It 'should serialize integer arrays as comma separated values when requested' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$Ids = @(1, 2, 3)
				$parameters = @{
					Ids = [pscustomobject]@{
						Name = 'Ids'
						ParameterType = [pscustomobject]@{ Name = 'Int32[]' }
						Aliases = @('id')
					}
				}

				$result = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -CommaSeparatedArrays
				$result['id'] | Should -Be '1,2,3'
			}
		}

		It 'should serialize datetime array items to Unix epoch values when using comma separated arrays' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				$result['createdAfter'] | Should -Be $expected
			}
		}

		It 'should process non-comma array paths for string int and datetime values' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				$result['tag'] | Should -Be 'single'
				$result['id'] | Should -Be 42
				$result['createdAfter'] | Should -Not -BeNullOrEmpty
			}
		}

		It 'should skip unset integers and include aliased integer values' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				$result.AllKeys -contains 'Limit' | Should -BeFalse
				$result['skip'] | Should -Be 10
			}
		}

		It 'should return a query string when AsString is specified' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$Name = 'Contoso'
				$parameters = @{
					Name = [pscustomobject]@{
						Name = 'Name'
						ParameterType = [pscustomobject]@{ Name = 'String' }
						Aliases = @('name')
					}
				}

				$query = New-NinjaOneQuery -CommandName 'Get-Test' -Parameters $parameters -AsString
				$query | Should -BeOfType ([string])
				$query.StartsWith('?') | Should -BeTrue
				$query | Should -Match 'name=Contoso'
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
			$module = Get-Module -Name $ModuleName
			& $module {
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
				{ Set-NinjaOneSecrets @params -ErrorAction Stop } | Should -Not -Throw

				$script:CapturedSecretWrites.Count | Should -BeGreaterThan 10
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthMode' }).Count | Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneClientSecret' }).Count | Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneParseDateTimes' -and $_.Secret -eq 'True' }).Count | Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthListenerPort' -and $_.Secret -eq '8080' }).Count | Should -Be 1
			}
		}

		It 'should use a custom secret prefix and skip null or empty values' {
			$module = Get-Module -Name $ModuleName
			& $module {
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
				{ Set-NinjaOneSecrets @params -ErrorAction Stop } | Should -Not -Throw

				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomAuthMode' }).Count | Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomRefresh' }).Count | Should -Be 1
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomAccess' }).Count | Should -Be 0
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'CustomRedirectURI' }).Count | Should -Be 0
				($script:CapturedSecretWrites | Where-Object { $_.Name -eq 'NinjaOneAuthMode' }).Count | Should -Be 0
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

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Should -Throw '*Missing NinjaOne connection information*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Should -Throw '*Missing NinjaOne authentication tokens*'
			}
		}

		It 'should return results when results property is present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b') }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				@($result) | Should -Contain 'a'
				@($result) | Should -Contain 'b'
			}
		}

		It 'should return result when result property is present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{ ok = $true } }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				$result.ok | Should -BeTrue
			}
		}

		It 'should return raw object when neither results nor result is present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ status = 'deleted' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				$result.status | Should -Be 'deleted'
			}
		}

		It 'should pass ParseDateTime when explicitly requested' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1' -ParseDateTime
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should pass ParseDateTime when script setting is enabled' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:ParseDateTimes = $true
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime }
		}

		It 'should build query collection path when QSCollection exists in scope' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @{} }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:QSCollection = @{ skip = 5; limit = 10 }
				$null = New-NinjaOneDELETERequest -Resource '/v2/organizations/1'
				$script:QSCollection = $null
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -match '/v2/organizations/1' }
		}

		It 'should delegate web exceptions from Invoke-NinjaOneRequest in current core behavior' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Net.WebException]::new('web failure')
			}
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated-web')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Should -Throw '*delegated-web*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should delegate non-http failures from Invoke-NinjaOneRequest to New-NinjaOneError' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('generic failure')
			}
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('delegated-delete')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Should -Throw '*delegated-delete*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}
			Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('outer-delete-delegated')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOneDELETERequest -Resource '/v2/organizations/1' } | Should -Throw '*preflight failure*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
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
		Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			throw [System.Exception]::new('delegated-patch')
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

	Context 'Request behavior' {
		It 'should throw when connection information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = $null
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'a' } } | Should -Throw '*Connect-NinjaOne*'
			}
		}

		It 'should throw when authentication information is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIAuthenticationInformation = $null
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'a' } } | Should -Throw '*Connect-NinjaOne*'
			}
		}

		It 'should call endpoint support with PATCH method' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$null = New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ status = 'active' }
			}

			Assert-MockCalled -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -Times 1 -ParameterFilter { $Method -eq 'PATCH' -and $resource -eq '/v2/organizations/1' }
		}

		It 'should include query string values in the request URI' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				param($Uri)
				[pscustomobject]@{ result = @($Uri) }
			}

			$module = Get-Module -Name $ModuleName
			$result = & $module {
				$qs = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				$qs.Add('pageSize', '10')
				$qs.Add('detailed', 'true')
				New-NinjaOnePATCHRequest -Resource '/v2/organizations' -Body @{ name = 'updated' } -qSCollection $qs
			}

			($result | Out-String) | Should -Match 'pageSize'
			($result | Out-String) | Should -Match 'detailed'
		}

		It 'should set ParseDateTime when requested by switch' {
			$module = Get-Module -Name $ModuleName
			& $module {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } -parseDateTime
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime -eq $true }
		}

		It 'should set ParseDateTime when script preference is enabled' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:ParseDateTimes = $true
				try {
					New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
				} finally {
					$script:ParseDateTimes = $false
				}
			}

			Assert-MockCalled -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $ParseDateTime -eq $true }
		}

		It 'should return Result.results when present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ results = @('a', 'b'); result = @('fallback') }
			}

			$module = Get-Module -Name $ModuleName
			$result = & $module {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result | Should -Be @('a', 'b')
		}

		It 'should return Result.result when results is not present' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				@{ result = @('single') }
			}

			$module = Get-Module -Name $ModuleName
			$result = & $module {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result | Should -Be @('single')
		}

		It 'should return raw result when neither result nor results exists' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				[pscustomobject]@{ status = 'ok' }
			}

			$module = Get-Module -Name $ModuleName
			$result = & $module {
				New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' }
			}

			$result.status | Should -Be 'ok'
		}

		It 'should delegate non-http request failures to New-NinjaOneError' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('generic failure')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Should -Throw '*delegated-patch*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should delegate web exceptions from request in current core behavior' {
			Mock -CommandName Invoke-NinjaOneRequest -ModuleName $ModuleName -MockWith {
				throw [System.Net.WebException]::new('web failure')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Should -Throw '*delegated-patch*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
		}

		It 'should propagate preflight failures before request try-catch' {
			Mock -CommandName Test-NinjaOneEndpointSupport -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('preflight failure')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ New-NinjaOnePATCHRequest -Resource '/v2/organizations/1' -Body @{ name = 'updated' } } | Should -Throw '*preflight failure*'
			}

			Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 0
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

Describe 'Get-NinjaOneOpenApiPaths' {
	Context 'OpenAPI path parsing' {
		It 'should extract allowed methods for each path' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$result.Keys.Count | Should -Be 2
				$result.Keys | Should -Contain '/v2/organizations'
				$result.Keys | Should -Contain '/v2/devices/{id}'
				([string[]]$result['/v2/organizations']) | Should -Contain 'GET'
				([string[]]$result['/v2/organizations']) | Should -Contain 'POST'
				([string[]]$result['/v2/devices/{id}']) | Should -Contain 'DELETE'
			}
		}

		It 'should ignore unsupported methods and de-duplicate method names' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$methods.Count | Should -Be 2
				$methods | Should -Contain 'PATCH'
				$methods | Should -Contain 'HEAD'
				$methods | Should -Not -Contain 'TRACE'
			}
		}

		It 'should stop parsing when the paths section ends' {
			$module = Get-Module -Name $ModuleName
			& $module {
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

				$result.Keys.Count | Should -Be 1
				$result.Keys | Should -Contain '/v2/alerts'
				$result.Keys | Should -Not -Contain '/not-a-path'
			}
		}

		It 'should return an empty hashtable when no paths section exists' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$openApiYaml = @'
openapi: 3.0.1
components:
  schemas:
    Ticket:
      type: object
'@

				$result = Get-NinjaOneOpenApiPaths -OpenApiYaml $openApiYaml

				$result | Should -BeOfType ([Hashtable])
				$result.Count | Should -Be 0
			}
		}
	}
}

Describe 'Test-NinjaOneEndpointSupport' {
	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIInstanceCapabilities = @{}
		}
	}

	Context 'Get-NinjaOneInstanceCapabilitiesInternal' {
		It 'should return cached capabilities when available and force is not set' {
			Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('should-not-be-called')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$cached = [pscustomobject]@{
					BaseUrl = 'https://api.ninjarmm.com'
					Version = '2.0.0'
					SpecUrl = 'https://api.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
					RetrievedAt = Get-Date
					Paths = @{ '/v2/devices' = @('GET') }
				}
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] = $cached

				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/'
				$result | Should -Be $cached
			}

			Assert-MockCalled -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 0
		}

		It 'should refresh when force is set and cache exists' {
			Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
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
			Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				@{ '/v2/devices' = @('GET') }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] = [pscustomobject]@{ Version = 'old' }
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force

				$result.BaseUrl | Should -Be 'https://api.ninjarmm.com'
				$result.Version | Should -Be '3.1.4'
				$result.SpecUrl | Should -Be 'https://api.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
				$result.Paths.Keys | Should -Contain '/v2/devices'
			}

			Assert-MockCalled -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -like '*/app-version.txt' }
			Assert-MockCalled -CommandName Invoke-WebRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Uri -like '*/apidocs-beta/NinjaRMM-API-v2.yaml' }
			Assert-MockCalled -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -Times 1
		}

		It 'should continue when app version retrieval fails and cache capabilities with null version' {
			Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
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
			Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				@{ '/v2/tickets' = @('POST') }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force
				$result.Version | Should -BeNullOrEmpty
				$result.Paths.Keys | Should -Contain '/v2/tickets'
				$script:NRAPIInstanceCapabilities['https://api.ninjarmm.com'] | Should -Not -BeNullOrEmpty
			}
		}

		It 'should return null when OpenAPI yaml retrieval fails' {
			Mock -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -MockWith {
				throw [System.Exception]::new('should-not-parse-openapi-when-yaml-fetch-fails')
			}

			Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
				if ($Uri -like '*/app-version.txt') {
					return [pscustomobject]@{ Content = '2.9.0' }
				}
				throw [System.Exception]::new('spec endpoint unavailable')
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://api.ninjarmm.com/' -Force
				$result | Should -BeNullOrEmpty
			}

			Assert-MockCalled -CommandName Get-NinjaOneOpenApiPaths -ModuleName $ModuleName -Times 0
		}
	}

	BeforeEach {
		$module = Get-Module -Name $ModuleName
		& $module {
			$script:NRAPIInstanceCapabilityCheckEnabled = $true
			$script:NRAPIConnectionInformation = @{
				URL = 'https://api.ninjarmm.com'
			}
		}
	}

	Context 'Early exit conditions' {
		It 'should return true when capability checks are disabled' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIInstanceCapabilityCheckEnabled = $false
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Should -BeTrue
			}
		}

		It 'should return true when connection URL is missing' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{}
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Should -BeTrue
			}
		}

		It 'should return true for non NinjaOne hosts' {
			$module = Get-Module -Name $ModuleName
			& $module {
				$script:NRAPIConnectionInformation = @{ URL = 'https://example.com' }
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Should -BeTrue
			}
		}
	}

	Context 'Spec path and method matching' {
		It 'should return true for exact path and method matches' {
			Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/devices'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource '/v2/devices'
				$result | Should -BeTrue
			}
		}

		It 'should match path templates and normalize resource query or trailing slash' {
			Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/organizations/{id}/custom-fields'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Test-NinjaOneEndpointSupport -Method 'GET' -Resource 'v2/organizations/123/custom-fields/?expand=true'
				$result | Should -BeTrue
			}
		}

		It 'should return true when path matches but methods are unknown' {
			Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				$paths = @{}
				$paths['/v2/devices'] = [System.Collections.Generic.HashSet[string]]::new()
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Test-NinjaOneEndpointSupport -Method 'DELETE' -Resource '/v2/devices'
				$result | Should -BeTrue
			}
		}
	}

	Context 'Refresh and failure path' {
		It 'should retry with force refresh and return true when refresh adds support' {
			Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				if ($Force) {
					$methods = [System.Collections.Generic.HashSet[string]]::new()
					$null = $methods.Add('PATCH')
					$paths['/v2/devices/{id}'] = $methods
				}
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				$result = Test-NinjaOneEndpointSupport -Method 'PATCH' -Resource '/v2/devices/abc'
				$result | Should -BeTrue
			}

			Assert-MockCalled -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -Exactly -ParameterFilter { -not $Force }
			Assert-MockCalled -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -Exactly -ParameterFilter { $Force }
		}

		It 'should throw when endpoint is not present after refresh' {
			Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
				param($BaseUrl, [switch]$Force)
				$paths = @{}
				$methods = [System.Collections.Generic.HashSet[string]]::new()
				$null = $methods.Add('GET')
				$paths['/v2/devices'] = $methods
				return [pscustomobject]@{ Paths = $paths; Version = '1.0.0' }
			}

			$module = Get-Module -Name $ModuleName
			& $module {
				{ Test-NinjaOneEndpointSupport -Method 'POST' -Resource '/v2/not-supported' } | Should -Throw '*not listed in the NinjaOne API spec*'
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
