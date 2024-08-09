using System.Dynamic;

namespace NinjaOne {
    public enum FieldType {
        DROPDOWN = 1,
        MULTI_SELECT = 2,
        CHECKBOX = 3,
        TEXT = 4,
        TEXT_MULTILINE = 5,
        TEXT_ENCRYPTED = 6,
        NUMERIC = 7,
        DECIMAL = 8,
        DATE = 9,
        DATE_TIME = 10,
        TIME = 11,
        ATTACHMENT = 12,
        NODE_DROPDOWN = 13,
        NODE_MULTI_SELECT = 14,
        CLIENT_DROPDOWN = 15,
        CLIENT_MULTI_SELECT = 16,
        CLIENT_LOCATION_DROPDOWN = 17,
        CLIENT_LOCATION_MULTI_SELECT = 18,
        CLIENT_DOCUMENT_DROPDOWN = 19,
        CLIENT_DOCUMENT_MULTI_SELECT = 20,
        EMAIL = 21,
        PHONE = 22,
        IP_ADDRESS = 23,
        WYSIWYG = 24,
        URL = 25,
    }
    public enum TechnicianPermissionLevel {
        NONE = 1,
        EDITABLE = 2,
        READ_ONLY = 3,
    }
    public enum  ScriptAPIPermissionLevel {
        NONE = 1,
        READ_ONLY = 2,
        WRITE_ONLY = 3,
        READ_WRITE = 4,
    }
    public enum UIElementType {
        TITLE = 1,
        SEPARATOR = 2,
        DESCRIPTION = 3,
    }
    public class DocumentTemplateField {
        // The human readable label for the field.
        public string fieldLabel { get; set; }
        // The machine readable name for the field. This is an immutable value that is used to reference the field in the API.
        public string fieldName { get; set; }
        // The description of the field.
        public string fieldDescription { get; set; }
        // The type of the field. This is used to determine the type of value that can be stored in the field.
        public FieldType fieldType { get; set; }
        // The technician permission level for the field. This is used to determine the level of access that a technician has to the field.
        public string fieldTechnicianPermission { get; set; }
        // The script permission level for the field. This is used to determine the level of access that a script has to the field.
        public string fieldScriptPermission { get; set; }
        // The API permission level for the field. This is used to determine the level of access that the API has to the field.
        public string fieldAPIPermission { get; set; }
        // The default value for the field.
        public object fieldDefaultValue { get; set; }
        // The options for the field.
        public object[] fieldContent { get; set; }
        // When creating a UI element (e.g: a title) this is the machine readable name for the UI element.
        public string uiElementName { get; set; }
        // When creating a UI element (e.g: a title) this is the value for the UI element.
        public string uiElementValue { get; set; }
        // When creating a UI element (e.g: a title) this is the type of the UI element.
        public string uiElementType { get; set; }

        public DocumentTemplateField(string fieldLabel, string fieldName, FieldType fieldType, TechnicianPermissionLevel fieldTechnicianPermission = 1, ScriptAPIPermissionLevel fieldScriptPermission = 1, ScriptAPIPermissionLevel fieldAPIPermission = 1, object fieldDefaultValue = null, object[] fieldContent = null, string uiElementName = null, string uiElementValue = null, UIElementType uiElementType = 0, string fieldDescription = null) {
            if (uiElementType != 0) {
                this.uiElementType = uiElementType.ToString();
                this.uiElementName = uiElementName;
                if (uiElementValue != null) {
                    this.uiElementValue = uiElementValue;
                }
            } else {
                this.fieldLabel = fieldLabel;
                this.fieldName = fieldName;
                this.fieldType = fieldType;
                this.fieldTechnicianPermission = fieldTechnicianPermission.ToString();
                this.fieldScriptPermission = fieldScriptPermission.ToString();
                this.fieldAPIPermission = fieldAPIPermission.ToString();
                if (fieldDefaultValue != null) {
                    this.fieldDefaultValue = fieldDefaultValue;
                }
                if (fieldContent != null) {
                    this.fieldContent = fieldContent;
                }
                if (fieldDescription != null) {
                    this.fieldDescription = fieldDescription;
                }
            }
        }
    }
}
