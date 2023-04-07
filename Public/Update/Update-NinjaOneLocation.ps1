function Update-NinjaOneLocation {
    <#
        .SYNOPSIS
            Updates location information, like name, address, description etc.
        .DESCRIPTION
            Updates location information using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the location information for.
        [Parameter(Mandatory = $true)]
        [Int]$organisationId,
        # The location to set the information for.
        [Parameter(Mandatory = $true)]
        [Int]$locationId,
        # The location information body object.
        [Parameter(Mandatory = $true)]
        [object]$locationInformation
    )
    try {
        $Resource = "v2/organization/$organisationId/locations/$locationId"
        $RequestParams = @{
            Resource = $Resource
            Body = $locationInformation
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        $LocationExists = $(Get-NinjaOneLocations -OrganisationId $organisationId | Where-Object { $_.id -eq $locationId }).Count -gt 0
        if ($OrganisationExists -and $LocationExists) {
            if ($PSCmdlet.ShouldProcess('Location information', 'Update')) {
                $LocationUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($LocationUpdate -eq 204) {
                    Write-Information "Location information for location $($locationId) updated successfully."
                }
            }
        } else {
            Throw "Organisation $($organisationId) or location $($locationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}