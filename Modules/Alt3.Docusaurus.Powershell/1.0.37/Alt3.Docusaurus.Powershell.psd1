@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Alt3.Docusaurus.Powershell.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.37'

    # ID used to uniquely identify this module
    GUID = '0a746d8a-f1f1-4064-967a-aad1877b2d63'

    # Author of this module
    Author = 'ALT3 B.V.'

    # Company or vendor of this module
    CompanyName = 'ALT3 B.V.'

    # Copyright statement for this module
    Copyright = 'Copyright (c) 2019-present ALT3 B.V.'

    # Description of the functionality provided by this module
    Description = '
Feature-rich websites for PowerShell Modules.

Live demo at https://docusaurus-powershell.vercel.app/
'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Supported PSEditions
    CompatiblePSEditions = @(
        'Core'
        'Desktop'
    )

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = 'New-DocusaurusHelp'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # A URL to the main website for this project.
            ProjectUri = 'https://www.github.com/alt3/Docusaurus.Powershell'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/alt3/Docusaurus.Powershell/blob/main/LICENSE.txt'

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                'Alt3'
                'Documentation'
                'Docusaurus'
                'Help'
                'PowerShell'
            )

            # A URL to an icon representing this module.
            IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/alt3/Docusaurus.Powershell/releases'

            # As required by the ModuleBuilder Build-Module command
            Prerelease = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/alt3/Docusaurus.Powershell/issues'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
