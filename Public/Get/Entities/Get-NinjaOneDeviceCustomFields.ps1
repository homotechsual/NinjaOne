#Requires -Version 7
function Get-NinjaOneDeviceCustomFields {
    <#
        .SYNOPSIS
            Gets device custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves device custom fields from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by device ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceID) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving custom fields for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/custom-fields"
            }
        } else {
            Write-Verbose 'Retrieving all device custom fields.'
            $Resource = 'v2/device-custom-fields'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceCustomFieldResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceCustomFieldResults
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaOneError @ErrorRecord
    }
}