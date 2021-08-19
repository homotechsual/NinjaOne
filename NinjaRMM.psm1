#Requires -Version 7
$Functions = @(Get-ChildItem -Path $PSScriptRoot\Public\ -Include *.ps1 -Recurse) + @(Get-ChildItem -Path $PSScriptRoot\Private\ -Include *.ps1 -Recurse)
# Import functions.
Write-Verbose "Discovered functions $($Functions | Out-String)"
foreach ($Function in @($Functions)) {
    try {
        Write-Verbose "Importing function $($Function.FullName)"
        . $Function.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
}
[int32]$Script:NRAPIDefaultPageSize = 2000
[Hashtable]$Script:NRAPIInstances = @{
    'eu' = 'https://eu.ninjarmm.com'
    'oc' = 'https://oc.ninjarmm.com'
    'us' = 'https://app.ninjarmm.com'
}
New-Alias -Name 'Get-NinjaRMMOrganization' -Value 'Get-NinjaRMMOrganisation'
Export-ModuleMember -Function $Functions.BaseName -Alias *