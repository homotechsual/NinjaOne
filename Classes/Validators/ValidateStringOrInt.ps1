using namespace System.Management.Automation
class ValidateStringOrInt : ValidateEnumeratedArgumentsAttribute {
    [void]ValidateElement($Element) {
        if (-not($Element -is [String] -or $Element -is [Int])) {
            throw [MetadataException]::new("Value '$Element' is not a string or integer.")
        }
    }
}