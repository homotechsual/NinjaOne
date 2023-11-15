$Enums = @(Get-ChildItem -Path $PSScriptRoot\Classes\Enums -Include *.ps1 -Recurse)
# Import enums.
Write-Verbose "Discovered validators $($Enums | Out-String)"
foreach ($Enum in @($Enums)) {
    try {
        Write-Verbose "Importing class $($Enum.FullName)"
        . $Enum.FullName
    } catch {
        Write-Error -Message "Failed to import class $($Enum.FullName): $_"
    }
}
$Validators = @(Get-ChildItem -Path $PSScriptRoot\Classes\Validators -Include *.ps1 -Recurse)
# Import validators.
Write-Verbose "Discovered validators $($Validators | Out-String)"
foreach ($Validator in @($Validators)) {
    try {
        Write-Verbose "Importing class $($Validator.FullName)"
        . $Validator.FullName
    } catch {
        Write-Error -Message "Failed to import class $($Validator.FullName): $_"
    }
}
$Objects = @(Get-ChildItem -Path $PSScriptRoot\Classes\Object -Include *.ps1 -Recurse)
# Import objects.
Write-Verbose "Discovered objects $($Objects | Out-String)"
foreach ($Object in @($Objects)) {
    try {
        Write-Verbose "Importing class $($Object.FullName)"
        . $Object.FullName
    } catch {
        Write-Error -Message "Failed to import class $($Object.FullName): $_"
    }
}
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
    'us2' = 'https://us2.ninjarmm.com'
}
New-Alias -Name 'Connect-NinjaRMM' -Value 'Connect-NinjaOne'
New-Alias -Name 'Find-NinjaRMMDevices' -Value 'Find-NinjaOneDevices'
New-Alias -Name 'Get-NinjaOneBoards' -Value 'Get-NinjaOneTicketBoards'
New-Alias -Name 'Get-NinjaOneDevice' -Value 'Get-NinjaOneDevices'
New-Alias -Name 'Get-NinjaOneDeviceSoftwareProducts' -Value 'Get-NinjaOneSoftwareProducts'
New-Alias -Name 'Get-NinjaOneOrganizationCustomFields' -Value 'Get-NinjaOneOrganisationCustomFields'
New-Alias -Name 'Get-NinjaOneOrganizationDocuments' -Value 'Get-NinjaOneOrganisationDocuments'
New-Alias -Name 'Get-NinjaOneOrganizations' -Value 'Get-NinjaOneOrganisations'
New-Alias -Name 'New-NinjaOneOrganization' -Value 'New-NinjaOneOrganisation'
New-Alias -Name 'Set-NinjaOneOrganizationCustomFields' -Value 'Set-NinjaOneOrganisationCustomFields'
New-Alias -Name 'Set-NinjaOneWebhook' -Value 'Update-NinjaOneWebhook'
New-Alias -Name 'Update-NinjaOneDevice' -Value 'Set-NinjaOneDevice'
New-Alias -Name 'Update-NinjaOneDeviceApproval' -Value 'Set-NinjaOneDeviceApproval'
New-Alias -Name 'Update-NinjaOneDeviceCustomFields' -Value 'Set-NinjaOneDeviceCustomFields'
New-Alias -Name 'Update-NinjaOneDeviceMaintenance' -Value 'Set-NinjaOneDeviceMaintenance'
New-Alias -Name 'Update-NinjaOneLocation' -Value 'Set-NinjaOneLocation'
New-Alias -Name 'Update-NinjaOneLocationCustomFields' -Value 'Set-NinjaOneLocationCustomFields'
New-Alias -Name 'Update-NinjaOneNodeRolePolicyAssignment' -Value 'Set-NinjaOneNodeRolePolicyAssignment'
New-Alias -Name 'Update-NinjaOneOrganisation' -Value 'Set-NinjaOneOrganisation'
New-Alias -Name 'Update-NinjaOneOrganisationCustomFields' -Value 'Set-NinjaOneOrganisationCustomFields'
New-Alias -Name 'Update-NinjaOneOrganization' -Value 'Set-NinjaOneOrganisation'
New-Alias -Name 'Update-NinjaOneOrganizationCustomFields' -Value 'Set-NinjaOneOrganisationCustomFields'
New-Alias -Name 'Update-NinjaOneOrganizationDocument' -Value 'Update-NinjaOneOrganisationDocument'
New-Alias -Name 'Update-NinjaOneTicket' -Value 'Update-NinjaOneTicket'
New-Alias -Name 'Update-NinjaOneWindowsServiceConfiguration' -Value 'Set-NinjaOneWindowsServiceConfiguration'
Export-ModuleMember -Function $Functions.BaseName -Alias *