function New-NinjaOneOrganisation {
    <#
        .SYNOPSIS
            Creates a new organisation using the NinjaOne API.
        .DESCRIPTION
            Create an organisation using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The ID of the organisation to use as a template.
        [Alias('templateOrganizationId')]
        [string]$templateOrganisationId,
        # An object containing the organisation to create.
        [Parameter(Mandatory = $true)]
        [Alias('organization', 'body')]
        [object]$organisation,
        # Show the organisation that was created.
        [switch]$show
    )
    try {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        if ($organisation) {
            $Parameters.Remove('organisation') | Out-Null
        }
        if ($show) {
            $Parameters.Remove('show') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/organizations'
        $RequestParams = @{
            Resource = $Resource
            Body = $organisation
            QSCollection = $QSCollection
        }
        if ($PSCmdlet.ShouldProcess("Organisation '$($organisation.name)'", 'Create')) {
            $OrganisationCreate = New-NinjaOnePOSTRequest @RequestParams
            if ($show) {
                Return $OrganisationCreate
            } else {
                Write-Information "Organisation '$($OrganisationCreate.name)' created."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}