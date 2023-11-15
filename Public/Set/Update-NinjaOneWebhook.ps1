function Set-NinjaOneWebhook {
    <#
        .SYNOPSIS
            Sets webhook configuration for the current application/API client.
        .DESCRIPTION
            Sets webhook configuration for the current application/API client using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The webhook configuration object.
        [Parameter( Mandatory )]
        [Object]$webhookConfiguration
    )
    try {
        $Resource = 'v2/webhook'
        $RequestParams = @{
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