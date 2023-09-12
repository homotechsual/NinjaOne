function Update-NinjaOneOrganisationCustomFields {
    <#
        .SYNOPSIS
            Updates organisation custom fields.
        .DESCRIPTION
            Updates organisation custom fields using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the information for.
        [Parameter(Mandatory = $true)]
        [int]$organisationId,
        # The organisation information body object.
        [Parameter(Mandatory = $true)]
        [object]$fields
    )
    try {
        $Resource = "v2/organization/$organisationId/custom-fields"
        $RequestParams = @{
            Resource = $Resource
            Body = $fields
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -organisationId $organisationId).Count -gt 0
        if ($OrganisationExists) {
            if ($PSCmdlet.ShouldProcess('Custom Fields', 'Update')) {
                $OrganisationUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($OrganisationUpdate -eq 204) {
                    Write-Information "Custom fields for organisation $($organisationId) updated successfully."
                }
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}