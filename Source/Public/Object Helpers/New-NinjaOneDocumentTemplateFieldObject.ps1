function New-NinjaOneDocumentTemplateFieldObject {
	<#
		.SYNOPSIS
			Create a new Document Template Field object.
		.DESCRIPTION
			Creates a new Document Template Field object containing required / specified properties / structure.
		.FUNCTIONALITY
			Document Template Field Object Helper
		.OUTPUTS
			[Object]

			A new Document Template Field or UI Element object.
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneDocumentTemplateFieldObject @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('nnodtfo')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The human readable label for the field.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 0)]
		[String]$label,
		# The machine readable name for the field. This is an immutable value.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 1)]
		[String]$name,
		# The description of the field.
		[Parameter(ParameterSetName = 'Field', Position = 2)]
		[String]$description,
		# The type of the field.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 3)]
		[ValidateSet('DROPDOWN', 'MULTI_SELECT', 'CHECKBOX', 'TEXT', 'TEXT_MULTILINE', 'TEXT_ENCRYPTED', 'NUMERIC', 'DECIMAL', 'DATE', 'DATE_TIME', 'TIME', 'ATTACHMENT', 'NODE_DROPDOWN', 'NODE_MULTI_SELECT', 'CLIENT_DROPDOWN', 'CLIENT_MULTI_SELECT', 'CLIENT_LOCATION_DROPDOWN', 'CLIENT_LOCATION_MULTI_SELECT', 'CLIENT_DOCUMENT_DROPDOWN', 'CLIENT_DOCUMENT_MULTI_SELECT', 'EMAIL', 'PHONE', 'IP_ADDRESS', 'WYSIWYG', 'URL')]
		[String]$type,
		# The technician permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 4)]
		[ValidateSet('NONE', 'EDITABLE', 'READ_ONLY')]
		[String]$technicianPermission = 'NONE',
		# The script permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 5)]
		[ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
		[String]$scriptPermission = 'NONE',
		# The API permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 6)]
		[ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
		[String]$apiPermission = 'NONE',
		# The default value for the field.
		[Parameter(ParameterSetName = 'Field', Position = 7)]
		[String]$defaultValue,
		# The field options (a.k.a the field content).
		[Parameter(ParameterSetName = 'Field', Position = 8)]
		[Object[]]$options,
		# When creating a UI element (e.g a title, separator or description box) this is the machine readable name of the UI element.
		[Parameter(Mandatory, ParameterSetName = 'UIElement', Position = 0)]
		[String]$elementName,
		# When creating a UI element (e.g a title, separator or description box) this is the value of the UI element.
		[Parameter(ParameterSetName = 'UIElement', Position = 1)]
		[String]$elementValue,
		# When creating a UI element (e.g a title, separator or description box) this is the type of the UI element.
		[Parameter(Mandatory, ParameterSetName = 'UIElement', Position = 2)]
		[ValidateSet('TITLE', 'SEPARATOR', 'DESCRIPTION')]
		[String]$elementType
	)
	process {
		if ($PSCmdlet.ParameterSetName -eq 'Field') {
			# Build our Document Template Field object as a hashtable.
			$DocumentTemplateField = @{}
			$DocumentTemplateField.Add('fieldLabel', $label)
			$DocumentTemplateField.Add('fieldName', $name)
			if ($description) {
				$DocumentTemplateField.Add('fieldDescription', $description)
			}
			$DocumentTemplateField.Add('fieldType', $type)
			$DocumentTemplateField.Add('fieldTechnicianPermission', $technicianPermission)
			$DocumentTemplateField.Add('fieldScriptPermission', $scriptPermission)
			$DocumentTemplateField.Add('fieldAPIPermission', $apiPermission)
			if ($defaultValue) {
				$DocumentTemplateField.Add('fieldDefaultValue', $defaultValue)
			}
			if ($options) {
				$DocumentTemplateField.Add('fieldContent', $options)
			}
			$OutputObject = [PSCustomObject]$DocumentTemplateField
		} elseif ($PSCmdlet.ParameterSetName -eq 'UIElement') {
			# Build our UI Element object as a hashtable.
			$UIElement = @{}
			$UIElement.Add('uiElementName', $elementName)
			if ($elementValue) {
				$UIElement.Add('uiElementValue', $elementValue)
			}
			$UIElement.Add('uiElementType', $elementType)
			$OutputObject = [PSCustomObject]$UIElement
		}
		$OutputObject.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		return $OutputObject
	}
}
