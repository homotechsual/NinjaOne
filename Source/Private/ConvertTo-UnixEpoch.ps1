function ConvertTo-UnixEpoch {
    <#
    .SYNOPSIS
        Converts a PowerShell DateTime object to a Unix Epoch timestamp.
    .DESCRIPTION
        Takes a PowerShell DateTime object and returns a Unix Epoch timestamp representing the same date/time.
    .OUTPUTS
        The Unix Epoch timestamp.
    #>
    [CmdletBinding()]
    [OutputType([Int])]
    param (
        # The PowerShell DateTime object to convert.
        [Parameter(
            Mandatory = $True
        )]
        [Object]$DateTime
    )
    if ($DateTime -is [String]) {
        $DateTime = [DateTime]::Parse($DateTime)
    } elseif ($DateTime -is [Int]) {
        (Get-Date 01.01.1970).AddSeconds($unixTimeStamp)  
    } elseif ($DateTime -is [DateTime]) {
        $DateTime = $DateTime
    } else {
        Write-Error 'The DateTime parameter must be a DateTime object, a string, or an integer.'
        Exit 1
    }
    $UniversalDateTime = $DateTime.ToUniversalTime()
    $UnixEpochTimestamp = Get-Date -Date $UniversalDateTime -UFormat %s
    Write-Verbose "Converted $DateTime to Unix Epoch timestamp $UnixEpochTimestamp"
    return $UnixEpochTimestamp
}