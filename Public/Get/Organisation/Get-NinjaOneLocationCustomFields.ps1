function Get-NinjaOneLocationCustomFields {
    <#
        .SYNOPSIS
            Gets location custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves location custom fields from the NinjaOne v2 API.
        .EXAMPLE
            Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2

            Gets custom field details for the location with id 2 belonging to the organisation with id 1.
        .EXAMPLE
            Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2 -withInheritance

            Gets custom field details for the location with id 2 belonging to the organisation with id 1 and inherits values from parent organisation, if no value is set for the location you will get the value from the parent organisation.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by organisation ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # Filter by location ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Int]$locationId,
        # Inherit custom field values from parent organisation.
        [Boolean]$withInheritance
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
        if ($organisationId) {
            $Parameters.Remove('organisationId') | Out-Null
        }
        # Workaround to prevent the query string processor from adding an 'locationid=' parameter by removing it from the set parameters.
        if ($locationId) {
            $Parameters.Remove('locationId') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting organisation custom fields from NinjaOne API.'
        $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
        if ($Organisation) {
            $Location = Get-NinjaOneLocations -organisationId $organisationId | Where-Object -Property id -EQ -Value $locationId
            if ($Location) {
                Write-Verbose "Retrieving custom fields for organisation $($Organisation.Name) location $($Location.Name)."
                $Resource = "v2/organization/$($organisationId)/location/$($locationId)/custom-fields"
            } else {
                Throw "Location $($locationId) does not exist for organisation $($Organisation.Name)."
            }
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $CustomFieldResults = New-NinjaOneGETRequest @RequestParams
        Return $CustomFieldResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}