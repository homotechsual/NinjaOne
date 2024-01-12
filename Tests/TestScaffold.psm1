function Get-ModuleName {
    return 'NinjaOne'
}
function Get-Endpoints ([uri]$SchemaURI = 'https://oc.ninjarmm.com/apidocs-beta/NinjaRMM-API-v2.yaml') {
    $Endpoints = [System.Collections.Generic.List[PSObject]]::new()
    $ProgressPreference = 'SilentlyContinue'
    $SchemaObject = Invoke-WebRequest -Uri $SchemaURI -UseBasicParsing | ConvertFrom-Yaml
    $ProgressPreference = 'Continue'
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
    return $Endpoints
}

function Import-ModuleToBeTested {
    $ModuleName = Get-ModuleName
    if (Get-Module -Name $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    $ManifestPath = Get-ChildItem -Path (Join-Path -Path . -ChildPath 'Source') -Filter '*.psd1' | Select-Object -ExpandProperty FullName
    Import-Module $ManifestPath -Verbose:$False
}

function Get-FunctionList {
    $ModuleName = Get-ModuleName
    $Module = Get-Module -Name $ModuleName
    $Functions = $Module.ExportedFunctions.Values
    $FunctionList = foreach ($Function in $Functions) {
        $FunctionInfo = Get-Command -Name $Function.Name -Module $Module
        return $FunctionInfo
    }
    return $FunctionList
}