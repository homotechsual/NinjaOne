function Reset-NinjaOneAlert {
    <#
        .SYNOPSIS
            Resets alerts using the NinjaOne API.
        .DESCRIPTION
            Resets the status of alerts using the NinjaOne v2 API.
        .FUNCTIONALITY
            Alert
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The alert ID to reset status for.
        [Parameter(Mandatory = $true)]
        [string]$uid,
        # The reset activity data.
        [Parameter()]
        [object]$activityData
    )
    try {
        if ($activityData) {
            $Resource = "v2/alert/$uid/reset"
            $RequestParams = @{
                Resource = $Resource
                Body = $activityData
            }
            if ($PSCmdlet.ShouldProcess('Alert', 'Reset')) {
                $Alert = New-NinjaOnePOSTRequest @RequestParams
                if ($Alert -eq 204) {
                    Write-Information 'Alert reset successfully.'
                }
            }
        } else {
            $Resource = "v2/alert/$uid"
            $RequestParams = @{
                Resource = $Resource
            }
            if ($PSCmdlet.ShouldProcess('Alert', 'Reset')) {
                $Alert = New-NinjaOneDELETERequest @RequestParams
                if ($Alert -eq 204) {
                    Write-Information 'Alert reset successfully.'
                }
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}