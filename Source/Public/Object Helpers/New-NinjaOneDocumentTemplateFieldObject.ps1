function New-NinjaOneDocumentTemplateFieldObject {
	<#
		.SYNOPSIS
			Create a new Document Template Field object.
		.DESCRIPTION
			Creates a new Document Template Field object containing required / specified properties / structure.
		.OUTPUTS
			[DocumentTemplateField]

			A new Document Template Field or UI Element object.
	#>
	[CmdletBinding()]
	[OutputType([DocumentTemplateField])]
	[Alias('nnodtfo')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change system state, creates a new object.')]
	param(
		# The human readable label for the field.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 0)]
		[String]$Label,
		# The machine readable name for the field. This is an immutable value.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 1)]
		[String]$Name,
		# The description of the field.
		[Parameter(ParameterSetName = 'Field', Position = 2)]
		[String]$Description,
		# The type of the field.
		[Parameter(Mandatory, ParameterSetName = 'Field', Position = 3)]
		[ValidateSet('DROPDOWN', 'MULTI_SELECT', 'CHECKBOX', 'TEXT', 'TEXT_MULTILINE', 'TEXT_ENCRYPTED', 'NUMERIC', 'DECIMAL', 'DATE', 'DATE_TIME', 'TIME', 'ATTACHMENT', 'NODE_DROPDOWN', 'NODE_MULTI_SELECT', 'CLIENT_DROPDOWN', 'CLIENT_MULTI_SELECT', 'CLIENT_LOCATION_DROPDOWN', 'CLIENT_LOCATION_MULTI_SELECT', 'CLIENT_DOCUMENT_DROPDOWN', 'CLIENT_DOCUMENT_MULTI_SELECT', 'EMAIL', 'PHONE', 'IP_ADDRESS', 'WYSIWYG', 'URL')]
		[String]$Type,
		# The technician permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 4)]
		[ValidateSet('NONE', 'EDITABLE', 'READ_ONLY')]
		[String]$TechnicianPermission = 'NONE',
		# The script permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 5)]
		[ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
		[String]$ScriptPermission = 'NONE',
		# The API permissions for the field.
		[Parameter(ParameterSetName = 'Field', Position = 6)]
		[ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
		[String]$APIPermission = 'NONE',
		# The default value for the field.
		[Parameter(ParameterSetName = 'Field', Position = 7)]
		[String]$DefaultValue,
		# The field options (a.k.a the field content).
		[Parameter(ParameterSetName = 'Field', Position = 8)]
		[Object[]]$Options,
		# When creating a UI element (e.g a title, separator or description box) this is the machine readable name of the UI element.
		[Parameter(Mandatory, ParameterSetName = 'UIElement', Position = 0)]
		[String]$ElementName,
		# When creating a UI element (e.g a title, separator or description box) this is the value of the UI element.
		[Parameter(ParameterSetName = 'UIElement', Position = 1)]
		[String]$ElementValue,
		# When creating a UI element (e.g a title, separator or description box) this is the type of the UI element.
		[Parameter(Mandatory, ParameterSetName = 'UIElement', Position = 2)]
		[ValidateSet('TITLE', 'SEPARATOR', 'DESCRIPTION')]
		[String]$ElementType
	)
	process {
		if ($PSCmdlet.ParameterSetName -eq 'Field') {
			# Build our Document Template Field object as a hashtable.
			$DocumentTemplateField = @{}
			$DocumentTemplateField.Add('fieldLabel', $Label)
			$DocumentTemplateField.Add('fieldName', $Name)
			if ($Description) {
				$DocumentTemplateField.Add('fieldDescription', $Description)
			}
			$DocumentTemplateField.Add('fieldType', $Type)
			$DocumentTemplateField.Add('fieldTechnicianPermission', $TechnicianPermission)
			$DocumentTemplateField.Add('fieldScriptPermission', $ScriptPermission)
			$DocumentTemplateField.Add('fieldAPIPermission', $APIPermission)
			if ($DefaultValue) {
				$DocumentTemplateField.Add('fieldDefaultValue', $DefaultValue)
			}
			if ($Options) {
				$DocumentTemplateField.Add('fieldContent', $Options)
			}
			$OutputObject = [PSCustomObject]$DocumentTemplateField
		} elseif ($PSCmdlet.ParameterSetName -eq 'UIElement') {
			# Build our UI Element object as a hashtable.
			$UIElement = @{}
			$UIElement.Add('uiElementName', $ElementName)
			if ($ElementValue) {
				$UIElement.Add('uiElementValue', $ElementValue)
			}
			$UIElement.Add('uiElementType', $ElementType)
			$OutputObject = [PSCustomObject]$UIElement
		}
		$OutputObject.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		return $OutputObject
	}
}