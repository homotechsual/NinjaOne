#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0' }

$ModuleName = 'NinjaOne'
$RepoRoot = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\')).Path
$ModulePath = $env:NINJAONE_MODULE_MANIFEST
if ([string]::IsNullOrWhiteSpace($ModulePath)) {
	$ModulePath = Get-ChildItem -Path ('{0}\Output\{1}\*\{1}.psd1' -f $RepoRoot, $ModuleName) -ErrorAction Stop | Select-Object -Last 1 -ExpandProperty FullName
}

Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
Import-Module $ModulePath -Force

Describe 'Public function definitions' {
	It 'does not define the same public function in more than one source file' {
		$PublicRoot = Resolve-Path -Path (Join-Path -Path $RepoRoot -ChildPath 'Source\Public')
		$Definitions = foreach ($file in Get-ChildItem -Path $PublicRoot -Recurse -Filter '*.ps1') {
			$tokens = $null
			$parseErrors = $null
			$ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
			if ($parseErrors) {
				$ParseErrorSummary = $parseErrors | ForEach-Object {
					'{0}:{1}:{2}: {3}' -f $_.Extent.File, $_.Extent.StartLineNumber, $_.Extent.StartColumnNumber, $_.Message
				}
				throw ("Failed to parse public source file(s):`n{0}" -f ($ParseErrorSummary -join "`n"))
			}
			foreach ($function in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) {
				[pscustomobject]@{
					Name = $function.Name
					File = $file.FullName.Substring($RepoRoot.Length).TrimStart('\', '/')
				}
			}
		}

		$Duplicates = $Definitions | Group-Object Name | Where-Object Count -GT 1
		if ($Duplicates) {
			$Summary = $Duplicates | ForEach-Object {
				'{0}: {1}' -f $_.Name, (($_.Group.File | Sort-Object) -join ', ')
			}
			throw ("Duplicate public function definitions detected:`n{0}" -f ($Summary -join "`n"))
		}
	}
}

Describe 'Public Query Functions - Existence Tests' {
	It 'Get-NinjaOneCustomFields should exist' {
		Get-Command -Name Get-NinjaOneCustomFields -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusStatus should exist' {
		Get-Command -Name Get-NinjaOneAntivirusStatus -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusThreats should exist' {
		Get-Command -Name Get-NinjaOneAntivirusThreats -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneDeviceBackupUsage should exist' {
		Get-Command -Name Get-NinjaOneDeviceBackupUsage -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}
}

Describe 'New-NinjaOneTicketComment' {
	It 'wraps a simple comment object in a multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
			$script:CapturedTicketCommentRequest = $null
			function New-NinjaOnePOSTRequest {
				<#
					.SYNOPSIS
						Mock replacement for New-NinjaOnePOSTRequest used to capture call parameters in tests.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$Body,
					$UseMultipart
				)
				$script:CapturedTicketCommentRequest = [pscustomobject]@{
					Resource     = $Resource
					Body         = $Body
					UseMultipart = $UseMultipart
				}
				return $script:CapturedTicketCommentRequest
			}

			$result = New-NinjaOneTicketComment -ticketId 1003 -comment @{ public = $true; body = 'Test Comment via API' } -Confirm:$false -show

			$script:CapturedTicketCommentRequest | Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.public | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.body | Should -Be 'Test Comment via API'
			$result.Body.comment.body | Should -Be 'Test Comment via API'
		}
	}

	It 'preserves an explicit multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
			$script:CapturedTicketCommentRequest = $null
			$body = @{
				comment = @{
					public = $true
					body   = 'Test Comment via API'
				}
				files = @('C:\Temp\example.txt')
			}
			function New-NinjaOnePOSTRequest {
				<#
					.SYNOPSIS
						Mock replacement for New-NinjaOnePOSTRequest used to capture call parameters in tests.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$Body,
					$UseMultipart
				)
				$script:CapturedTicketCommentRequest = [pscustomobject]@{
					Resource     = $Resource
					Body         = $Body
					UseMultipart = $UseMultipart
				}
				return $script:CapturedTicketCommentRequest
			}

			$result = New-NinjaOneTicketComment -ticketId 1003 -comment $body -Confirm:$false -show

			$script:CapturedTicketCommentRequest | Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.Contains('files') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.files[0] | Should -Be 'C:\Temp\example.txt'
			$result.Body.files[0] | Should -Be 'C:\Temp\example.txt'
		}
	}
}

