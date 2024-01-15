function Set-NinjaOneOrganisation {
    <#
        .SYNOPSIS
            Sets organisation information, like name, node approval mode etc.
        .DESCRIPTION
            Sets organisation information using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisation
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('snoo', 'Set-NinjaOneOrganization', 'unoo', 'Update-NinjaOneOrganisation', 'Update-NinjaOneOrganization')]
    [MetadataAttribute(
        '/v2/organization/{id}',
        'patch'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The organisation information body object.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Alias('organizationInformation', 'body')]
        [Object]$organisationInformation
    )
    process {
        try {
            $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
            if ($Organisation) {
                Write-Verbose ('Setting organisation information for organisation {0}.' -f $Organisation.Name)
                $Resource = ('v2/organization/{0}' -f $organisationId)
            } else {
                throw ('Organisation with id {0} not found.' -f $organisationId)
            }
            $RequestParams = @{
                Resource = $Resource
                Body = $organisationInformation
            }
            if ($PSCmdlet.ShouldProcess(('Organisation {0} information' -f $Organisation.Name), 'Update')) {
                $OrganisationUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($OrganisationUpdate -eq 204) {
                    Write-Information ('Organisation {0} information updated successfully.' -f $Organisation.Name)
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}