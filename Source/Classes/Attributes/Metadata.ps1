class Metadata : System.Attribute {
    [string[]]$Metadata

    Metadata() {}

    Metadata([String[]]$Metadata) { 
        $this.Metadata = $Metadata
    }
}