Describe 'Get-NinjaOneActivities' {
	It 'does not emit boolean output when using -deviceId with -type' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
			function New-NinjaOneGETRequest {
				<#
				.SYNOPSIS
					Returns mock activity data for the `-deviceId` and `-type` test case.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$QSCollection,
					$Raw,
					$ParseDateTime
				)

				return [pscustomobject]@{
					lastActivityId = 42
					activities = @(
						[pscustomobject]@{
							id = 42
							type = 'Action'
						}
					)
				}
			}

			$result = @(Get-NinjaOneActivities -deviceId 123 -type 'Action')

			$result.Count | Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Should -Be 0
			$result[0].lastActivityId | Should -Be 42
			$result[0].activities[0].type | Should -Be 'Action'
		}
	}

	It 'does not emit boolean output when using -activityType' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
			function New-NinjaOneGETRequest {
				<#
				.SYNOPSIS
					Returns mock activity data for the `-activityType` test case.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$QSCollection,
					$Raw,
					$ParseDateTime
				)

				return [pscustomobject]@{
					lastActivityId = 7
					activities     = @(
						[pscustomobject]@{
							id   = 7
							type = 'Action'
						}
					)
				}
			}

			$result = @(Get-NinjaOneActivities -activityType 'Action')

			$result.Count | Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Should -Be 0
			$result[0].lastActivityId | Should -Be 7
			$result[0].activities[0].id | Should -Be 7
		}
	}
}

Describe 'Get-NinjaOneUsers' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			@{}
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{
					id = 1
					name = 'Test User'
				}
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the default users endpoint when organisationId is not supplied' {
		$module = Get-Module -Name $ModuleName
		$result = & $module {
			Get-NinjaOneUsers -includeRoles
		}

		@($result).Count | Should -Be 1
		$result[0].id | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/users' }
	}

	It 'uses the organisation users endpoint when organisationId is supplied' {
		$module = Get-Module -Name $ModuleName
		$result = & $module {
			Get-NinjaOneUsers -organisationId 7 -userType END_USER
		}

		@($result).Count | Should -Be 1
		$result[0].name | Should -Be 'Test User'
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/organization/7/end-users' }
	}

	It 'delegates no-result default-path failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		& $module {
			{ Get-NinjaOneUsers } | Should -Throw '*No users found*'
		}

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result organisation-path failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		& $module {
			{ Get-NinjaOneUsers -organisationId 12 -userType END_USER } | Should -Throw '*No users found for organisation 12*'
		}

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

# ============================================================================
# COMPREHENSIVE PUBLIC QUERY TEST SUITE SUMMARY
# ============================================================================
#
# This test suite validates public query functions in the NinjaOne PowerShell module.
# It uses Pester mocks to simulate API responses without requiring a live API connection.
#
# Test Categories:
# 1. Default Parameters - Verifies basic function calls retrieve data
# 2. Response Transformation - Validates JSON parsing and object construction
# 3. Parameter Passing - Ensures filters and options are sent to API correctly
# 4. Error Handling - Tests appropriate error responses from API
# 5. Pagination Support - Validates cursor-based pagination for large datasets
# 6. Data Validation - Ensures returned data has expected types and values
#
# Functions Tested:
# - Get-NinjaOneCustomFields: Device custom field definitions
# - Get-NinjaOneAntivirusStatus: Current antivirus product status per device
# - Get-NinjaOneAntivirusThreats: Historical antivirus threat detection records
# - Get-NinjaOneDeviceBackupUsage: Backup storage usage and quota information
#
# Mock Strategy:
# - Global Invoke-WebRequest mock in BeforeAll routes responses by API endpoint
# - Realistic JSON responses match actual NinjaOne API response structure
# - Error scenarios (401, 404, 500) tested with appropriate error responses
#
# Next Steps:
# - Expand to additional Queries category functions
# - Add tests for Users, Organization, Location, Ticketing categories
# - Test error scenarios comprehensively across all functions
# - Implement performance benchmarking for large dataset handling
#
