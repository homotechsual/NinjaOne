<#
    .SYNOPSIS
        Schema test suite for the NinjaOne module.
#>
BeforeDiscovery {
    $ModuleName = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty BaseName
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    $ManifestPath = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty FullName
    Import-Module $ManifestPath -Verbose:$False
}
Describe ('{0} - Schema Completeness' -f $ModuleName) -Tags 'Module' {
    $SchemaURI = 'https://oc.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml'
    $Endpoints = [System.Collections.Generic.List[PSObject]]::new()
    $SchemaObject = Invoke-WebRequest -Uri $SchemaURI -UseBasicParsing | ConvertFrom-Yaml
    foreach ($Path in $SchemaObject.paths.GetEnumerator()) {
        foreach ($Method in $Path.Value.GetEnumerator()) {
            $Endpoints.Add(
                @{
                    Path = $Path.Name
                    Method = $Method.Name
                }
            )
        }
    }
    $ModuleName = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty BaseName
    $Module = Get-Module -Name $ModuleName
    $FunctionList = $Module.ExportedFunctions.Values
    Context 'Function <_>' -ForEach $FunctionList {
        $Commandlet = $_
        Write-Verbose ('Checking commandlet {0}' -f $_)
        $AST = Get-Content -Path ('function:/{0}' -f $_) -ErrorAction Ignore | Select-Object -ExpandProperty AST
        $MetadataFinder = [System.Func[System.Management.Automation.Language.Ast, bool]] { $args[0] -is [System.Management.Automation.Language.AttributeAst] -and $args[0].TypeName.Name -eq 'MetadataAttribute' -and $args[0].Parent -is [System.Management.Automation.Language.ParamBlockAst] }
        $MetadataElement = $AST.FindAll($MetadataFinder, $true)
        if ($MetadataElement[0].PSObject.Properties.Name -match 'PositionalArguments') {
            $PositionalArguments = $MetadataElement[0].PositionalArguments
        } else {
            $PositionalArguments = @{}
        }
        $StructuredMetadata = [System.Collections.Generic.List[hashtable]]::new()
        if ($PositionalArguments.Count -gt 0 -and ($PositionalArguments.Count % 2 -eq 0)) {
            for ($i = 0; $i -lt $PositionalArguments.Count; $i += 2) {
                $StructuredMetadata.Add(
                    [hashtable]@{
                        Endpoint = $PositionalArguments[$i].Value
                        Method = $PositionalArguments[$i + 1].Value
                    }
                )
            }
        }
        Context 'Metadata Attribute' -ForEach $MetadataElement {
            # Schema tests.
            ## Metadata attribute exists.
            It ('{0} should have a Metadata attribute' -f $Commandlet) {
                $_ | Should -Not -BeNullOrEmpty
            }
            ## Only one Metadata attribute exists.
            It ('{0} should have only one Metadata attribute' -f $Commandlet) {
                $_.Count | Should -Be 1
            }
            ## Metadata attribute has positional arguments.
            It ('{0} should have positional arguments' -f $Commandlet) {
                $_.PositionalArguments | Should -Not -BeNullOrEmpty
            }
        }
        Context 'Metadata Positional Arguments' -ForEach $MetadataElement -Skip:($MetadataElement.PositionalArguments.Count -eq 0) {
            ## Metadata attribute has a non-zero number of positional arguments.
            It ('{0} should have a non-zero number of positional arguments' -f $Commandlet) {
                $_.PositionalArguments.Count | Should -BeGreaterThan 0
            }            
            ## Metadata attribute has an even number of positional arguments.
            It ('{0} should have an even number of positional arguments' -f $Commandlet) -Skip:($PositionalArguments[0].Value -ceq 'IGNORE') {
                $_.PositionalArguments.Count % 2 | Should -Be 0
            }
        }
        Context 'Metadata Pair <Method>: <Endpoint>' -ForEach $StructuredMetadata -Skip:($StructuredMetadata.Count -eq 0) {
            It ('should match an endpoint') {
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
    $ModuleName = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty BaseName
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
}