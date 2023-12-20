function Set-NinjaOneLocationCustomFields {
    <#
        .SYNOPSIS
            Sets an location's custom fields.
        .DESCRIPTION
            Sets location custom field values using the NinjaOne v2 API.
        .FUNCTIONALITY
            Location Custom Fields
        .EXAMPLE
            PS> $LocationCustomFields = @{
                field1 = 'value1'
                field2 = 'value2'
            }
            PS> Update-NinjaOneLocationCustomFields -organisationId 1 -locationId 2 -locationCustomFields $LocationCustomFields

            Updates the custom fields for the location with id 2 belonging to the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/locationcustomfields
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('snolcf', 'unolcf', 'Update-NinjaOneLocationCustomFields')]
    [MetadataAttribute(
        '/v2/organization/{id}/location/{locationId}/custom-fields',
        'patch'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the custom fields for.
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The location to set the custom fields for.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$locationId,
        # The organisation custom field body object.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [Alias('customFields', 'body')]
        [Object]$locationCustomFields
    )
    process {
        try {
            $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
            if ($Organisation) {
                Write-Verbose ('Getting location {0} from NinjaOne API.' -f $locationId)
                $Location = Get-NinjaOneLocations -OrganisationId $organisationId | Where-Object { $_.id -eq $locationId }
                if ($Location) {
                    Write-Verbose ('Setting location custom fields for location {0}.' -f $Location.name)
                    $Resource = ('v2/organization/{0}/locations/{1}/custom-fields' -f $organisationId, $locationId)
                } else {
                    throw ('Location with id {0} not found in organisation {1}' -f $locationId, $Organisation.Name)
                }
            } else {
                throw ('Organisation with id {0} not found.' -f $organisationId)
            }
            $RequestParams = @{
                Resource = $Resource
                Body = $locationCustomFields
            }
            if ($PSCmdlet.ShouldProcess(('Location custom fields for {0} in {1}' -f $Location.Name, $Organisation.Name), 'Update')) {
                $LocationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($LocationCustomFieldsUpdate -eq 204) {
                    $OIP = $InformationPreference
                    $InformationPreference = 'Continue'
                    Write-Information ('Location {0} custom fields updated successfully.' -f $Location.Name)
                    $InformationPreference = $OIP
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}