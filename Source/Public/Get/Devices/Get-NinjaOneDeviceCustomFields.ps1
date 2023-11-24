
function Get-NinjaOneDeviceCustomFields {
    <#
        .SYNOPSIS
            Gets device custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves device custom fields from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Custom Fields
        .EXAMPLE
            PS> Get-NinjaOneDeviceCustomFields
            
            Gets all device custom fields.
        .EXAMPLE
            PS> Get-NinjaOneDeviceCustomFields | Group-Object { $_.scope }

            Gets all device custom fields grouped by the scope property.
        .EXAMPLE
            PS> Get-NinjaOneDeviceCustomFields -deviceId 1

            Gets the device custom fields and values for the device with id 1
        .EXAMPLE
            PS> Get-NinjaOneDeviceCustomFields -deviceId 1 -withInheritance

            Gets the device custom fields and values for the device with id 1 and inherits values from parent location and/or organisation, if no value is set for the device you will get the value from the parent location and if no value is set for the parent location you will get the value from the parent organisation.
        .OUTPUTS
            A powershell object containing the response
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get custom field values for a specific device.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Inherit custom field values from parent location and/or organisation.
        [Switch]$withInheritance
    )
    try {
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose ('Getting custom fields for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/custom-fields' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
        } else {
            Write-Verbose 'Retrieving all device custom fields.'
            $Resource = 'v2/device-custom-fields'
        }
        $RequestParams = @{
            Resource = $Resource
        }
        $DeviceCustomFieldResults = New-NinjaOneGETRequest @RequestParams
        return $DeviceCustomFieldResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}