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
    [Alias('nnoo', 'New-NinjaOneOrganization')]
    [Metadata(
        '/v2/organizations',
        'post'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The Id of the organisation to use as a template.
        [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('templateOrganizationId', 'templateId')]
        [String]$templateOrganisationId,
        # An object containing the organisation to create.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('organization', 'body')]
        [Object]$organisation,
        # Show the organisation that was created.
        [Switch]$show
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'organisation=' parameter by removing it from the set parameters.
        if ($organisation) {
            $Parameters.Remove('organisation') | Out-Null
        }
        # Workaround to prevent the query string processor from adding a 'show=' parameter by removing it from the set parameters.
        if ($show) {
            $Parameters.Remove('show') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
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
}