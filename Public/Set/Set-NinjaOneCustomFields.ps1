
using namespace System.Management.Automation
#Requires -Version 7
function Set-NinjaOneCustomFields {
    <#
        .SYNOPSIS
            Sets the value of the specified device custom fields.
        .DESCRIPTION
            Sets the value of the specified device custom fields using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
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
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceId=' parameter by removing it from the set parameters.
    if ($deviceIds) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'customFields=' parameter by removing it from the set parameters.
    if ($customFields) {
        $Parameters.Remove('customFields') | Out-Null
    }
    try {
        $Resource = "v2/device/$deviceId/custom-fields"
        $RequestParams = @{
            Method = 'POST'
            Resource = $Resource
            Body = $customFields
        }
        if ($PSCmdlet.ShouldProcess('Custom Fields', 'Set')) {
            $CustomFieldUpdate = New-NinjaOnePOSTRequest @RequestParams
            if ($CustomFieldUpdate -eq 204) {
                Write-Information "Custom fields for device $($deviceId) updated successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}