function Set-NinjaOneOrganisationCustomFields {
    <#
        .SYNOPSIS
            Updates an organisation's custom fields.
        .DESCRIPTION
            Updates organisation custom field values using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation Custom Fields
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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the custom fields for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The organisation custom field body object.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Alias('customFields', 'body', 'organizationCustomFields')]
        [Object]$organisationCustomFields
    )
    try {
        $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
        if ($Organisation) {
            Write-Verbose ('Setting organisation custom fields for organisation {0}.' -f $Organisation.Name)
            $Resource = ('v2/organization/{0}/custom-fields' -f $organisationId)
        } else {
            throw ('Organisation with id {0} not found.' -f $organisationId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $organisationCustomFields
        }
        if ($PSCmdlet.ShouldProcess(('Organisation {0} custom fields' -f $Organisation.Name), 'Update')) {
            $OrganisationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
            if ($OrganisationCustomFieldsUpdate -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Organisation {0} custom fields updated successfully.' -f $Organisation.Name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}