using System.Management.Automation;
public class ValidateStringOrInt : ValidateEnumeratedArgumentsAttribute {
    protected override void ValidateElement(object element) {
        if (element is null) {
            throw new ValidationMetadataException("Element is null.");
        }
        if (!(element is string) && !(element is int)) {
            throw new ValidationMetadataException("Element is not a string or integer.");
        }
    }
}
