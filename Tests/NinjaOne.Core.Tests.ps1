<#
    .SYNOPSIS
        Core test suite for the NinjaOne module.
#>

BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'NinjaOne'
    $ManifestPath = "$($ModulePath)\$($ModuleName).psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$False
    $Script:ModuleInformation = Import-Module -Name $ManifestPath -PassThru

}

# Test that the manifest is generally correct. Not a functional test.
Describe 'Core' {
    It 'Manifest is valid' {
        {
            Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should -Not -Throw
    }

    It 'Root module is correct' {
        $Script:ModuleInformation.RootModule | Should -Be ".\$($ModuleName).psm1"
    }

    It 'Has a description' {
        $Script:ModuleInformation.Description | Should -Not -BeNullOrEmpty
    }

    It 'GUID is correct' {
        $Script:ModuleInformation.GUID | Should -Be '0acb6fd3-575a-4dc4-873e-afbda65015b4'
    }

    It 'Version is valid' {
        $Script:ModuleInformation.Version -As [Version] | Should -Not -BeNullOrEmpty
    }

    It 'Copyright is present' {
        $Script:ModuleInformation.Copyright | Should -Not -BeNullOrEmpty
    }

    It 'License URI is correct' {
        $Script:ModuleInformation.LicenseUri | Should -Be 'https://mit.license.homotechsual.dev/'
    }

    It 'Project URI is correct' {
        $Script:ModuleInformation.ProjectUri | Should -Be 'https://github.com/homotechsual/NinjaOne'
    }

    It 'PowerShell Gallery tags is not empty' {
        $Script:ModuleInformation.Tags.count | Should -Not -BeNullOrEmpty 
    }

    It 'PowerShell Gallery tags do not contain spaces' {
        foreach ($Tag in $Script:ModuleInformation.Tags) {
            $Tag -NotMatch '\s' | Should -Be $True
        }
    }
}

Describe 'Module NinjaOne loads' {
    It 'Passed Module load' {
        Get-Module -Name 'NinjaOne' | Should -Not -Be $null
    }
}