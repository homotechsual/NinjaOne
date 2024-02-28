<#
using namespace System.Management.Automation
class NinjaOneCustomField {
    [String]$name
    [Object]$value
    [Bool]$isHTML

    NinjaOneCustomField([String]$name, [Object]$value) {
        $this.name = $name
        $this.value = $value
    }

    NinjaOneCustomField([String]$name, [Object]$value, [Bool]$isHTML) {
        $this.name = $name
        $this.value = @{ html = $value }
    }
}
#>