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
$Attributes = @(Get-ChildItem -Path $PSScriptRoot\Classes\Attributes -Include *.ps1 -Recurse)
# Import attributes.
Write-Verbose "Discovered attributes $($Attributes | Out-String)"
foreach ($Attribute in @($Attributes)) {
    try {
        Write-Verbose "Importing class $($Attribute.FullName)"
        . $Attribute.FullName
    } catch {
        Write-Error -Message "Failed to import class $($Attribute.FullName): $_"
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