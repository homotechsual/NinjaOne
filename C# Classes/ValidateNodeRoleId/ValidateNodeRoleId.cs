using System.Management.Automation;

class ValidateNodeRoleId : ValidateEnumeratedArgumentsAttribute {
    protected override void ValidateElement(object element) {
        if (element is null) {
            throw new ValidationMetadataException("Element is null.");
        }
        if (((string)element != "auto") && !(element is int)) {
            throw new ValidationMetadataException("Element is not 'auto' or an integer.");
        }
    }
}