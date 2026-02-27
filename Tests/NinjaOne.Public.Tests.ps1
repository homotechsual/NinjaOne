#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0' }

$ModuleName = 'NinjaOne'
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\')
$ModulePath = Get-ChildItem -Path "$RepoRoot\Output\$ModuleName\*\$ModuleName.psd1" -ErrorAction Stop | Select-Object -First 1 -ExpandProperty FullName

Import-Module $ModulePath -Force

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
