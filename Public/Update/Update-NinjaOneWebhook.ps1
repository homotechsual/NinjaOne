
using namespace System.Management.Automation
#Requires -Version 7
function Update-NinjaOneWebhook {
    <#
        .SYNOPSIS
            Updates webhook configuration for the current application/API client.
        .DESCRIPTION
            Updates webhook configuration for the current application/API client using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The webhook configuration object.
        [Parameter(Mandatory = $true)]
        [object]$webhookConfiguration
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'webhookConfiguration=' parameter by removing it from the set parameters.
    if ($webhookConfiguration) {
        $Parameters.Remove('webhookConfiguration') | Out-Null
    }
    try {
        $Resource = 'v2/webhook'
        $RequestParams = @{
            Method = 'PUT'
            Resource = $Resource
            Body = $webhookConfiguration
        }
        if ($PSCmdlet.ShouldProcess('Webhook Configuration', 'Update')) {
            $WebhookUpdate = New-NinjaOnePUTRequest @RequestParams
            if ($WebhookUpdate -eq 204) {
                Write-Information 'Webhook configuration updated successfully.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}