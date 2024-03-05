using namespace System.Management.Automation
class NinjaOneDocumentTemplateField {
    # The human readable label for the field.
    [String]$fieldLabel
    # The machine readable name for the field. This is an immutable value.
    [String]$fieldName
    # The description of the field.
    [String]$fieldDescription
    # The type of the field.
    [ValidateSet('DROPDOWN', 'MULTI_SELECT', 'CHECKBOX', 'TEXT', 'TEXT_MULTILINE', 'TEXT_ENCRYPTED', 'NUMERIC', 'DECIMAL', 'DATE', 'DATE_TIME', 'TIME', 'ATTACHMENT', 'NODE_DROPDOWN', 'NODE_MULTI_SELECT', 'CLIENT_DROPDOWN', 'CLIENT_MULTI_SELECT', 'CLIENT_LOCATION_DROPDOWN', 'CLIENT_LOCATION_MULTI_SELECT', 'CLIENT_DOCUMENT_DROPDOWN', 'CLIENT_DOCUMENT_MULTI_SELECT', 'EMAIL', 'PHONE', 'IP_ADDRESS', 'WYSIWYG', 'URL')]
    [String]$fieldType
    # The technician permissions for the field.
    [ValidateSet('NONE', 'EDITABLE', 'READ_ONLY')]
    [String]$fieldTechnicianPermission
    # The script permissions for the field.
    [ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
    [String]$fieldScriptPermission
    # The API permissions for the field.
    [ValidateSet('NONE', 'READ_ONLY', 'WRITE_ONLY', 'READ_WRITE')]
    [String]$fieldAPIPermission
    # The default value for the field.
    [String]$fieldDefaultValue
    # The field content for the field (a.k.a the field options).
    [Object[]]$fieldContent
    # When creating a UI element (e.g a title, separator or description box) this is the machine readable name of the UI element.
    [String]$uiElementName
    # When creating a UI element (e.g a title, separator or description box) this is the value of the UI element.
    [String]$uiElementValue
    # When creating a UI element (e.g a title, separator or description box) this is the type of the UI element.
    [ValidateSet('TITLE', 'SEPARATOR', 'DESCRIPTION')]
    [String]$uiElementType

    # Full object constructor.
    NinjaOneDocumentTemplateField(
        [String]$fieldLabel,
        [String]$fieldName,
        [String]$fieldDescription,
        [String]$fieldType,
        [String]$fieldTechnicianPermission,
        [String]$fieldScriptPermission,
        [String]$fieldAPIPermission,
        [String]$fieldDefaultValue,
        [Object[]]$fieldContent,
        [String]$uiElementName,
        [String]$uiElementValue,
        [String]$uiElementType
    ) {
        $this.fieldLabel = $fieldLabel
        $this.fieldName = $fieldName
        $this.fieldDescription = $fieldDescription
        $this.fieldType = $fieldType
        $this.fieldTechnicianPermission = $fieldTechnicianPermission
        $this.fieldScriptPermission = $fieldScriptPermission
        $this.fieldAPIPermission = $fieldAPIPermission
        $this.fieldDefaultValue = $fieldDefaultValue
        $this.fieldContent = $fieldContent
        $this.uiElementName = $uiElementName
        $this.uiElementValue = $uiElementValue
        $this.uiElementType = $uiElementType
    }
}