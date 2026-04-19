function New-NinjaOneCustomFieldObject {
	<#
		.SYNOPSIS
			Create a new Custom Field object.
		.DESCRIPTION
			Creates a new Custom Field object containing required / specified properties / structure.
		.FUNCTIONALITY
			Custom Field Object Helper
		.OUTPUTS
			[Object]

			A new Custom Field object.
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneCustomFieldObject @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('nnodtfo')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The custom field name.
		[Parameter(Mandatory, Position = 0)]
		[String]$name,
		# The custom field value.
		[Parameter(Mandatory, Position = 1)]
		[Object]$value,
		# Is the custom field value HTML.
		[Parameter(Position = 2)]
		[Bool]$isHTML
	)
	process {
		if ($isHTML) {
			$OutputObject = [PSCustomObject]@{
				name = $name
				value = @{ html = $value }
			}
		} else {
			$OutputObject = [PSCustomObject]@{
				name = $name
				value = $value
			}
		}
		$OutputObject.PSTypeNames.Insert(0, 'CustomField')
		return $OutputObject
	}
}
