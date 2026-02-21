<#
    .SYNOPSIS
        Core test suite for the NinjaOne module.
#>

$ModuleName = 'NinjaOne'

BeforeAll {
    $ModuleName = 'NinjaOne'
    $ModulePath = Resolve-Path -Path '.\Output\*\*' | Sort-Object -Property BaseName | Select-Object -Last 1 -ExpandProperty Path
    $ManifestPath = Get-ChildItem -Path ('{0}\*' -f $ModulePath) -Filter '*.psd1' | Select-Object -ExpandProperty FullName
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$False
    $Script:ModuleInformation = Import-Module -Name $ManifestPath -PassThru

}

Describe ('{0} - Core Tests' -f $ModuleName) -Tags 'Module' {
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
        $Script:ModuleInformation.GUID | Should -Be '2f88e09d-773b-441e-8ca5-5b5eff57bf3c'
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
        $Script:ModuleInformation.ProjectUri | Should -Be 'https://docs.homotechsual.dev/modules/ninjaone'
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

Describe ('{0} - Module Load Test' -f $ModuleName) -Tags 'Module' {
    It 'Passed Module load' {
        Get-Module -Name 'NinjaOne' | Should -Not -Be $null
    }
}

Describe ('{0} - DateTime Parsing' -f $ModuleName) -Tags 'Module' {
    It 'Converts ISO 8601 and Unix epoch values' {
        $module = Get-Module -Name $ModuleName
        & $module {
            $input = [pscustomobject]@{
                createdAt = '2024-01-01T12:34:56Z'
                updatedAt = 1704112496
                createdFloat = 1769013679.4855
                nested = [pscustomobject]@{
                    time = '1704112496000'
                    lastUpdate = '1771675908.804'
                    raw = 'not-a-date'
                    smallNumber = 1234
                }
            }
            $result = ConvertFrom-NinjaOneDateTime -InputObject $input
            $result.createdAt | Should -BeOfType ([DateTime])
            $result.updatedAt | Should -BeOfType ([DateTime])
            $result.createdFloat | Should -BeOfType ([DateTime])
            $result.nested.time | Should -BeOfType ([DateTime])
            $result.nested.lastUpdate | Should -BeOfType ([DateTime])
            $result.nested.raw | Should -Be 'not-a-date'
            $result.nested.smallNumber | Should -Be 1234
        }
    }
}

AfterAll {
    Remove-Module $ModuleName -Force
}