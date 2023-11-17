function New-NinjaOneOrganisation {
    <#
        .SYNOPSIS
            Creates a new organisation using the NinjaOne API.
        .DESCRIPTION
            Create an organisation using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisation
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The Id of the organisation to use as a template.
        [Parameter(Position = 0)]
        [Alias('templateOrganizationId')]
        [String]$templateOrganisationId,
        # An object containing the organisation to create.
        [Parameter(Mandatory, Position = 1)]
        [Alias('organization', 'body')]
        [Object]$organisation,
        # Show the organisation that was created.
        [Switch]$show
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
        if ($PSCmdlet.ShouldProcess(('Organisation {0}' -f $organisation.name), 'Create')) {
            $OrganisationCreate = New-NinjaOnePOSTRequest @RequestParams
            if ($show) {
                return $OrganisationCreate
            } else {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Organisation {0} created.' -f $OrganisationCreate.name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}