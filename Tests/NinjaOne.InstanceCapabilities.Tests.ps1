<#
    .SYNOPSIS
        Instance capability test suite for the NinjaOne module.
#>
BeforeAll {
    Import-Module ('{0}\TestScaffold.psm1' -f $PSScriptRoot) -Force
    Import-ModuleToBeTested
    $ModuleName = Get-ModuleName
    $Module = Get-Module -Name $ModuleName
}

Describe 'Get-NinjaOneOpenApiPaths' -Tags 'Module' {
    It 'Parses YAML paths and methods' {
        Pester\InModuleScope -ModuleName $ModuleName {
            $yaml = @"
openapi: 3.0.1
info:
  title: Test
paths:
  /v2/device:
    get:
      summary: list
    post:
      summary: create
  /v2/device/{id}:
    get:
      summary: get
components:
  schemas: {}
"@
            $paths = Get-NinjaOneOpenApiPaths -OpenApiYaml $yaml

            $paths.Keys | Pester\Should -Contain '/v2/device'
            $paths['/v2/device'].Contains('GET') | Pester\Should -BeTrue
            $paths['/v2/device'].Contains('POST') | Pester\Should -BeTrue
            $paths.Keys | Pester\Should -Contain '/v2/device/{id}'
            $paths['/v2/device/{id}'].Contains('GET') | Pester\Should -BeTrue
        }
    }

    It 'Handles empty paths section' {
        Pester\InModuleScope -ModuleName $ModuleName {
            $yaml = @"
openapi: 3.0.1
info:
  title: Test
paths:
"@
            $paths = Get-NinjaOneOpenApiPaths -OpenApiYaml $yaml

            $paths.Count | Pester\Should -Be 0
        }
    }

    It 'Keeps paths without methods' {
        Pester\InModuleScope -ModuleName $ModuleName {
            $yaml = @"
openapi: 3.0.1
info:
  title: Test
paths:
  /v2/device:
"@
            $paths = Get-NinjaOneOpenApiPaths -OpenApiYaml $yaml

            $paths.Keys | Pester\Should -Contain '/v2/device'
            $paths['/v2/device'].Count | Pester\Should -Be 0
        }
    }
}

Describe 'Test-NinjaOneEndpointSupport' -Tags 'Module' {
    It 'Matches multiple placeholder segments' {
        Pester\InModuleScope -ModuleName $ModuleName {
            $previousEnabled = $Script:NRAPIInstanceCapabilityCheckEnabled
            $previousConnection = $Script:NRAPIConnectionInformation
            $previousCapabilities = $Script:NRAPIInstanceCapabilities

            $Script:NRAPIInstanceCapabilityCheckEnabled = $true
            $Script:NRAPIConnectionInformation = [PSCustomObject]@{ URL = 'https://eu.ninjarmm.com' }
            $Script:NRAPIInstanceCapabilities = @{}

            $paths = @{
                '/v2/organization/{orgId}/location/{locationId}/custom-fields' = [System.Collections.Generic.HashSet[string]]::new()
            }
            $Script:NRAPIInstanceCapabilities['https://eu.ninjarmm.com'] = [PSCustomObject]@{
                BaseUrl = 'https://eu.ninjarmm.com'
                Version = '12.0.20'
                SpecUrl = 'https://eu.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
                RetrievedAt = Get-Date
                Paths = $paths
            }

            $result = Test-NinjaOneEndpointSupport -Method 'PATCH' -Resource '/v2/organization/2/location/5/custom-fields'
            $result | Pester\Should -BeTrue

            $Script:NRAPIInstanceCapabilityCheckEnabled = $previousEnabled
            $Script:NRAPIConnectionInformation = $previousConnection
            $Script:NRAPIInstanceCapabilities = $previousCapabilities
        }
    }
}

Describe 'Get-NinjaOneInstanceCapabilitiesInternal' -Tags 'Module' {
    It 'Refreshes cached capabilities when forced' {
        $yaml1 = @"
openapi: 3.0.1
info:
  title: Test
paths:
  /v2/device:
    get: {}
"@
        $yaml2 = @"
openapi: 3.0.1
info:
  title: Test
paths:
  /v2/device/{id}:
    get: {}
"@
        $yamlSequence = @(
            [System.Text.Encoding]::UTF8.GetBytes($yaml1),
            [System.Text.Encoding]::UTF8.GetBytes($yaml2)
        )
        $global:yamlSequence = $yamlSequence

        Pester\InModuleScope -ModuleName $ModuleName {
            $Script:NRAPIInstanceCapabilities.Clear()
            $Script:yamlIndex = 0
            $Script:yamlSequence = $global:yamlSequence

            Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -ParameterFilter { $Uri -like '*app-version.txt' } -MockWith {
                [pscustomobject]@{ Content = '8.4.0-f' }
            }
            Pester\Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -ParameterFilter { $Uri -like '*NinjaRMM-API-v2.yaml' } -MockWith {
                $bytes = $Script:yamlSequence[$Script:yamlIndex]
                $Script:yamlIndex += 1
                [pscustomobject]@{ Content = $bytes }
            }

            $first = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://fed.ninjarmm.com'
            $cached = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://fed.ninjarmm.com'
            $refreshed = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl 'https://fed.ninjarmm.com' -Force

            $first.Paths.Keys | Pester\Should -Contain '/v2/device'
            $cached.Paths.Keys | Pester\Should -Contain '/v2/device'
            $cached.Paths.Keys | Pester\Should -Not -Contain '/v2/device/{id}'
            $refreshed.Paths.Keys | Pester\Should -Contain '/v2/device/{id}'
        }

        $global:yamlSequence = $null
    }
}

