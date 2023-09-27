function Get-NinjaOneRelatedItems {
    <#
        .SYNOPSIS
            Gets items related to an entity or entity type from the NinjaOne API.
        .DESCRIPTION
            Retrieves related items related to a given entity or entity type from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneRelatedItems -all

            Gets all related items.
        .EXAMPLE
            PS> Get-NinjaOneRelatedItems -relatedTo -entityType 'organization'

            Gets all items which have a relation to an organization.
        .EXAMPLE
            PS> Get-NinjaOneRelatedItems -relatedTo -entityType 'organization' -entityId 1

            Gets all items which have a relation to the organization with id 1.
        .EXAMPLE
            PS> Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization'

            Gets all items which have a relation from an organization.
        .EXAMPLE
            PS> Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization' -entityId 1

            Gets all items which have a relation from the organization with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Return all related items.
        [Parameter(ParameterSetName = 'all', Mandatory)]
        [switch]$all,
        # Find items related to the given entity type/id.
        [Parameter(ParameterSetName = 'relatedTo', Mandatory)]
        [switch]$relatedTo,
        # Find items with related entities of the given type/id.
        [Parameter(ParameterSetName = 'relatedFrom', Mandatory)]
        [switch]$relatedFrom,
        # The entity type to get related items for.
        [Parameter(ParameterSetName = 'relatedTo', Mandatory)]
        [Parameter(ParameterSetName = 'relatedFrom', Mandatory)]
        [ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
        [string]$entityType,
        # The entity ID to get related items for.
        [Parameter(ParameterSetName = 'relatedTo')]
        [Parameter(ParameterSetName = 'relatedFrom')]
        [int64]$entityId,
        # The scope of the related items.
        [Parameter(ParameterSetName = 'relatedTo')]
        [Parameter(ParameterSetName = 'relatedFrom')]
        [ValidateSet('ALL', 'RELATIONS', 'REFERENCES')]
        [string]$scope
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    $ParameterSetName = $PSBoundParameters.ParameterSetName
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        # Workaround to prevent the query string processor from adding an 'all=true' parameter by removing it from the set parameters.
        if ($all) {
            $Parameters.Remove('all') | Out-Null
        }
        # Similarly we don't want a `relatedTo=true` parameter since we're targetting a different resource.
        if ($relatedTo) {
            $Parameters.Remove('relatedTo') | Out-Null
        }
        # Similarly we don't want a `relatedFrom=true` parameter since we're targetting a different resource.
        if ($relatedFrom) {
            $Parameters.Remove('relatedFrom') | Out-Null
        }
        # Similarly we don't want a `entityType=` parameter since that's a path fragment.
        if ($entityType) {
            $Parameters.Remove('entityType') | Out-Null
        }
        # Similarly we don't want a `entityId=` parameter since that's a path fragment.
        if ($entityId) {
            $Parameters.Remove('entityId') | Out-Null
        }
        if ($ParameterSetName = 'all') {
            Write-Verbose 'Getting all related items from NinjaOne API.'
            $Resource = 'v2/related-items'
        } elseif ($ParameterSetName = 'relatedTo' -and $entityType -and $entityId) {
            Write-Verbose 'Getting items related to specific entity from NinjaOne API.'
            $Resource = "v2/related-items/with-entity/$($entityType)/$($entityId)"
        } elseif ($ParameterSetName = 'relatedTo' -and $entityType) {
            Write-Verbose 'Getting items related to specific entity type from NinjaOne API.'
            $Resource = "v2/related-items/with-entity-type/$($entityType)"
        } elseif ($ParameterSetName = 'relatedFrom' -and $entityType -and $entityId) {
            Write-Verbose 'Getting items with related entities of specific entity from NinjaOne API.'
            $Resource = "v2/related-items/with-related-entity/$($entityType)/$($entityId)"
        } elseif ($ParameterSetName = 'relatedFrom' -and $entityType) {
            Write-Verbose 'Getting items with related entities of specific entity type from NinjaOne API.'
            $Resource = "v2/related-items/with-related-entity-type/$($entityType)"
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $RelatedItemResults = New-NinjaOneGETRequest @RequestParams
        Return $RelatedItemResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}