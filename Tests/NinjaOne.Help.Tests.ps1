<#
    .SYNOPSIS
        Help test suite for the NinjaOne module.
#>
$ModuleName = 'NinjaOne'
$ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
$ManifestPath = "$($ModulePath)\$($ModuleName).psd1"
BeforeAll {
    $ModulePath = Split-Path -Parent -Path (Split-Path -Parent -Path $PSCommandPath)
    $ModuleName = 'NinjaOne'
    $ManifestPath = "$($ModulePath)\$($ModuleName).psd1"
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    Import-Module $ManifestPath -Verbose:$False
}
Describe ('{0} - Help Content' -f $ModuleName) -Tags 'Module' {
    Import-Module $ManifestPath
    $CommonParameters = @([System.Management.Automation.PSCmdlet]::CommonParameters, [System.Management.Automation.PSCmdlet]::OptionalCommonParameters)
    # Get a list of the exported functions.
    $Module = Get-Module -Name $ModuleName
    $FunctionList = $Module.ExportedFunctions.Keys
    # Iterate over the list of exported functions.
    foreach ($Function in $FunctionList) {
        Context ('{0} - Help Content' -f $Function) {
            $Help = Get-Help -Name $Function -Full | Select-Object -Property *
            $RawParameters = Get-Help -Name $Function -Parameter * -ErrorAction Ignore
            $FilteredParameters = $RawParameters | Where-Object {
                $_.Name -and $_.Name -notin $CommonParameters
            }
            $Parameters = ForEach ($FilteredParameter in $FilteredParameters) {
                @{
                    Name = $FilteredParameter.Name
                    Description = $FilteredParameter.Description.Text
                }
            }
            $AST = @{
                AST = Get-Content -Path ('function:/{0}' -f $Function) -ErrorAction Ignore | Select-Object -ExpandProperty AST
                Parameters = $Parameters
            }
            $Examples = $Help.Examples.Example | ForEach-Object { @{ Example = $_ } }
            # Help content tests.
            ## Help content exists.
            It ('{0} has help content' -f $Function) -TestCases $Help {
                $_ | Should -Not -BeNullOrEmpty
            }
            ## Synopsis exists.
            It ('{0} contains a synopsis' -f $Function) -TestCases $Help {
                $_.Synopsis | Should -Not -BeNullOrEmpty
            }
            ## Description exists.
            It ('{0} contains a description' -f $Function) -TestCases $Help {
                $_.Description | Should -Not -BeNullOrEmpty
            }
            ## Functionality exists.
            It ('{0} contains a functionality' -f $Function) -TestCases $Help {
                $_.Functionality | Should -Not -BeNullOrEmpty -Because 'The functionality string is used in the documentation process to provide shorter page titles and URLs.'
            }
            ## Example exists.
            It ('{0} has at least one usage example' -f $Function) -TestCases $Help {
                $_.Examples.Example.Code.Count | Should -BeGreaterOrEqual 1
            }
            ## Examples have a title.
            ### This test is not currently meaningful because it is not possible to set an example title using Comment Based Help at this time. However examples do get a default `Example n` title where n is the sequential number of the example. Ref: https://github.com/PowerShell/PowerShell/issues/20712.
            It ('{0} has a title for each example' -f $Function) -TestCases $Examples {
                $Example.Title | Should -Not -BeNullOrEmpty
            }
            ## Examples have a description.
            It ('{0} has a description for each example' -f $Function) -TestCases $Examples -Skip:(-not $Examples) {
                $Example.Remarks | Should -Not -BeNullOrEmpty -Because ('example {0} should have a description' -f $Example.Title)
            }
            # AST tests.
        }
    }
}