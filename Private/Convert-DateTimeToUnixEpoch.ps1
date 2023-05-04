function Convert-DateTimeToUnixEpoch {
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
        [DateTime]$DateTime
    )
    $UniversalDateTime = $DateTime.ToUniversalTime()
    $UnixEpochTimestamp = Get-Date -Date $UniversalDateTime -UFormat %s
    Write-Verbose "Converted $DateTime to Unix Epoch timestamp $UnixEpochTimestamp"
    Return $UnixEpochTimestamp
}