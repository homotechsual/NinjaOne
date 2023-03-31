function Set-NinjaOneDeviceCustomFields {
    <#
        .SYNOPSIS
            Sets the value of the specified device custom fields.
        .DESCRIPTION
            Sets the value of the specified device custom fields using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
            PS> Set-NinjaOneDeviceCustomFields -deviceId 1 -customFields @{ CustomField1 = 'Value1'; CustomField2 = 'Value2' }
            
            Set `CustomField1` to `Value1` and `CustomField2` to `Value2` respectively.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set the custom field value(s) for.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The custom field(s) body object.
        [Parameter(Mandatory = $true)]
        [object]$customFields
    )
    try {
        $Resource = "v2/device/$deviceId/custom-fields"
        $RequestParams = @{
            Resource = $Resource
            Body = $customFields
        }
        if ($PSCmdlet.ShouldProcess('Custom Fields', 'Set')) {
            $CustomFieldUpdate = New-NinjaOnePATCHRequest @RequestParams
            if ($CustomFieldUpdate -eq 204) {
                Write-Information "Custom fields for device $($deviceId) updated successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}