using namespace System.Management.Automation
class ValidateNodeRoleId : ValidateEnumeratedArgumentsAttribute {
    [void]ValidateElement($Element) {
        if (-not($Element -eq [String]'auto' -or $Element -is [Int])) {
            throw [MetadataException]::new("Value '$Element' is not one of 'auto' or an integer.")
        }
    }
}