Describe 'Instance app version validation' -Tags 'Module' {
	BeforeEach {
		Pester\InModuleScope -ModuleName $ModuleName {
			$Script:NRAPIInstanceCapabilities.Clear()
			Pester\Mock -CommandName Write-Warning -MockWith {}
			Pester\Mock -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like '*NinjaRMM-API-v2.yaml' } -MockWith {
				[pscustomobject]@{ Content = "openapi: 3.0.1`npaths:`n  /v2/device:`n    get: {}" }
			}
		}
	}

	It 'accepts a trimmed version and prerelease suffix' {
		Pester\InModuleScope -ModuleName $ModuleName {
			Pester\Mock -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like '*app-version.txt' } -MockWith {
				[pscustomobject]@{ Content = "  8.4.0-f`n" }
			}
			$result = Get-NinjaOneInstanceCapabilitiesInternal -baseUrl 'https://fed.ninjarmm.com'
			$result.Version | Pester\Should -Be '8.4.0-f'
			Pester\Should-Invoke -CommandName Write-Warning -Times 0
		}
	}

	It 'accepts UTF-8 byte responses' {
		Pester\InModuleScope -ModuleName $ModuleName {
			Pester\Mock -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like '*app-version.txt' } -MockWith {
				[pscustomobject]@{ Content = [System.Text.Encoding]::UTF8.GetBytes("12.0.20`n") }
			}
			$result = Get-NinjaOneInstanceCapabilitiesInternal -baseUrl 'https://eu.ninjarmm.com'
			$result.Version | Pester\Should -Be '12.0.20'
		}
	}

	It 'rejects <Name> without caching or reporting the response as a version' -ForEach @(
		@{ Name = 'HTML'; Content = '<!doctype html><html><body>Sign in</body></html>' }
		@{ Name = 'an empty response'; Content = '' }
		@{ Name = 'arbitrary text'; Content = 'Service unavailable' }
		@{ Name = 'embedded markup'; Content = '12.0.20<script>test</script>' }
	) {
		Pester\InModuleScope -ModuleName $ModuleName -Parameters @{ Content = $Content } {
			param($Content)
			Pester\Mock -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like '*app-version.txt' } -MockWith {
				[pscustomobject]@{ Content = $Content }
			}
			$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://eu.ninjarmm.com' -includePaths
			$result.AppVersion | Pester\Should -BeNullOrEmpty
			$result.Paths.Keys | Pester\Should -Contain '/v2/device'
			$Script:NRAPIInstanceCapabilities['https://eu.ninjarmm.com'].Version | Pester\Should -BeNullOrEmpty
			Pester\Should-Invoke -CommandName Write-Warning -Times 1 -ParameterFilter {
				$Message -like '*invalid app version*' -and $Message -notlike '*<html*' -and $Message -notlike '*<script*'
			}
		}
	}

	It 'warns on version request failure and still discovers endpoints' {
		Pester\InModuleScope -ModuleName $ModuleName {
			Pester\Mock -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like '*app-version.txt' } -MockWith {
				throw 'version-request-failed'
			}
			$result = Get-NinjaOneInstanceCapabilitiesInternal -baseUrl 'https://eu.ninjarmm.com'
			$result.Version | Pester\Should -BeNullOrEmpty
			$result.Paths.Keys | Pester\Should -Contain '/v2/device'
			Pester\Should-Invoke -CommandName Write-Warning -Times 1 -ParameterFilter {
				$Message -like '*Unable to retrieve app version*version-request-failed*'
			}
		}
	}

	AfterAll {
		Pester\InModuleScope -ModuleName $ModuleName {
			$Script:NRAPIInstanceCapabilities.Clear()
		}
	}
}

Describe 'Get-NinjaOneInstanceCapabilities -IncludeCmdlets' -Tags 'Module' {
    BeforeAll {
        $capabilities = [pscustomobject]@{
            BaseUrl = 'https://fed.ninjarmm.com'
            Version = '8.4.0-f'
            SpecUrl = 'https://fed.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
            RetrievedAt = Get-Date
            Paths = @{}
        }

        Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith { $capabilities }
    }

    It 'Excludes private helper functions from analysis' {
        Pester\InModuleScope -ModuleName $ModuleName {
            $result = Get-NinjaOneInstanceCapabilities -BaseUrl 'https://fed.ninjarmm.com' -IncludeCmdlets
            $result.SupportedCmdlets | Pester\Should -Not -Contain 'Get-NinjaOneSecrets'
            $result.UnsupportedCmdlets | Pester\Should -Not -Contain 'Get-NinjaOneSecrets'
            $result.UnknownCmdlets | Pester\Should -Not -Contain 'Get-NinjaOneSecrets'
        }
    }
}

AfterAll {
    if (Get-Module -Name $ModuleName) {
        Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
    }
}
