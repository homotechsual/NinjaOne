function Get-NinjaOneRelatedItems {
    <#
        .SYNOPSIS
            Gets items related to an entity or entity type from the NinjaOne API.
        .DESCRIPTION
            Retrieves related items related to a given entity or entity type from the NinjaOne v2 API.
        .FUNCTIONALITY
            Related Items
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
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditems
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnori')]
    [MetadataAttribute(
        '/v2/related-items',
        'get',
        '/v2/related-items/with-entity/{entityType}/{entityId}',
        'get',
        '/v2/related-items/with-entity-type/{entityType}',
        'get',
        '/v2/related-items/with-related-entity/{relEntityType}/{relEntityId}',
        'get',
        '/v2/related-items/with-related-entity-type/{relatedEntityType}',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Return all related items.
        [Parameter(Mandatory, ParameterSetName = 'all')]
        [Switch]$all,
        # Find items related to the given entity type/id.
        [Parameter(Mandatory, ParameterSetName = 'relatedTo')]
        [Switch]$relatedTo,
        # Find items with related entities of the given type/id.
        [Parameter(Mandatory, ParameterSetName = 'relatedFrom')]
        [Switch]$relatedFrom,
        # The entity type to get related items for.
        [Parameter(Mandatory, ParameterSetName = 'relatedTo', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'relatedFrom', Position = 0)]
        [ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
        [String]$entityType,
        # The entity id to get related items for.
        [Parameter(ParameterSetName = 'relatedTo', Position = 1)]
        [Parameter(ParameterSetName = 'relatedFrom', Position = 1)]
        [Int64]$entityId,
        # The scope of the related items.
        [Parameter(ParameterSetName = 'relatedTo', Position = 2)]
        [Parameter(ParameterSetName = 'relatedFrom', Position = 2)]
        [ValidateSet('ALL', 'RELATIONS', 'REFERENCES')]
        [String]$scope
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
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
    }
    process {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'all') {
                Write-Verbose 'Getting all related items from NinjaOne API.'
                $Resource = 'v2/related-items'
            } elseif ($PSCmdlet.ParameterSetName -eq 'relatedTo' -and $entityType -and $entityId) {
                Write-Verbose ('Getting items related to entity of type {0} with id {1}.' -f $entityType, $entityId)
                $Resource = ('v2/related-items/with-entity/{0}/{1}' -f $entityType, $entityId)
            } elseif ($PSCmdlet.ParameterSetName -eq 'relatedTo' -and $entityType) {
                Write-Verbose ('Getting items related to entity of type {0}.' -f $entityType)
                $Resource = ('v2/related-items/with-entity-type/{0}' -f $entityType)
            } elseif ($PSCmdlet.ParameterSetName -eq 'relatedFrom' -and $entityType -and $entityId) {
                Write-Verbose ('Getting items with related entities of type {0} with id {1}.' -f $entityType, $entityId)
                $Resource = ('v2/related-items/with-related-entity/{0}/{1}' -f $entityType, $entityId)
            } elseif ($PSCmdlet.ParameterSetName -eq 'relatedFrom' -and $entityType) {
                Write-Verbose ('Getting items with related entities of type {0}.' -f $entityType)
                $Resource = ('v2/related-items/with-related-entity-type/{0}' -f $entityType)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $RelatedItemResults = New-NinjaOneGETRequest @RequestParams
            if ($RelatedItemResults) {
                return $RelatedItemResults
            } else {
                throw 'No related items found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}