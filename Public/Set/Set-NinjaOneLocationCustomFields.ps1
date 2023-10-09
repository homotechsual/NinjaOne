function Set-NinjaOneLocationCustomFields {
    <#
        .SYNOPSIS
            Updates an location's custom fields.
        .DESCRIPTION
            Updates location custom field values using the NinjaOne v2 API.
        .EXAMPLE
            PS> $LocationCustomFields = @{
                field1 = 'value1'
                field2 = 'value2'
            }
            PS> Update-NinjaOneLocationCustomFields -organisationId 1 -locationId 2 -locationCustomFields $LocationCustomFields

            Updates the custom fields for the location with id 2 belonging to the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the custom fields for.
        [Parameter(Mandatory)]
        [Alias('id', 'organizationId')]
        [int]$organisationId,
        # The location to set the custom fields for.
        [Parameter(Mandatory)]
        [int]$locationId,
        # The organisation custom field body object.
        [Parameter(Mandatory)]
        [Alias('customFields', 'body')]
        [object]$locationCustomFields
    )
    try {
        $Resource = "v2/organization/$organisationId/location/$locationId/custom-fields"
        $RequestParams = @{
            Resource = $Resource
            Body = $locationCustomFields
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        if ($OrganisationExists) {
            $LocationExists = (Get-NinjaOneLocations -OrganisationId $organisationId | Where-Object -Property id -EQ $locationId).Count -gt 0
            if ($LocationExists) {
                if ($PSCmdlet.ShouldProcess('Location custom fields', 'Update')) {
                    $LocationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
                    if ($LocationCustomFieldsUpdate -eq 204) {
                        Write-Information "Organisation custom fields for organisation '$($Organisation.Name)' location '$($Location.Name)' updated successfully."
                    }
                }
            } else {
                Throw "Location $($locationId) does not exist for organisation $($Organisation.Name)."
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}