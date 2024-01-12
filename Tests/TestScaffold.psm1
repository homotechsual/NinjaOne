$Script:ModuleName = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty BaseName
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
    if (Get-Module -Name $Script:ModuleName) {
        Remove-Module $Script:ModuleName -Force
    }
    $ManifestPath = Get-ChildItem -Path '.\Source' -Filter '*.psd1' | Select-Object -ExpandProperty FullName
    Import-Module $ManifestPath -Verbose:$False
}

function Get-FunctionList {
    $Module = Get-Module -Name $Script:ModuleName
    $FunctionList = $Module.ExportedFunctions.Values
    return $FunctionList
}