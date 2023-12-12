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
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/webhook
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('rnow')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    process {
        try {
            $Resource = 'v2/webhook'
            $RequestParams = @{
                Resource = $Resource
            }
            if ($PSCmdlet.ShouldProcess('Webhook Configuration', 'Delete')) {
                $WebhookConfiguration = New-NinjaOneDELETERequest @RequestParams
                if ($WebhookConfiguration -eq 204) {
                    Write-Information 'Webhook configuration deleted successfully.'
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}