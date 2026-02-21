#!/usr/bin/env pwsh
<#
.SYNOPSIS
Generates semantic help content for functions based on their structure.

.DESCRIPTION
Creates appropriate .SYNOPSIS, .DESCRIPTION, .PARAMETER, and .EXAMPLE
sections for functions based on naming patterns and actual parameters.
#>

param(
    [string]$FunctionName,
    [object[]]$Parameters,
    [string]$FunctionType = 'public' # 'public' or 'private'
)

$verbPatterns = @{
    'Get'      = @{ Verb = 'Get'; Icon = '🔍'; Example = '-Identity' }
    'New'      = @{ Verb = 'Create'; Icon = '➕'; Example = '-Name' }
    'Set'      = @{ Verb = 'Update'; Icon = '✏️' ; Example = '-Identity' }
    'Remove'   = @{ Verb = 'Delete'; Icon = '🗑️' ; Example = '-Identity' }
    'Add'      = @{ Verb = 'Add'; Icon = '➕'; Example = '-InputObject' }
    'Invoke'   = @{ Verb = 'Execute'; Icon = '▶️' ; Example = '-Name' }
    'Find'     = @{ Verb = 'Search'; Icon = '🔎'; Example = '-Filter' }
    'Update'   = @{ Verb = 'Update'; Icon = '🔄'; Example = '-Identity' }
    'Merge'    = @{ Verb = 'Merge'; Icon = '🔀'; Example = '-Source' }
    'Move'     = @{ Verb = 'Move'; Icon = '➡️' ; Example = '-Identity' }
}

# Extract verb from function name
$funcNameParts = $FunctionName -split '-'
$verb = $funcNameParts[0]

# Extract and clean noun (remove "NinjaOne" prefix)
$fullNoun = ($funcNameParts | Select-Object -Skip 1) -join ' '
$noun = if ($fullNoun -match '^NinjaOne(.+)$') {
    $matches[1]
} else {
    $fullNoun
}

# Get verb description
$verbInfo = $verbPatterns[$verb] ?? @{ Verb = $verb; Icon = '⚙️' }

# Build SYNOPSIS
$synopsis = if ($noun) {
    "$($verbInfo.Verb) $noun."
} else {
    "$($verbInfo.Verb) operation."
}

# Build DESCRIPTION based on function type and naming
$description = if ($FunctionType -eq 'public') {
    $desc = "Performs a $($verbInfo.Verb.ToLower()) operation on NinjaOne $noun resources.`n`n"
    $desc += "This cmdlet enables interaction with the NinjaOne API to manage $noun data.`n"
    $desc += "Appropriate API credentials and permissions are required."
    $desc
} else {
    "Internal helper function for $FunctionName operations.`n`nThis function provides supporting functionality for the NinjaOne module."
}

# Build PARAMETERS section
$paramDescriptions = @()
if ($Parameters) {
    foreach ($param in $Parameters) {
        $paramName = if ($param -is [string]) { $param } else { $param.Name }
        
        # Generate contextual parameter description
        $paramDesc = switch -Regex ($paramName) {
            '^ID$|^.*Id$' { "Specifies the unique identifier for the $noun resource." }
            'Identity' { "Specifies the identity or filter for the $noun resource." }
            'Filter' { "Specifies a filter to narrow results." }
            'Name' { "Specifies the name of the $noun resource." }
            'Body|Data|InputObject|Object' { "Specifies the $noun object containing values to apply." }
            'Query|Fields|Select' { "Specifies fields or query parameters to retrieve." }
            'Search' { "Specifies the search term to find $noun resources." }
            'Sort' { "Specifies the sort order for results." }
            'Order' { "Specifies the sort order for results." }
            'Count|Limit|Take|First' { "Specifies the maximum number of results to retrieve." }
            'FirstResult|Skip|Offset' { "Specifies the starting index for pagination." }
            'Page' { "Specifies the page number for paginated results." }
            'Force' { "Forces the operation without confirmation." }
            'PassThru' { "Returns the modified object to the pipeline." }
            'Confirm' { "Prompts for confirmation before executing the operation." }
            'WhatIf' { "Shows what would happen if the operation were executed." }
            default { "Specifies the $paramName parameter." }
        }
        
        $paramDescriptions += ".PARAMETER $paramName`n    $paramDesc"
    }
}

# Build EXAMPLE
$firstParam = if ($Parameters -and $Parameters.Count -gt 0) {
    if ($Parameters[0] -is [string]) {
        $Parameters[0]
    } else {
        $Parameters[0].Name
    }
} else {
    'Identity'
}

$example = ".EXAMPLE`n    PS> $FunctionName" + $(
    if ($Parameters -and $Parameters.Count -gt 0) {
        switch -Regex ($firstParam) {
            'ID$|Id$' { " -$firstParam 12345" }
            'Identity' { " -$firstParam `"example-id`"" }
            'Filter|Name' { " -$firstParam `"*search*`"" }
            default { " -$firstParam `"value`"" }
        }
    }
) + "`n`n    $($verbInfo.Verb.ToLower()) the specified $noun."

# Construct complete help block
$helpBlock = @"
<#
.SYNOPSIS
$synopsis

.DESCRIPTION
$description

$(if ($paramDescriptions) { $paramDescriptions -join "`n`n" } else { '.PARAMETER Parameter1
    Describes the first parameter.

.PARAMETER Parameter2
    Describes the second parameter.' })

$example

.OUTPUTS
Returns information about the $noun resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
"@

return $helpBlock
