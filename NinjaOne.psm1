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
    'ca' = 'https://ca.ninjarmm.com'
}
New-Alias -Name 'Connect-NinjaRMM' -Value 'Connect-NinjaOne'
New-Alias -Name 'Find-NinjaRMMDevices' -Value 'Find-NinjaOneDevices'
New-Alias -Name 'Get-NinjaRMMActivities' -Value 'Get-NinjaOneActivities'
New-Alias -Name 'Get-NinjaRMMAlerts' -Value 'Get-NinjaOneAlerts'
New-Alias -Name 'Get-NinjaRMMDeviceCustomFields' -Value 'Get-NinjaOneDeviceCustomFields'
New-Alias -Name 'Get-NinjaRMMDeviceDisks' -Value 'Get-NinjaOneDeviceDisks'
New-Alias -Name 'Get-NinjaRMMDeviceLastLoggedOnUser' -Value 'Get-NinjaOneDeviceLastLoggedOnUser'
New-Alias -Name 'Get-NinjaRMMDeviceOSPatches' -Value 'Get-NinjaOneDeviceOSPatches'
New-Alias -Name 'Get-NinjaRMMDeviceOSPatchInstalls' -Value 'Get-NinjaOneDeviceOSPatchInstalls'
New-Alias -Name 'Get-NinjaRMMDeviceProcessors' -Value 'Get-NinjaOneDeviceProcessors'
New-Alias -Name 'Get-NinjaRMMDevices' -Value 'Get-NinjaOneDevices'
New-Alias -Name 'Get-NinjaRMMDeviceSoftwarePatches' -Value 'Get-NinjaOneDeviceSoftwarePatches'
New-Alias -Name 'Get-NinjaRMMDeviceSoftwarePatchInstalls' -Value 'Get-NinjaOneDeviceSoftwarePatchInstalls'
New-Alias -Name 'Get-NinjaRMMDeviceVolumes' -Value 'Get-NinjaOneDeviceVolumes'
New-Alias -Name 'Get-NinjaRMMDeviceWindowsServices' -Value 'Get-NinjaOneDeviceWindowsServices'
New-Alias -Name 'Get-NinjaRMMGroupMembers' -Value 'Get-NinjaOneGroupMembers'
New-Alias -Name 'Get-NinjaRMMGroups' -Value 'Get-NinjaOneGroups'
New-Alias -Name 'Get-NinjaRMMJobs' -Value 'Get-NinjaOneJobs'
New-Alias -Name 'Get-NinjaRMMLocations' -Value 'Get-NinjaOneLocations'
New-Alias -Name 'Get-NinjaRMMOrganisationDocuments' -Value 'Get-NinjaOneOrganisationDocuments'
New-Alias -Name 'Get-NinjaRMMOrganizationDocuments' -Value 'Get-NinjaOneOrganizationDocuments'
New-Alias -Name 'Get-NinjaOneOrganizationDocuments' -Value 'Get-NinjaOneOrganisationDocuments'
New-Alias -Name 'Get-NinjaRMMOrganisations' -Value 'Get-NinjaOneOrganisations'
New-Alias -Name 'Get-NinjaRMMOrganizations' -Value 'Get-NinjaOneOrganisations'
New-Alias -Name 'Get-NinjaOneOrganizations' -Value 'Get-NinjaOneOrganisations'
New-Alias -Name 'Get-NinjaRMMPolicies' -Value 'Get-NinjaOnePolicies'
New-Alias -Name 'Get-NinjaRMMRoles' -Value 'Get-NinjaOneRoles'
New-Alias -Name 'Get-NinjaRMMSoftwareProducts' -Value 'Get-NinjaOneSoftwareProducts'
New-Alias -Name 'Get-NinjaRMMTasks' -Value 'Get-NinjaOneTasks'
New-Alias -Name 'Get-NinjaRMMUsers' -Value 'Get-NinjaOneUsers'
New-Alias -Name 'Get-NinjaRMMDeviceDashboardURL' -Value 'Get-NinjaOneDeviceDashboardURL'
New-Alias -Name 'Get-NinjaRMMDeviceScriptingOptions' -Value 'Get-NinjaOneDeviceScriptingOptions'
New-Alias -Name 'Get-NinjaRMMInstaller' -Value 'Get-NinjaOneInstaller'
New-Alias -Name 'Get-NinjaRMMAntivirusStatus' -Value 'Get-NinjaOneAntivirusStatus'
New-Alias -Name 'Get-NinjaRMMAntivirusThreats' -Value 'Get-NinjaOneAntivirusThreats'
New-Alias -Name 'Get-NinjaRMMComputerSystems' -Value 'Get-NinjaOneComputerSystems'
New-Alias -Name 'Get-NinjaRMMCustomFields' -Value 'Get-NinjaOneCustomFields'
New-Alias -Name 'Get-NinjaRMMDeviceHealth' -Value 'Get-NinjaOneDeviceHealth'
New-Alias -Name 'Get-NinjaRMMDisks' -Value 'Get-NinjaOneDisks'
New-Alias -Name 'Get-NinjaRMMLoggedOnUsers' -Value 'Get-NinjaOneLoggedOnUsers'
New-Alias -Name 'Get-NinjaRMMOperatingSystems' -Value 'Get-NinjaOneOperatingSystems'
New-Alias -Name 'Get-NinjaRMMOSPatches' -Value 'Get-NinjaOneOSPatches'
New-Alias -Name 'Get-NinjaRMMOSPatchInstalls' -Value 'Get-NinjaOneOSPatchInstalls'
New-Alias -Name 'Get-NinjaRMMProcessors' -Value 'Get-NinjaOneProcessors'
New-Alias -Name 'Get-NinjaRMMRAIDControllers' -Value 'Get-NinjaOneRAIDControllers'
New-Alias -Name 'Get-NinjaRMMRAIDDrives' -Value 'Get-NinjaOneRAIDDrives'
New-Alias -Name 'Get-NinjaRMMSoftwareInventory' -Value 'Get-NinjaOneSoftwareInventory'
New-Alias -Name 'Get-NinjaRMMSoftwarePatches' -Value 'Get-NinjaOneSoftwarePatches'
New-Alias -Name 'Get-NinjaRMMSoftwarePatchInstalls' -Value 'Get-NinjaOneSoftwarePatchInstalls'
New-Alias -Name 'Get-NinjaRMMVolumes' -Value 'Get-NinjaOneVolumes'
New-Alias -Name 'Get-NinjaRMMWindowsServices' -Value 'Get-NinjaOneWindowsServices'
New-Alias -Name 'New-NinjaOneOrganization' -Value 'New-NinjaOneOrganisation'
New-Alias -Name 'Update-NinjaOneOrganizationDocument' -Value 'Update-NinjaOneOrganisationDocument'
Export-ModuleMember -Function $Functions.BaseName -Alias *