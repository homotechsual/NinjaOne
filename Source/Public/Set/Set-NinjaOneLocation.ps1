function Set-NinjaOneLocation {
    <#
        .SYNOPSIS
            Sets location information, like name, address, description etc.
        .DESCRIPTION
            Sets location information using the NinjaOne v2 API.
        .FUNCTIONALITY
            Location
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/location
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the location information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The location to set the information for.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$locationId,
        # The location information body object.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [Object]$locationInformation
    )
    try {
        $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
        if ($Organisation) {
            Write-Verbose ('Getting location {0} from NinjaOne API.' -f $locationId)
            $Location = Get-NinjaOneLocations -OrganisationId $organisationId | Where-Object { $_.id -eq $locationId }
            if ($Location) {
                Write-Verbose ('Setting location information for location {0}.' -f $Location.name)
                $Resource = ('v2/organization/{0}/locations/{1}' -f $organisationId, $locationId)
            } else {
                throw ('Location with id {0} not found in organisation {1}' -f $locationId, $Organisation.Name)
            }
        } else {
            throw ('Organisation with id {0} not found.' -f $organisationId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $locationInformation
        }
        if ($PSCmdlet.ShouldProcess(('Location information for {0} in {1}' -f $Location.Name, $Organisation.Name), 'Update')) {
            $LocationUpdate = New-NinjaOnePATCHRequest @RequestParams
            if ($LocationUpdate -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Location {0} information updated successfully.' -f $Location.Name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}