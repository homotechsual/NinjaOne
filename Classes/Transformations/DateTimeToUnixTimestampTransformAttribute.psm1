using namespace System.Management.Automation
class DateTimeToUnixTimestampTransformAttribute : ArgumentTransformationAttribute {
    [Object] Transform([EngineIntrinsics]$EngineIntrinsics, [Object]$InputData) {
        $DateTime = if ($InputData -is [String]) {
            Return [DateTime]::Parse($InputData)
        } elseif ($InputData -is [Int]) {
            Return (Get-Date 01.01.1970).AddSeconds($InputData)  
        } elseif ($InputData -is [DateTime]) {
            Return $InputData
        } else {
            throw [ArgumentTransformationMetadataException]::New('The DateTime parameter must be a DateTime object, a string, or an integer.')
            Exit 1
        }
        $UniversalDateTime = $DateTime.ToUniversalTime()
        $UnixEpochTimestamp = Get-Date -Date $UniversalDateTime -UFormat %s
        Write-Verbose "Converted $DateTime to Unix Epoch timestamp $UnixEpochTimestamp"
        Return $UnixEpochTimestamp
    }
}