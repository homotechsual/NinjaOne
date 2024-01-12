<#
    .SYNOPSIS
        Schema test suite for the NinjaOne module.
#>
BeforeDiscovery {
    Import-Module  ('{0}\TestScaffold.psm1' -f $PSScriptRoot) -Force
    Import-ModuleToBeTested
    $Endpoints = Get-Endpoints
    $FunctionList = Get-FunctionList
    $ModuleName = Get-ModuleName
}
BeforeAll {
    $Endpoints = Get-Endpoints
    $FunctionList = Get-FunctionList
    $ModuleName = Get-ModuleName
}
Describe ('<ModuleName> - Schema Completeness') -Tags 'Module' {
    Context 'Function <_.Name>' -ForEach $FunctionList {
        $AST = $_.ScriptBlock.Ast
        $MetadataFinder = { $args[0] -is [System.Management.Automation.Language.AttributeAst] -and $args[0].TypeName.Name -eq 'MetadataAttribute' -and $args[0].Parent -is [System.Management.Automation.Language.ParamBlockAst] }
        $MetadataElement = $AST.FindAll($MetadataFinder, $true)
        if ($MetadataElement[0].PSObject.Properties.Name -match 'PositionalArguments') {
            $PositionalArguments = $MetadataElement[0].PositionalArguments
        } else {
            $PositionalArguments = @{}
        }
        # $StructuredMetadata = [System.Collections.Generic.List[hashtable]]::new()
        $StructuredMetadata = if ($PositionalArguments.Count -gt 0 -and ($PositionalArguments.Count % 2 -eq 0)) {
            for ($i = 0; $i -lt $PositionalArguments.Count; $i += 2) {
                return [hashtable]@{
                    Endpoint = $PositionalArguments[$i].Value
                    Method = $PositionalArguments[$i + 1].Value
                }
            }
        }
        Context 'Metadata Attribute <_>' -ForEach $MetadataElement {
            # Schema tests.
            ## Metadata attribute exists.
            It ('should have a Metadata attribute') {
                $_ | Should -Not -BeNullOrEmpty
            }
            ## Only one Metadata attribute exists.
            It ('should have only one Metadata attribute') {
                $_.Count | Should -Be 1
            }
            ## Metadata attribute has positional arguments.
            It ('should have positional arguments') {
                $_.PositionalArguments | Should -Not -BeNullOrEmpty
            }
            ## Metadata attribute has a non-zero number of positional arguments.
            It ('should have a non-zero number of positional arguments') {
                $_.PositionalArguments.Count | Should -BeGreaterThan 0
            }       
        }
        Context 'Metadata <_> Positional Arguments' -ForEach $MetadataElement -Skip:($MetadataElement.PositionalArguments.Count -eq 0) {     
            ## Metadata attribute has an even number of positional arguments.
            It ('should have an even number of positional arguments') -Skip:($PositionalArguments[0].Value -ceq 'IGNORE') {
                $_.PositionalArguments.Count % 2 | Should -Be 0
            }
        }
        Context 'Metadata Pair <Method>: <Endpoint>' -ForEach $StructuredMetadata -Skip:($StructuredMetadata.Count -eq 0) {
            It ('should match an endpoint') {
                $Endpoints | Out-Host
                $Endpoint = $Endpoints | Where-Object { $_.Path -eq $Endpoint -and $_.Method -eq $Method }
                $Endpoint | Should -Not -BeNullOrEmpty -Because ('{0}: {1} should match an endpoint' -f $Method, $Endpoint)
            }
        }
        Context 'Endpoint <Method>: <Path>' -ForEach $Endpoints -Skip:($Endpoints.Count -eq 0) {
            It ('should match a metadata attribute') {
                $MetadataPair = $StructuredMetadata | Where-Object { $_.Endpoint -eq $Path -and $_.Method -eq $Method } 
                $MetadataPair | Should -Not -BeNullOrEmpty -Because ('{0}: {1} should match a metadata attribute' -f $Method, $Path)
            }
        }
    }
}

AfterAll {
    $ModuleName = Get-ModuleName
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
}