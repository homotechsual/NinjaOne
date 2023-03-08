function New-NinjaOneLocation {
    <#
        .SYNOPSIS
            Creates a new location using the NinjaOne API.
        .DESCRIPTION
            Create an location using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organization ID to use when creating the location.
        [Parameter(Mandatory = $true)]
        [int]$organisationId,
        # An object containing the location  to create.
        [Parameter(Mandatory = $true)]
        [object]$location,
        # Show the location that was created.
        [switch]$show
    )
    try {
        $Resource = "v2/organizations/$organisationId/locations"
        $RequestParams = @{
            Resource = $Resource
            Body = $location
        }
        $OrganisationExists = (Get-NinjaOneOrganisation -Id $organisationId).Count -gt 0
        if ($OrganisationExists) {
            if ($PSCmdlet.ShouldProcess("Location '$($location.name)'", 'Create')) {
                $LocationCreate = New-NinjaOnePOSTRequest @RequestParams
                if ($show) {
                    Return $LocationCreate
                } else {
                    Write-Information "Location '$($LocationCreate.name)' created."
                }
            }
        } else {
            throw "Organisation '$organisationId' does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}