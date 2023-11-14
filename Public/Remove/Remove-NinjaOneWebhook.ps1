function Remove-NinjaOneWebhook {
    <#
        .SYNOPSIS
            Removes webhook configuration for the current application/API client.
        .DESCRIPTION
            Removes webhook configuration for the current application/API client using the NinjaOne v2 API.
        .FUNCTIONALITY
            Webhook
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    try {
        $Resource = 'v2/webhook'
        $RequestParams = @{
            Resource = $Resource
        }
        if ($PSCmdlet.ShouldProcess('Webhook Configuration', 'Update')) {
            $WebhookConfiguration = New-NinjaOneDELETERequest @RequestParams
            if ($WebhookConfiguration -eq 204) {
                Write-Information 'Webhook configuration deleted successfully.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}