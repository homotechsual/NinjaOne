function New-NinjaOneEntityRelationObject {
	<#
		.SYNOPSIS
			Create a new Entity Relation object.
		.DESCRIPTION
			Creates a new Entity Relation object containing required / specified properties / structure.
		.FUNCTIONALITY
			Entity Relation Object Helper
		.OUTPUTS
			[Object]

			A new Entity Relation object.
	
	.EXAMPLE
		PS> $newObject = @{ entityType = 'device'; relationEntityType = 'organization' }
		PS> New-NinjaOneEntityRelationObject @newObject

		Creates a new entity relation object with the specified properties.

	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('nnorer')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The entity type of the relation.
		[Parameter(Mandatory, Position = 0)]
		[String]$EntityType,
		# The related entity type.
		[Parameter(Mandatory, Position = 1)]
		[String]$RelationEntityType,
		# The relation property name.
		[Parameter(Position = 2)]
		[String]$Property
	)
	process {
		$OutputObject = [PSCustomObject]@{
			entityType = $EntityType
			relationEntityType = $RelationEntityType
		}
		if ($Property) {
			$OutputObject | Add-Member -MemberType NoteProperty -Name 'property' -Value $Property
		}
		$OutputObject.PSTypeNames.Insert(0, 'EntityRelation')
		return $OutputObject
	}
}
