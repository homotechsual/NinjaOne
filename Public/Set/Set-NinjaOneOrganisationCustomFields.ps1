function Set-NinjaOneOrganisationCustomFields {
    <#
        .SYNOPSIS
            Updates an organisation's custom fields.
        .DESCRIPTION
            Updates organisation custom field values using the NinjaOne v2 API.
        .EXAMPLE
            PS> $OrganisationCustomFields = @{
                field1 = 'value1'
                field2 = 'value2'
            }
            PS> Update-NinjaOneOrganisationCustomFields -organisationId 1 -organisationCustomFields $OrganisationCustomFields

            Updates the custom fields for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the custom fields for.
        [Parameter(Mandatory = $true)]
        [Alias('id', 'organizationId')]
        [int]$organisationId,
        # The organisation custom field body object.
        [Parameter(Mandatory = $true)]
        [Alias('customFields', 'body')]
        [object]$organisationCustomFields
    )
    try {
        $Resource = "v2/organization/$organisationId/custom-fields"
        $RequestParams = @{
            Resource = $Resource
            Body = $organisationCustomFields
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        if ($OrganisationExists) {
            if ($PSCmdlet.ShouldProcess('Organisation custom fields', 'Update')) {
                $OrganisationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($OrganisationCustomFieldsUpdate -eq 204) {
                    Write-Information "Organisation custom fields for organisation '$($organisationId)' updated successfully."
                }
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}