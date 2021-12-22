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
# Connect commands.
New-Alias -Name 'Connect-NinjaRMM' -Value 'Connect-NinjaOne'
# Search commands.
New-Alias -Name 'Find-NinjaRMMDevices' -Value 'Find-NinjaOneDevices'
# Get entity commands.
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
# Get management commands.
New-Alias -Name 'Get-NinjaRMMDeviceDashboardURL' -Value 'Get-NinjaOneDeviceDashboardURL'
New-Alias -Name 'Get-NinjaRMMDeviceScriptingOptions' -Value 'Get-NinjaOneDeviceScriptingOptions'
New-Alias -Name 'Get-NinjaRMMInstaller' -Value 'Get-NinjaOneInstaller'
# Get report commands.
New-Alias -Name 'Get-NinjaRMMAntivirusStatusReport' -Value 'Get-NinjaOneAntivirusStatusReport'
New-Alias -Name 'Get-NinjaRMMAntivirusThreatsReport' -Value 'Get-NinjaOneAntivirusThreatsReport'
New-Alias -Name 'Get-NinjaRMMComputerSystemsReport' -Value 'Get-NinjaOneComputerSystemsReport'
New-Alias -Name 'Get-NinjaRMMCustomFieldsReport' -Value 'Get-NinjaOneCustomFieldsReport'
New-Alias -Name 'Get-NinjaRMMDeviceHealthReport' -Value 'Get-NinjaOneDeviceHealthReport'
New-Alias -Name 'Get-NinjaRMMDisksReport' -Value 'Get-NinjaOneDisksReport'
New-Alias -Name 'Get-NinjaRMMLoggedOnUsersReport' -Value 'Get-NinjaOneLoggedOnUsersReport'
New-Alias -Name 'Get-NinjaRMMOperatingSystemsReport' -Value 'Get-NinjaOneOperatingSystemsReport'
New-Alias -Name 'Get-NinjaRMMOSPatchesReport' -Value 'Get-NinjaOneOSPatchesReport'
New-Alias -Name 'Get-NinjaRMMOSPatchInstallsReport' -Value 'Get-NinjaOneOSPatchInstallsReport'
New-Alias -Name 'Get-NinjaRMMProcessorsReport' -Value 'Get-NinjaOneProcessorsReport'
New-Alias -Name 'Get-NinjaRMMRAIDControllersReport' -Value 'Get-NinjaOneRAIDControllersReport'
New-Alias -Name 'Get-NinjaRMMRAIDDrivesReport' -Value 'Get-NinjaOneRAIDDrivesReport'
New-Alias -Name 'Get-NinjaRMMSoftwareInventoryReport' -Value 'Get-NinjaOneSoftwareInventoryReport'
New-Alias -Name 'Get-NinjaRMMSoftwarePatchesReport' -Value 'Get-NinjaOneSoftwarePatchesReport'
New-Alias -Name 'Get-NinjaRMMSoftwarePatchInstallsReport' -Value 'Get-NinjaOneSoftwarePatchInstallsReport'
New-Alias -Name 'Get-NinjaRMMVolumesReport' -Value 'Get-NinjaOneVolumesReport'
New-Alias -Name 'Get-NinjaRMMWindowsServicesReport' -Value 'Get-NinjaOneWindowsServicesReport'
Export-ModuleMember -Function $Functions.BaseName -Alias *