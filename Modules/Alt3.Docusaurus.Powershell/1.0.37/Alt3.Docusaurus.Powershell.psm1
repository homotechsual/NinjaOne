#Region 'PREFIX' -1

Set-StrictMode -Version Latest
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop' # full stop on first error
#EndRegion 'PREFIX'
#Region '.\Private\CreateOrCleanFolder.ps1' -1

function CreateOrCleanFolder() {
    <#
        .SYNOPSIS
            Helper function to create a folder OR remove it's contents if it already exists.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path,
        [switch]$GroupByVerb
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    # create the folder if it does not exist
    if (-not(Test-Path -Path $Path)) {
        Write-Verbose "=> creating folder $($Path)"
        New-Item -Path $Path -ItemType Directory -Force

        return
    }

    # otherwise remove it's contents
    Write-Verbose "=> cleaning folder $($Path)"
    if ($GroupByVerb) {
        # remove all files except the category files, start with verb subfolders
        Remove-Item -Path (Join-Path -Path $Path -ChildPath */*.*) -Exclude @('_category_.yaml', '_category_.json')
        # now remove all files in the root folder except the category files
        Remove-Item -Path (Join-Path -Path $Path -ChildPath *.*) -Exclude @('_category_.yaml', '_category_.json')
    } else {
        Remove-Item -Path (Join-Path -Path $Path -ChildPath *.*)
    }
}
#EndRegion '.\Private\CreateOrCleanFolder.ps1' 32
#Region '.\Private\EscapeClosingCurlyBrackets.ps1' -1

function EscapeClosingCurlyBrackets() {
    <#
        .SYNOPSIS
            Escape closing curly brackets so `}` becomes `\}` (except inside codeblocks).

        .LINK
            https://regex101.com/r/T14SYa/1

        .LINK
            https://regex101.com/r/bI0yGB/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            $line = [regex]::replace($line, '}', '\}')

            $content[$i] = $line
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\EscapeClosingCurlyBrackets.ps1' 41
#Region '.\Private\EscapeOpeningCurlyBrackets.ps1' -1

function EscapeOpeningCurlyBrackets() {
    <#
        .SYNOPSIS
            Escape opening curly brackets so `{` becomes `\{` (except inside codeblocks).

        .LINK
            https://regex101.com/r/T14SYa/1

        .LINK
            https://regex101.com/r/bI0yGB/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            $line = [regex]::replace($line, '{', '\{')

            $content[$i] = $line
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\EscapeOpeningCurlyBrackets.ps1' 41
#Region '.\Private\GetCallerPreference.ps1' -1

function GetCallerPreference {
    <#
    .Synopsis
       Fetches "Preference" variable values from the caller's scope.
    .DESCRIPTION
       Script module functions do not automatically inherit their caller's variables, but they can be
       obtained through the $PSCmdlet variable in Advanced Functions.  This function is a helper function
       for any script module Advanced Function; by passing in the values of $ExecutionContext.SessionState
       and $PSCmdlet, GetCallerPreference will set the caller's preference variables locally.
    .PARAMETER Cmdlet
       The $PSCmdlet object from a script module Advanced Function.
    .PARAMETER SessionState
       The $ExecutionContext.SessionState object from a script module Advanced Function.  This is how the
       GetCallerPreference function sets variables in its callers' scope, even if that caller is in a different
       script module.
    .PARAMETER Name
       Optional array of parameter names to retrieve from the caller's scope.  Default is to retrieve all
       Preference variables as defined in the about_Preference_Variables help file (as of PowerShell 4.0)
       This parameter may also specify names of variables that are not in the about_Preference_Variables
       help file, and the function will retrieve and set those as well.
    .EXAMPLE
       GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Imports the default PowerShell preference variables from the caller into the local scope.
    .EXAMPLE
       GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','SomeOtherVariable'

       Imports only the ErrorActionPreference and SomeOtherVariable variables into the local scope.
    .EXAMPLE
       'ErrorActionPreference','SomeOtherVariable' | GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Same as Example 2, but sends variable names to the Name parameter via pipeline input.
    .INPUTS
       String
    .OUTPUTS
       None.  This function does not produce pipeline output.
    .LINK
       https://gallery.technet.microsoft.com/scriptcenter/Inherit-Preference-82343b9d
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]
        $SessionState,

        [Parameter(ParameterSetName = 'Filtered', ValueFromPipeline = $true)]
        [string[]]
        $Name
    )

    begin {
        $filterHash = @{}
    }

    process {
        if ($null -ne $Name) {
            foreach ($string in $Name) {
                $filterHash[$string] = $true
            }
        }
    }

    end {
        # List of preference variables taken from the about_Preference_Variables help file in PowerShell version 4.0

        $vars = @{
            'ErrorView'                     = $null
            'FormatEnumerationLimit'        = $null
            'LogCommandHealthEvent'         = $null
            'LogCommandLifecycleEvent'      = $null
            'LogEngineHealthEvent'          = $null
            'LogEngineLifecycleEvent'       = $null
            'LogProviderHealthEvent'        = $null
            'LogProviderLifecycleEvent'     = $null
            'MaximumAliasCount'             = $null
            'MaximumDriveCount'             = $null
            'MaximumErrorCount'             = $null
            'MaximumFunctionCount'          = $null
            'MaximumHistoryCount'           = $null
            'MaximumVariableCount'          = $null
            'OFS'                           = $null
            'OutputEncoding'                = $null
            'ProgressPreference'            = $null
            'PSDefaultParameterValues'      = $null
            'PSEmailServer'                 = $null
            'PSModuleAutoLoadingPreference' = $null
            'PSSessionApplicationName'      = $null
            'PSSessionConfigurationName'    = $null
            'PSSessionOption'               = $null

            'ErrorActionPreference'         = 'ErrorAction'
            'DebugPreference'               = 'Debug'
            'ConfirmPreference'             = 'Confirm'
            'WhatIfPreference'              = 'WhatIf'
            'VerbosePreference'             = 'Verbose'
            'WarningPreference'             = 'WarningAction'
        }


        foreach ($entry in $vars.GetEnumerator()) {
            if (([string]::IsNullOrEmpty($entry.Value) -or -not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($entry.Value)) -and
                ($PSCmdlet.ParameterSetName -eq 'AllVariables' -or $filterHash.ContainsKey($entry.Name))) {
                $variable = $Cmdlet.SessionState.PSVariable.Get($entry.Key)

                if ($null -ne $variable) {
                    if ($SessionState -eq $ExecutionContext.SessionState) {
                        Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                    }
                    else {
                        $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                    }
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filtered') {
            foreach ($varName in $filterHash.Keys) {
                if (-not $vars.ContainsKey($varName)) {
                    $variable = $Cmdlet.SessionState.PSVariable.Get($varName)

                    if ($null -ne $variable) {
                        if ($SessionState -eq $ExecutionContext.SessionState) {
                            Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                        }
                        else {
                            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                        }
                    }
                }
            }
        }

    } # end

} # function GetCallerPreference
#EndRegion '.\Private\GetCallerPreference.ps1' 141
#Region '.\Private\GetCustomEditUrl.ps1' -1

function GetCustomEditUrl() {
    <#
        .SYNOPSIS
            Returns the `custom_edit_url` for the given .md file.

        .DESCRIPTION
            Generates a URL pointing to the PowerShell source file that was used to generate the markdown file.

        .NOTES
            - passing string `null` will return string `null`
            - URLs for non-monolithic modules point to a .ps1 file with same name as the markdown file
            - URLs for monolithic modules will always point to a .psm1 with same name as passed module
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Module,
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [switch]$Monolithic
    )

    # return $null so Docusaurus will not render the `Edit this page` button
    if (-not $EditUrl) {
        return
    }

    # if string "null" was passed explicitely, return as-is
    if ($EditUrl -eq "null") {
        return "null"
    }

    # removing trailing slashes
    $EditUrl = $EditUrl.TrimEnd("/")

    # point to the function source file for non-monlithic modules
    if (-not $Monolithic) {
        $command = [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile)

        return $EditUrl + '/' + $command + ".ps1"
    }

    # point to the module source file for monolithic modules
    if (Test-Path $Module) {
        $Module = [System.IO.Path]::GetFileNameWithoutExtension($Module)
    }

    return $EditUrl + '/' + $Module + ".psm1"
}
#EndRegion '.\Private\GetCustomEditUrl.ps1' 48
#Region '.\Private\HtmlEncodeGreaterThanBrackets.ps1' -1

function HtmlEncodeGreaterThanBrackets() {
    <#
        .SYNOPSIS
            Html encode platyPS generated `\>` brackets (except inside codeblocks).

        .LINK
            https://regex101.com/r/T14SYa/1

        .LINK
            https://regex101.com/r/bI0yGB/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            $line = [regex]::replace($line, '([a-zA-Z]:)\\\>', '$1\\&gt;') # something special for C:\>
            $line = [regex]::replace($line, '\\\>', '&gt;')

            $content[$i] = $line
        }

        if ($codeblock -eq $True) {
            $content[$i] = [regex]::replace($line, '(?<![a-zA-Z|\`]:)\\\>', '>')
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\HtmlEncodeGreaterThanBrackets.ps1' 46
#Region '.\Private\HtmlEncodeLessThanBrackets.ps1' -1

function HtmlEncodeLessThanBrackets() {
    <#
        .SYNOPSIS
            Html encode platyPS generated `\<` brackets (except inside codeblocks).

        .LINK
            https://regex101.com/r/khoBBE/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        } elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $False) {
            $content[$i] = [regex]::replace($line, '(\\\\\\\<|\\\<)', '&lt;')
        }

        if ($codeblock -eq $True) {
            $content[$i] = [regex]::replace($line, '(\\\\\\\<|\\\<)', '<')
        }

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\HtmlEncodeLessThanBrackets.ps1' 39
#Region '.\Private\IndentLineBelowOpeningBracket.ps1' -1

function IndentLineBelowOpeningBracket() {
    <#
        .SYNOPSIS
            Indent line directly below line with opening curly bracket.

        .NOTES
            Because PlatyPS sometimes gets the indentation wrong with complex examples.

        .LINK
            https://regex101.com/r/eMCf3E/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('({\n)([^\s+].+)')

    $content = $content -replace $regex, "`$1    `$2"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\IndentLineBelowOpeningBracket.ps1' 29
#Region '.\Private\IndentLineWithOpeningBracket.ps1' -1

function IndentLineWithOpeningBracket() {
    <#
        .SYNOPSIS
            Corrects indentation for lines with opening curly brackets and incorrect indentation
            by comparing indentation of the line below (and recalculating if things are amiss).

        .NOTES
            Skips correcting if the line below has 4-space indentation

        .NOTES
            The regex gives us three useful matching groups:
            - Group 1 is the full first without the line feed
            - Group 2 is the full second line without the line feed
            - Group 3 contains the leading spaces of the second line

        .LINK
            https://regex101.com/r/WYGbfX/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('(?m)^([^\s].+{)\n((\s+)(.+))')

    $callback = {
        param($match)

        # do nothing if next line starts with 4 spaces
        if ($match.Groups[3].Value.Length -eq 4) {
            return $match
        }

        # divide spacing of next line by 2 and use that as correct indentation
        [string]$fixedIndentation = ""
        $fixedIndentation.PadRight(($match.Groups[3].Value.Length / 2 - 1), " ")

        $fixedIndentation + $match.Groups[1] + "`n" + $match.Groups[2]
    }

    $content = $regex.replace($content, $callback)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\IndentLineWithOpeningBracket.ps1' 51
#Region '.\Private\InitializeTempFolder.ps1' -1

function InitializeTempFolder() {
    <#
        .SYNOPSIS
            Creates the temp folder and the `debug.info` file.

        .DESCRIPTION
            The temp folder is where all work is done before the enriched mdx files are copied
            to the docusaurus sidebar folder. We use this approach to support future debugging
            as it will be near impossible to reason about bugs without looking at the PlatyPS
            generated source files, knowing which PowerShell version was used etc.

        .NOTES
            Ideally, we should also log used module versions for Alt3, PlatyPS and Pester.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    # create the folder
    Write-Verbose "Initializing temp folder:"
    CreateOrCleanFolder -Path $Path

    # log the module parameters used for this run
    $ParameterList = (Get-Command -Name New-DocusaurusHelp).Parameters
    $parameterHash = [ordered]@{ }

    $ParameterList.Keys | ForEach-Object {
        $variable = (Get-Variable -Name $_ -ErrorAction SilentlyContinue)

        if ($null -eq $variable) { # Verbose, ErrorAction, etc.
            return
        }

        $parameterHash.Add($_, $variable.Value)
    }

    # create the hash with debug information
    $debugInfo = [ordered]@{
        ModuleParameters = $parameterHash
        PSVersionTable   = $PSVersionTable
    } | ConvertTo-Json -Depth 5

    # create the debug file
    Write-Verbose "=> preparing debug file"
    $debugFile = Join-Path -Path $Path -ChildPath "debug.json"
    $fileEncoding = New-Object System.Text.UTF8Encoding $False

    [System.IO.File]::WriteAllLines($debugFile, $debugInfo, $fileEncoding)
}
#EndRegion '.\Private\InitializeTempFolder.ps1' 52
#Region '.\Private\InsertFinalNewline.ps1' -1

function InsertFinalNewline() {
    <#
        .SYNOPSIS
            Adds a traling newline to the end of the file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content ($content + "`n")
}
#EndRegion '.\Private\InsertFinalNewline.ps1' 15
#Region '.\Private\InsertPowerShellMonikers.ps1' -1

function InsertPowerShellMonikers() {
    <#
        .SYNOPSIS
            Adds the `powershell` moniker to all code blocks without a language moniker.

        .NOTES
            We need to do this because PlatyPS does (yet) not add the moniker itself
            => https://github.com/PowerShell/platyPS/issues/475

        .LINK
            https://regex101.com/r/Jpo9AL/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = '(```)\n((?:(?!```)[\s\S])+)(```)\n'

    $content = [regex]::replace($content, $regex, '```powershell' + "`n" + '$2```' + "`n")

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\InsertPowerShellMonikers.ps1' 26
#Region '.\Private\InsertUserMarkdown.ps1' -1

function InsertUserMarkdown() {
    <#
        .SYNOPSIS
            Inserts user provided markdown directly above OR below the PlatyPS generated markdown.

        .NOTES
            Will use file content as markdown if $Markdown resolves to a file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$Markdown,
        [Parameter(Mandatory = $True)][ValidateSet('Prepend', 'Append')][string]$Mode
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    # use file content as markdown
    if ( $(try { Test-Path $Markdown.Trim() } catch { $false }) ) {
        $Markdown = Get-Content -Path $Markdown -Raw
    }

    # remove any leading or trailing newlines
    $Markdown = $Markdown.TrimStart()
    $Markdown = $Markdown.TrimEnd()

    # convert CRLF to LF
    $Markdown = $Markdown -replace "`r`n", "`n"

    # insert user markdown
    if ($Mode -eq "Prepend") {
        Write-Verbose "=> prepending user markdown"

        $regex = '(---\n\n)'
        $content = $content -replace $regex, "---`n`n$Markdown`n`n"
    }
    else {
        Write-Verbose "=> appending user markdown"

        $content = "$content`n`n$Markdown`n`n"
    }

    # create new file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\InsertUserMarkdown.ps1' 47
#Region '.\Private\NewMarkdownExample.ps1' -1

function NewMarkdownExample() {
    <#
        .SYNOPSIS
            Generates a new markdown example block.

        .NOTES
            PowerShell language monicker inserted by the SetPowerShellMoniker function.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Header,
        [Parameter(Mandatory = $True)][string]$Code,
        [Parameter(Mandatory = $False)][string]$Description = $null
    )

    $example = "$Header`n"
    $example += '```' + "`n"
    $example += $Code
    $example += '```' + "`n"

    if ([string]::IsNullOrEmpty($Description)) {
        $example += "`n"
    } else {
        $example += "`n$Description`n"
    }

    return $example
}
#EndRegion '.\Private\NewMarkdownExample.ps1' 28
#Region '.\Private\NewSidebarIncludeFile.ps1' -1

function NewSidebarIncludeFile() {
    <#
        .SYNOPSIS
            Generates a `.js` file holding an array with all .mdx 'ids` to be imported in Docusaurus `sidebar.js`.

        .LINK
            https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ff730948(v=technet.10)
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Sidebar',
        Justification = 'False positive as rule does not scan child scopes')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)][string]$TempFolder,
        [Parameter(Mandatory = $True)][string]$OutputFolder,
        [Parameter(Mandatory = $True)][string]$Sidebar,
        [Parameter(Mandatory = $True)][Object]$MarkdownFiles,
        [Parameter(Mandatory = $True)][Version]$Alt3Version,
        [switch]$GroupByVerb,
        [Parameter(Mandatory = $False)][Object]$UsedVerbs = $null
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose 'Generating docusaurus.sidebar.js'

    # generate a list of PowerShell commands by stripping .md from the generated PlatyPs files then group by verb if needed
    $commands = [System.Collections.Generic.List[string]]::new()
    foreach ($MarkdownFile in $MarkdownFiles) {
        if ($GroupByVerb) {
            $parentPath = Split-Path $MarkdownFile -Parent
            $verbFolder = Split-Path $parentPath -Leaf
            $docParentPath = "'$Sidebar/" + $verbFolder
            $docPath = "$docParentPath/" + [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile) + "'"
        } else {
            $docPath = "'$Sidebar/" + [System.IO.Path]::GetFileNameWithoutExtension($MarkdownFile) + "'"
        }
        $commands.Add($docPath)
    }

    Write-Verbose "=> $($commands.Count) commands found"

    # generate content using Here-String block
    $content = @"
/**
 * Import this file in your Docusaurus ``sidebars.js`` file.
 *
 * Auto-generated by Alt3.Docusaurus.Powershell $($Alt3Version).
 *
 * Copyright (c) 2019-present, ALT3 B.V.
 *
 * Licensed under the MIT license.
 */

module.exports = [
    $($commands -Join ",`n    ")
];
"@

    # create the temp file
    $fileName = 'docusaurus.sidebar.js'
    $tempFile = Join-Path -Path $tempFolder -ChildPath $fileName
    $fileEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($tempFile, $content, $fileEncoding)

    # copy to the sidebar folder, convert relative output folder to absolute if needed
    if (-Not([System.IO.Path]::IsPathRooted($OutputFolder))) {
        $outputFolder = Join-Path "$(Get-Location)" -ChildPath $OutputFolder
    }
    $sidebarFile = Join-Path -Path $outputFolder -ChildPath $fileName
    Write-Verbose "=> writing sidebar to $($sidebarFile)"
    Copy-Item -Path $tempFile -Destination $sidebarFile
}
#EndRegion '.\Private\NewSidebarIncludeFile.ps1' 73
#Region '.\Private\ReadFile.ps1' -1

function ReadFile() {
    <#
        .SYNOPSIS
            Retrieves raw markdown from file.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$Raw
    )

    # file content as string
    if ($Raw) {
        return (Get-Content -Path $MarkdownFile.FullName -Raw).TrimEnd()
    }

    # file content as array of lines
    Get-Content -Path $MarkdownFile.FullName
}
#EndRegion '.\Private\ReadFile.ps1' 19
#Region '.\Private\RemoveBlankLinesAboveClosingBracket.ps1' -1

function RemoveBlankLinesAboveClosingBracket() {
    <#
        .SYNOPSIS
            Removes blank lines ABOVE lines ending with a closing curly bracket.

        .NOTES
            Required so following steps can trust formatting.

        .LINK
            https://regex101.com/r/jMBHcT/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines above closing curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('(\n\n+\s+}|\n\n})')

    $content = $content -replace $regex, "`n}"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\RemoveBlankLinesAboveClosingBracket.ps1' 29
#Region '.\Private\RemoveBlankLinesBelowOpeningBracket.ps1' -1

function RemoveBlankLinesBelowOpeningBracket() {
    <#
        .SYNOPSIS
            Removes blank lines below lines ending with an opening curly bracket.

        .NOTES
            Required so following steps can trust formatting.

        .LINK
            https://regex101.com/r/FAdpGh/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Removing blank lines below opening curly bracket"

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('({\n+\n)')

    $content = $content -replace $regex, "{`n"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\RemoveBlankLinesBelowOpeningBracket.ps1' 29
#Region '.\Private\RemoveFile.ps1' -1

function RemoveFile() {
    <#
        .SYNOPSIS
            Helper function to remove a file if it exists.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "=> removing $Path"

    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Force
    }
}
#EndRegion '.\Private\RemoveFile.ps1' 18
#Region '.\Private\RemoveParameters.ps1' -1

<#
.SYNOPSIS
    Removes specified parameters from the PARAMETERS section of a markdown file.

.DESCRIPTION
    This function reads a markdown file and removes parameter sections matching the
    names provided in the RemoveParameters array. It identifies parameter headers
    in the format '### -ParameterName' and removes the entire parameter section
    including its description.

.PARAMETER MarkdownFile
    System.IO.FileInfo object for the markdown file

.PARAMETER RemoveParameters
    Array of parameter names to remove (with or without leading dash)
#>
function RemoveParameters {
    [CmdletBinding()]
    param(
        [System.IO.FileInfo]$MarkdownFile,
        [array]$RemoveParameters
    )

    if ($RemoveParameters.Count -eq 0) {
        return
    }

    Write-Verbose "  [x] removing parameters: $($RemoveParameters -join ', ')"

    $content = ReadFile -MarkdownFile $MarkdownFile

    # Normalize parameter names to include leading dash
    $normalizedParams = $RemoveParameters | ForEach-Object {
        if ($_ -notlike '-*') {
            "-$_"
        } else {
            $_
        }
    }

    $lines = $content -split "`n"
    $outputLines = [System.Collections.Generic.List[string]]::new()
    $skipMode = $false
    $i = 0

    while ($i -lt $lines.Count) {
        $line = $lines[$i]

        # Check if this is a parameter header we should remove
        if ($line -match '^###\s+(-\w+)') {
            $paramName = $Matches[1]
            if ($paramName -in $normalizedParams) {
                Write-Verbose "    - Removing parameter: $paramName"
                $skipMode = $true
                $i++
                continue
            }
        }

        # Check if we've reached the next section or parameter
        if ($skipMode) {
            if ($line -match '^###?\s+' -or $line -match '^##\s+') {
                # We've reached the next section, stop skipping
                $skipMode = $false
            } else {
                # Still in the parameter we're removing, skip this line
                $i++
                continue
            }
        }

        $outputLines.Add($line)
        $i++
    }

    $newContent = $outputLines -join "`n"
    WriteFile -MarkdownFile $MarkdownFile -Content $newContent
}
#EndRegion '.\Private\RemoveParameters.ps1' 79
#Region '.\Private\ReplaceExamples.ps1' -1

function ReplaceExamples() {
    <#
        .SYNOPSIS
            Replace PlatyPS generated code block examples.

        .DESCRIPTION
            Replaces custom fenced code blocks and placeholder examples, otherwise uses PlatyPS generated defaults.

            See link below for a detailed description of the determination process.

        .LINK
            https://github.com/alt3/Docusaurus.Powershell/issues/14#issuecomment-568552556
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "NoPlaceHolderExamples",
        Justification = 'False positive as rule does not scan child scopes')]
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$NoPlaceHolderExamples
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw
    [string]$newExamples = ""

    # ---------------------------------------------------------------------
    # extract all EXAMPLE nodes
    # https://regex101.com/r/y4UxP8/7
    # ---------------------------------------------------------------------
    $regexExtractExamples = [regex]'### (EXAMPLE|Example) [0-9][\s\S]*?(?=\n### EXAMPLE|\n## PARAMETERS|$)'
    $examples = $regexExtractExamples.Matches($content)

    if ($examples.Count -eq 0) {
        Write-Warning "Unable to find any EXAMPLE nodes. Please check your Get-Help definitions before filing an issue!"
    }

    # process each EXAMPLE node
    $examples | ForEach-Object {
        $example = $_

        # ---------------------------------------------------------------------
        # do not modify if it's a PlatyPS placeholder example
        # https://regex101.com/r/WOQL0l/4
        # ---------------------------------------------------------------------
        $regexPlatyPlaceholderExample = [regex]::new('{{ Add example code here }}')
        if ($example -match $regexPlatyPlaceholderExample) {

            if ($NoPlaceHolderExamples) {
                Write-Verbose "=> Example 1: PlatyPS Placeholder (dropping)"
                return
            }

            Write-Verbose "=> Example 1: PlatyPS Placeholder (keeping)"
            $newExamples += "$example`n"
            return
        }

        # ---------------------------------------------------------------------
        # PowerShell 6: re-construct Code Fenced example
        # - https://regex101.com/r/lHdZHM/6 => without a description
        # - https://regex101.com/r/CGjQco/3 => with a description
        # ---------------------------------------------------------------------
        $regexPowerShell6TripleCodeFence = [regex]::new('(### EXAMPLE ([0-9|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n```\n)\n([\s\S]*?)\\`\\`\\`(\n\n|\n)([\s\S]*|\n)')

        if ($example -match $regexPowerShell6TripleCodeFence) {
            $header = $matches[1]
            $code = $matches[5]
            $description = $matches[7]

            Write-Verbose "=> $($header): Triple Code Fence (PowerShell 6 and lower)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description
            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # PowerShell 7: re-construct PlatyPS Paired Code Fences example
        # - https://regex101.com/r/FRA139/1 => without a description
        # - https://regex101.com/r/YIIwUs/5 => with a description
        # ---------------------------------------------------------------------
        $regexPowerShell7PairedCodeFences = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n)([\s\S]*?)```\n```(\n\n|\n)([\s\S]*|\n)')

        if ($example -match $regexPowerShell7PairedCodeFences) {
            $header = $matches[1]
            $code = $matches[5]
            $description = $matches[7]

            Write-Verbose "=> $($header): Paired Code Fences (PowerShell 7)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description
            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # PowerShell 7:  re-construct non-adjacent Code Fenced example
        # - https://regex101.com/r/kLr98l/3 => without a description
        # - https://regex101.com/r/eJH4cQ/6 => with a complex description
        # ---------------------------------------------------------------------
        $regexPowerShell7NonAdjacentCodeBlock = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n(```\n(```|```ps|```posh|```powershell)\n)([\s\S]*?)\\`\\`\\`(\n\n([\s\S]*)|\n)')

        if ($example -match $regexPowerShell7NonAdjacentCodeBlock) {
            $header = $matches[1]
            $code = $matches[5] -replace ('```' + "`n"), ''
            $description = $matches[7]

            Write-Verbose "=> $($header): Non-Adjacent Code Block (PowerShell 7)"

            $newExample = NewMarkdownExample -Header $header -Code $code -Description $description

            $newExamples += $newExample
            return
        }

        # ---------------------------------------------------------------------
        # no matches so we simply use the unaltered PlatyPS generated example
        # - https://regex101.com/r/rllmTj/1 => without a decription
        # - https://regex101.com/r/kTH75U/1 => with a description
        # ---------------------------------------------------------------------
        $regexPlatyPsDefaults = [regex]::new('(### EXAMPLE ([0-9]|[0-9]+))\n```\n([\s\S]*)```\n([\s\S]*)')

        if ($example -match $regexPlatyPsDefaults) {
            $header = $matches[1]
            $code = $matches[5] -replace ('```' + "`n"), ''
            $description = $matches[7]

            Write-Verbose "=> $($header): PlatyPS Default (all PowerShell versions)"

            $newExamples += "$example`n"
            return
        }

        # we should never reach this point
        Write-Warning "Unsupported code block detected, please file an issue containing the error message below at https://github.com/alt3/Docusaurus.Powershell/issues"
        Write-Warning $example
    }

    # replace EXAMPLES section in content with updated examples
    # https://regex101.com/r/8OEW0w/1/
    $regex = '## EXAMPLES\n[\s\S]+## PARAMETERS'
    $newExamples = $newExamples.Replace('$', '$$') # Escape $ characters in new examples (https://github.com/alt3/Docusaurus.Powershell/pull/98)
    $replacement = "## EXAMPLES`n`n$($newExamples)## PARAMETERS"
    $content = [regex]::replace($content, $regex, $replacement)

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\ReplaceExamples.ps1' 149
#Region '.\Private\ReplaceFrontMatter.ps1' -1

function ReplaceFrontMatter() {
    <#
        .SYNOPSIS
            Replaces PlatyPS generated front matter with Docusaurus compatible front matter.

        .LINK
            https://www.apharmony.com/software-sagacity/2014/08/multi-line-regular-expression-replace-in-powershell/
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $False)][string]$CustomEditUrl,
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [Parameter(Mandatory = $False)][array]$MetaKeywords,
        [Parameter(Mandatory = $False)][string]$CustomShortTitle,
        [switch]$HideTitle,
        [switch]$HideTableOfContents
    )

    $powershellCommandName = [System.IO.Path]::GetFileNameWithoutExtension($markdownFile.Name)

    # prepare front matter
    $newFrontMatter = [System.Collections.ArrayList]::new()
    $newFrontMatter.Add("---") | Out-Null
    $newFrontMatter.Add("id: $($powershellCommandName)") | Out-Null

    # Use custom short title if provided, otherwise use the command name
    $titleToUse = if ($CustomShortTitle) { $CustomShortTitle } else { $powershellCommandName }
    $newFrontMatter.Add("title: $($titleToUse)") | Out-Null

    if ($MetaDescription) {
        $description = [regex]::replace($MetaDescription, '%1', $powershellCommandName)
        $newFrontMatter.Add("description: $($description)") | Out-Null
    }

    if ($MetaKeywords) {
        $newFrontMatter.Add("keywords:") | Out-Null
        $MetaKeywords | ForEach-Object {
            $newFrontMatter.Add("  - $($_)") | Out-Null
        }
    }
    $newFrontMatter.Add("hide_title: $(if ($HideTitle) {"true"} else {"false"})") | Out-Null
    $newFrontMatter.Add("hide_table_of_contents: $(if ($HideTableOfContents) {"true"} else {"false"})") | Out-Null

    if ($CustomEditUrl) {
        $newFrontMatter.Add("custom_edit_url: $($CustomEditUrl)") | Out-Null
    }

    $newFrontMatter.Add("---") | Out-Null

    # translate front matter to a string and replace CRLF with LF
    $newFrontMatter = ($newFrontMatter| Out-String) -replace "`r`n", "`n"

    # replace front matter
    $content = ReadFile -MarkdownFile $MarkdownFile -Raw
    $regex = "(?sm)^(---)(.+)^(---).$\n"
    $content = $content -replace $regex, $newFrontMatter

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\ReplaceFrontMatter.ps1' 61
#Region '.\Private\ReplaceHeader1.ps1' -1

function ReplaceHeader1() {
    <#
        .SYNOPSIS
            Removes the markdown H1 element OR preprends it with an extra newline if the -KeepHeader1 switch is used.

        .LINK
            https://regex101.com/r/hnVQvQ/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [switch]$KeepHeader1
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = '(---)(\n\n|\n)(# .+)'

    if ($KeepHeader1) {
        $content = $content -replace $regex, ("---`n`n" + '$3') # prepend newline (for first match only)
    } else {
        $content = $content -replace $regex, '---' # remove line (for first match only)
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\ReplaceHeader1.ps1' 27
#Region '.\Private\SeparateMarkdownHeadings.ps1' -1

function SeparateMarkdownHeadings() {
    <#
        .SYNOPSIS
            Adds a blank line after markdown headers IF they are directly followed by an adjacent non-blank lines.

        .NOTES
            This ensures the markdown format will match with e.g. Prettier which in turn will
            prevent getting format-change suggestions when running e.g. > Visual Studio Code
            > CTRL+SHIFT+P > Format Document.

        .LINK
            https://regex101.com/r/llYF0H/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Write-Verbose "Inserting blank line beneath non-separated headers."

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $regex = [regex]::new('(?m)^\n^([#]#{0,5}[a-z]*\s.+)\n(.+)')

    $content = $content -replace $regex, "`n`$1`n`n`$2"

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\SeparateMarkdownHeadings.ps1' 31
#Region '.\Private\SetLfLineEndings.ps1' -1

function SetLfLineEndings() {
    <#
        .SYNOPSIS
            Replaces all CRLF line endings with LF so we can consitently use/expect `n when regexing etc.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    $content = ($content -replace "`r`n", "`n") + "`n"

    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\SetLfLineEndings.ps1' 16
#Region '.\Private\UnescapeInlineCode.ps1' -1

function UnescapeInlineCode() {
    <#
        .SYNOPSIS
            Unescapes special characters inside single backtick `inline code`.

        .NOTES
            Please note that platyPS generated `\\\>` is not preserved when importing the
            file content. This means we have no way to support `\>` inside inline code.

        .LINK
            https://regex101.com/r/80DpiH/1
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )


    $content = ReadFile -MarkdownFile $MarkdownFile

    $i = 0
    [bool]$codeblock = $False

    foreach ($line in $content) {
        if ($line -match '```' -and $codeblock -eq $False) {
            $codeblock = $True
        }
        elseif ($line -match '```' -and $codeblock -eq $True) {
            $codeBlock = $False
        }

        if ($codeblock -eq $True) {
            $i++
            continue # do nothing when inside a codeblock
        }

        $regex = [regex]::new('\`[^`].*?\`')

        if (-not($line -match $regex)) {
            $i++
            continue
        }

        # Process < brackets first
        $inlineCodes = $regex.Matches($line)

        $inlineCodes  | Foreach-Object {
            $inlineCode = $_.Value

            $newInlineCode = $inlineCode

            # we first unescape all < brackets
            if (-not($newInlineCode -match '\\\\\\\<')) {
                $newInlineCode = $newInlineCode -replace ('\\\<', '<')
                $line = $line.replace($inlineCode, $newInlineCode)
            }

            # remaining escaped < must be part of the inline code content (and thus not escaped)
            if ($newInlineCode -match '\\\\\\\<') {
                $newInlineCode = $newInlineCode -replace ('\\\\\\\<', '\<KEEP')
                $line = $line.replace($inlineCode, $newInlineCode)
            }
        }

        $line = $line.replace('\<KEEP', '\<')

        $content[$i] = $line.replace('\>', '>') # see .NOTES

        $i++
    }

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\UnescapeInlineCode.ps1' 74
#Region '.\Private\UnescapeSpecialChars.ps1' -1

function UnescapeSpecialChars() {
    <#
        .SYNOPSIS
            Replaces platyPS escaped special chars with the un-escaped version.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile
    )

    $content = ReadFile -MarkdownFile $MarkdownFile -Raw

    # regular
    $content = [regex]::replace($content, '\\`', '`') # backticks: `
    $content = [regex]::replace($content, '\\\[', '[') # square opening brackets: [
    $content = [regex]::replace($content, '\\\]', ']') # square closing brackets: ]

    # specific cases
    $content = [regex]::replace($content, '\\\\\\>', '\>') # as used in eg: PS C:\>

    # replace file
    WriteFile -MarkdownFile $MarkdownFile -Content $content
}
#EndRegion '.\Private\UnescapeSpecialChars.ps1' 23
#Region '.\Private\WriteFile.ps1' -1

function WriteFile() {
    <#
        .SYNOPSIS
            Writes content to a UTF-8 file without BOM using LF as newlines.
    #>
    param(
        [Parameter(Mandatory = $True)][System.IO.FileSystemInfo]$MarkdownFile,
        [Parameter(Mandatory = $True)]$Content
    )

    # replace file (UTF-8 without BOM)
    $fileEncoding = New-Object System.Text.UTF8Encoding $False

    # when content is a string
    if (($Content.GetType().Name -eq "String")) {
        [System.IO.File]::WriteAllText($MarkdownFile.FullName, $Content, $fileEncoding)

        return
    }

    # when content is an array
    [System.IO.File]::WriteAllLines($MarkdownFile.FullName, $Content, $fileEncoding)
}
#EndRegion '.\Private\WriteFile.ps1' 24
#Region '.\Public\New-DocusaurusHelp.ps1' -1

function New-DocusaurusHelp() {
    <#
        .SYNOPSIS
            Generates Get-Help documentation in Docusaurus compatible `.mdx` format.

        .DESCRIPTION
            The `New-DocusaurusHelp` cmdlet generates Get-Help documentation in "Docusaurus
            compatible" format by creating an `.mdx` file for each command exported by
            the module, enriched with command-specific front matter variables.

            Also creates a `sidebar.js` file for simplified integration into the Docusaurus sidebar menu.

        .OUTPUTS
            System.Object

        .EXAMPLE
            New-DocusaurusHelp -Module Alt3.Docusaurus.Powershell

            This example uses default settings to generate a Get-Help page for each command exported by
            the Alt3.Docusaurus.Powershell module.

        .EXAMPLE
            ```
            $parameters = @{
                Module = "Alt3.Docusaurus.Powershell"
                DocsFolder = "D:\my-project\docs"
                Sidebar = "commands"
                Exclude = @(
                    "Get-SomeCommand"
                )
                MetaDescription = 'Help page for the PowerShell command "%1"'
                MetaKeywords = @(
                    "PowerShell"
                    "Documentation"
                )
            }

            New-DocusaurusHelp @parameters
            ```

            This example uses
            [splatting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting)
            to override default settings.

            See the list of Parameters below for all available overrides.

        .PARAMETER Module
            Specifies the module this cmdlet will generate Docusaurus documentation for.

            You may specify a module name, a `.psd1` file or a `.psm1` file.

        .PARAMETER PlatyPSMarkdownPath
            Specifies a path containing already prepared PlatyPS markdown files for processing.

            If not provided, this function will generate the necessary files as required.

        .PARAMETER DocsFolder
            Specifies the absolute or relative **path** to the Docusaurus `docs` folder.

            Optional, defaults to `docusaurus/docs`, case sensitive.

        .PARAMETER Sidebar
            Specifies the **name** of the docs subfolder in which the `.mdx` files will be created.

            Optional, defaults to `commands`, case sensitive.

        .PARAMETER Exclude
            Optional array with command names to exclude.

        .PARAMETER MetaDescription
            Optional string that will be inserted into Docusaurus front matter to be used as html meta tag 'description'.

            If placeholder `%1` is detected in the string, it will be replaced by the command name.

        .PARAMETER MetaKeywords
            Optional array of keywords inserted into Docusaurus front matter to be used as html meta tag `keywords`.

        .PARAMETER PrependMarkdown
            Optional string containing raw markdown **OR** path to a markdown file.

            Markdown will be inserted in all pages, directly above the PlatyPS generated markdown.

        .PARAMETER AppendMarkdown
            Optional string containing raw markdown **OR** path to a markdown file.

            Markdown will be inserted in all pages, directly below the PlatyPS generated markdown.

        .PARAMETER EditUrl
            Specifies the URL prefixed to all Docusaurus `custom_edit_url` front matter variables.

            Optional, defaults to `null`.

        .PARAMETER KeepHeader1
            By default, the `H1` element will be removed from the PlatyPS generated markdown because
            Docusaurus uses the per-page frontmatter variable `title` as the page's H1 element instead.

            You may use this switch parameter to keep the markdown `H1` element, most likely in
            combination with the `HideTitle` parameter.

        .PARAMETER HideTitle
            Sets the Docusaurus front matter variable `hide_title`.

            Optional, defaults to `false`.

        .PARAMETER HideTableOfContents
            Sets the Docusaurus front matter variable `hide_table_of_contents`.

            Optional, defaults to `false`.

        .PARAMETER NoPlaceholderExamples
            By default, Docusaurus will generate a placeholder example if your Get-Help
            definition does not contain any `EXAMPLE` nodes.

            You can use this switch to disable that behavior which will result in an empty `EXAMPLES` section.

        .PARAMETER Monolithic
            Use this optional parameter if the PowerShell module source is monolithic.

            Will point all `custom_edit_url` front matter variables to the `.psm1` file.

        .PARAMETER VendorAgnostic
            Use this switch parameter if you **do not want to use Docusaurus** but would still like
            to benefit of the markdown-enrichment functions this module provides.

            If used, the `New-GetDocusaurusHelp` command will produce the exact same markdown as
            always but will skip the following two Docusaurus-specific steps:

            - PlatyPS frontmatter will not be touched
            - `docusaurus.sidebar.js` file will not be generated

            For more information please
            [visit this page](https://docusaurus-powershell.vercel.app/docs/faq/vendor-agnostic).

        .PARAMETER GroupByVerb
            Use this switch parameter to group your documentation into folders for each PowerShell approved verb.

            If used, when the sidebar folder is cleaned it will be cleaned assuming it has the verb subfolder structure.

        .PARAMETER RemoveParameters
            Optional array of parameter names to exclude from the generated documentation.

            Useful for filtering out common parameters like `-ProgressAction` that you don't want documented.

        .NOTES
            For debugging purposes, Docusaurus.Powershell creates a local temp folder with:

            - the raw PlatyPS generated `.md` files
            - the Docusaurus.Powershell enriched `.mdx` files
            - a `debug.json` file containing detailed module information

            ```powershell
            $tempFolder = Get-Item (Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Alt3.Docusaurus.Powershell")
            ```

        .LINK
            https://docusaurus-powershell.vercel.app/

        .LINK
            https://docusaurus.io/

        .LINK
            https://github.com/PowerShell/platyPS
    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'Module')][string]$Module,
        [Parameter(Mandatory = $True, ParameterSetName = 'PlatyPSMarkdownPath')]
        [ValidateScript({ [System.IO.Directory]::Exists($_) })]
        [string]$PlatyPSMarkdownPath,
        [Parameter(Mandatory = $False)][string]$DocsFolder = "docusaurus/docs",
        [Parameter(Mandatory = $False)][string]$Sidebar = "commands",
        [Parameter(Mandatory = $False)][array]$Exclude = @(),
        [Parameter(Mandatory = $False)][string]$EditUrl,
        [Parameter(Mandatory = $False)][string]$MetaDescription,
        [Parameter(Mandatory = $False)][array]$MetaKeywords,
        [Parameter(Mandatory = $False)][string]$PrependMarkdown,
        [Parameter(Mandatory = $False)][string]$AppendMarkdown,
        [switch]$KeepHeader1,
        [switch]$HideTitle,
        [switch]$HideTableOfContents,
        [switch]$NoPlaceHolderExamples,
        [switch]$Monolithic,
        [switch]$VendorAgnostic,
        [switch]$GroupByVerb,
        [Parameter(Mandatory = $False)][array]$RemoveParameters = @(),
        [switch]$UseCustomShortTitles,
        [Parameter(Mandatory = $False)][hashtable]$ShortTitles = @{}
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    # Get the module's name fromn the supplied markdown files.
    if ($PSCmdlet.ParameterSetName.Equals('PlatyPSMarkdownPath'))
    {
        # Get the module's name from the supplied markdown files.
        $moduleName = Get-ChildItem -LiteralPath $PlatyPSMarkdownPath -Filter *.md |
            Get-Content -ReadCount 10 -TotalCount 10 |
            ForEach-Object { $_ -match '^Module Name: ' -replace '^Module Name:\s+' } |
            Select-Object -Unique

        # Throw if null or we've got more than one item.
        if ($null -eq $moduleName)
        {
            $errSentence1 = 'Unable to determine the module name from the supplied markdown files.'
            $errSentence2 = 'Please confirm their validity and try again.'
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new("$errSentence1 $errSentence2", 'PlatyPSMarkdownPath'),
                    'ModuleNameIndeterminateError',
                    [System.Management.Automation.ErrorCategory]::InvalidResult,
                    $moduleName
                ))
        }
        elseif ($moduleName -isnot [System.String])
        {
            $errSentence1 = "More than one module name was found within the supplied markdown files ('$([System.String]::Join("', '", $moduleName))')."
            $errSentence2 = 'Please supply unique markdown files for a single module and try again.'
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new("$errSentence1 $errSentence2", 'PlatyPSMarkdownPath'),
                    'DuplicateModuleNameError',
                    [System.Management.Automation.ErrorCategory]::InvalidResult,
                    $moduleName
                ))
        }

        # Trim off the leading characters before continuing.
        $Module = $moduleName
    }
    else
    {
        # make sure the passed module is valid
        if (Test-Path($Module)) {
            Import-Module $Module -Force -Global
            $Module = [System.IO.Path]::GetFileNameWithoutExtension($Module)
        }

        if (-Not(Get-Module -Name $Module)) {
            $Module = $Module
            throw "New-DocusaurusHelp: Specified module '$Module' is not loaded"
        }

        $moduleName = [io.path]::GetFileName($module)
    }

    # get version of this module so we can e.g. add version tag to generated files
    $alt3Version = Split-Path -Leaf $MyInvocation.MyCommand.ScriptBlock.Module.ModuleBase
    Write-Verbose "Using Alt3 module version = $($alt3Version)"

    # markdown for the module will be copied into the sidebar subfolder
    Write-Verbose 'Initializing sidebar folder:'
    $sidebarFolder = Join-Path -Path $DocsFolder -ChildPath $Sidebar
    if ($GroupByVerb) {
        CreateOrCleanFolder -Path $sidebarFolder -GroupByVerb
    } else {
        CreateOrCleanFolder -Path $sidebarFolder
    }

    # create tempfolder used for generating the PlatyPS files and creating the mdx files
    $tempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Alt3.Docusaurus.Powershell' | Join-Path -ChildPath $moduleName
    InitializeTempFolder -Path $tempFolder

    # generate PlatyPs markdown files
    if ($PSCmdlet.ParameterSetName.Equals('Module'))
    {
        Write-Verbose "Generating PlatyPS files."
        # Get the actual module object, not just the name string
        # But keep the module name string for use in other functions
        $moduleNameString = $Module
        $moduleObject = Get-Module -Name $Module
        New-MarkdownHelp -Module $moduleObject -OutputFolder $tempFolder -Force | Out-Null
    }
    else
    {
        Write-Verbose "Copying cached markdown files to temp folder."
        $moduleNameString = $Module
        Copy-Item -Path $PlatyPSMarkdownPath\*.md -Destination $tempFolder -Force -Confirm:$false
    }

    # remove files matching excluded commands
    Write-Verbose 'Removing excluded files:'
    $Exclude | ForEach-Object {
        RemoveFile -Path (Join-Path -Path $tempFolder -ChildPath "$($_).md")
    }

    # rename PlatyPS files and create an `.mdx` copy we will transform
    Write-Verbose 'Cloning PlatyPS files.'
    Get-ChildItem -Path $tempFolder -Filter *.md | ForEach-Object {
        $platyPsFile = $_.FullName -replace '\.md$', '.PlatyPS.md'
        $mdxFile = $_.FullName -replace '\.md$', '.mdx'
        Move-Item -Path $_.FullName -Destination $platyPsFile
        Copy-Item -Path $platyPsFile -Destination $mdxFile
    }

    # update all remaining mdx files to make them Docusaurus compatible
    Write-Verbose 'Updating mdx files.'
    $mdxFiles = Get-ChildItem -Path $tempFolder -Filter *.mdx

    ForEach ($mdxFile in $mdxFiles) {
        Write-Verbose "Processing $($mdxFile.Name):"

        # prepare per-page variables
        $customEditUrl = GetCustomEditUrl -Module $moduleNameString -MarkdownFile $mdxFile -EditUrl $EditUrl -Monolithic:$Monolithic

        # Extract command name from file and get custom short title if applicable
        $commandName = [System.IO.Path]::GetFileNameWithoutExtension($mdxFile.Name)
        $customShortTitle = $null
        if ($UseCustomShortTitles -and $ShortTitles -and $ShortTitles.ContainsKey($commandName)) {
            $customShortTitle = $ShortTitles[$commandName]
        }

        $frontMatterArgs = @{
            MarkdownFile        = $mdxFile
            MetaDescription     = $metaDescription
            CustomEditUrl       = $customEditUrl
            MetaKeywords        = $metaKeywords
            HideTitle           = $HideTitle
            HideTableOfContents = $HideTableOfContents
        }

        # Add custom short title if available
        if ($customShortTitle) {
            $frontMatterArgs['CustomShortTitle'] = $customShortTitle
        }

        # transform the markdown using these steps (overwriting the mdx file per step)
        SetLfLineEndings -MarkdownFile $mdxFile

        if (-not($VendorAgnostic)) {
            ReplaceFrontMatter @frontmatterArgs
        }

        ReplaceHeader1 -MarkdownFile $mdxFile -KeepHeader1:$KeepHeader1

        if ($PrependMarkdown) {
            InsertUserMarkdown -MarkdownFile $mdxFile -Markdown $PrependMarkdown -Mode 'Prepend'
        }

        ReplaceExamples -MarkdownFile $mdxFile -NoPlaceholderExamples:$NoPlaceholderExamples

        if ($AppendMarkdown) {
            InsertUserMarkdown -MarkdownFile $mdxFile -Markdown $AppendMarkdown -Mode 'Append'
        }

        if ($RemoveParameters.Count -gt 0) {
            RemoveParameters -MarkdownFile $mdxFile -RemoveParameters $RemoveParameters
        }

        # Post-fix complex multiline code examples (https://github.com/pester/Pester/issues/2195)
        RemoveBlankLinesBelowOpeningBracket -MarkdownFile $mdxFile
        RemoveBlankLinesAboveClosingBracket -MarkdownFile $mdxFile
        IndentLineBelowOpeningBracket -MarkdownFile $mdxFile
        IndentLineWithOpeningBracket -MarkdownFile $mdxFile

        ## Continue with general enrichment
        InsertPowerShellMonikers -MarkdownFile $mdxFile
        UnescapeSpecialChars -MarkdownFile $mdxFile
        SeparateMarkdownHeadings -MarkdownFile $mdxFile

        # Line by line changes
        UnescapeInlineCode -MarkdownFile $mdxFile
        HtmlEncodeLessThanBrackets -MarkdownFile $mdxFile
        HtmlEncodeGreaterThanBrackets -MarkdownFile $mdxFile
        EscapeOpeningCurlyBrackets -MarkdownFile $mdxFile
        EscapeClosingCurlyBrackets -MarkdownFile $mdxFile

        # all done, set line endings again
        SetLfLineEndings -MarkdownFile $mdxFile
        InsertFinalNewline -MarkdownFile $mdxFile
    }

    # copy updated mdx files to the target folder
    Write-Verbose 'Copying mdx files to sidebar folder.'
    $updatedMDXFiles = Get-ChildItem -Path $tempFolder -Filter *.mdx
    if ($GroupByVerb) {
        $processedMDXFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
        $usedVerbs = [System.Collections.Generic.List[string]]::new()
        $verbs = Get-Verb
        foreach ($verb in $verbs.Verb) {
            Write-Verbose "Processing verb $verb"
            $filteredMDXFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
            $updatedMDXFiles | Where-Object { $_.Name.StartsWith($verb) } | ForEach-Object { $filteredMDXFiles.Add($_) }
            if ($filteredMDXFiles.Count -gt 0) {
                Write-Verbose "Found $($filteredMDXFiles.Count) files for verb $verb"
                foreach ($filteredMDXFile in $filteredMDXFiles) {
                    Write-Verbose "Processing file $($filteredMDXFile.Name)"
                    $subfolderPath = Join-Path -Path $sidebarFolder -ChildPath $verb
                    if (-not(Test-Path -Path $subfolderPath)) {
                        New-Item -Path $subfolderPath -ItemType Directory | Out-Null
                    }
                    $OutputFile = Join-Path -Path $subfolderPath -ChildPath $filteredMDXFile.Name
                    Copy-Item -Path $filteredMDXFile.FullName -Destination $OutputFile
                    $processedMDXFiles.Add($OutputFile)
                }
                $usedVerbs.Add($verb)
            } else {
                Write-Verbose "Found 0 files for verb $verb"
            }
        }
        # generate the `.js` file used for the docusaurus sidebar
        if (-not($VendorAgnostic)) {
            NewSidebarIncludeFile -MarkdownFiles $processedMDXFiles -TempFolder $tempFolder -OutputFolder $sidebarFolder -Sidebar $Sidebar -Alt3Version $alt3Version -GroupByVerb -UsedVerbs $usedVerbs
        }
    } else {
        foreach ($updatedMDXFile in $updatedMDXFiles) {
            Copy-Item -Path $updatedMDXFile.FullName -Destination (Join-Path -Path $sidebarFolder -ChildPath ($updatedMDXFile.Name))
        }
        # generate the `.js` file used for the docusaurus sidebar
        if (-not($VendorAgnostic)) {
            NewSidebarIncludeFile -MarkdownFiles $updatedMDXFiles -TempFolder $tempFolder -OutputFolder $sidebarFolder -Sidebar $Sidebar -Alt3Version $alt3Version
        }
    }

    # output Get-ChildItem so end-user can post-process generated files as they see fit
    Get-ChildItem -Path $sidebarFolder
}
#EndRegion '.\Public\New-DocusaurusHelp.ps1' 415
