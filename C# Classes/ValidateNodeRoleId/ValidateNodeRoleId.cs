using System.Management.Automation;
public class ValidateNodeRoleId : ValidateEnumeratedArgumentsAttribute {
    protected override void ValidateElement(object element) {
        if (element is null) {
            throw new ValidationMetadataException("Element is null.");
        }
        if (!(element is int) || !(element is string)) {
            throw new ValidationMetadataException("Element is not an integer or string");
        }

        if ((element is int) && (((int)element) < 0)) {
            throw new ValidationMetadataException("Element is not a valid integer value");
        }

        if ((element is string) && !((string)element).Equals("auto")) {
            throw new ValidationMetadataException("Element string is not equal to auto");
        }
    }
}