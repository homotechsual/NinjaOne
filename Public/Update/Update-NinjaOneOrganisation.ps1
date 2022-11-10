
using namespace System.Management.Automation
#Requires -Version 7
function Update-NinjaOneOrganisation {
    <#
        .SYNOPSIS
            Updates organisation information, like name, node approval mode etc.
        .DESCRIPTION
            Updates organisation information using the NinjaOne v2 API.
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
        [object]$organisationInformation
    )
    try {
        $Resource = "v2/organization/$organisationId"
        $RequestParams = @{
            Resource = $Resource
            Body = $organisationInformation
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        if ($OrganisationExists) {
            if ($PSCmdlet.ShouldProcess('Organisation information', 'Update')) {
                $OrganisationUpdate = New-NinjaOnePATCHRequest @RequestParams
                if ($OrganisationUpdate -eq 204) {
                    Write-Information "Organisation information for organisation $($organisationId) updated successfully."
                }
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}