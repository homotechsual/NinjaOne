<#
using namespace System.Management.Automation
class NinjaOneOrganisationDocument {
    [Int]$documentId
    [String]$documentName
    [String]$documentDescription
    [NinjaOneCustomField[]]$fields
    [Int]$documentTemplateId
    [Int]$organisationId
    # New object contructors.
    ## Full object constructor.
    NinjaOneOrganisationDocument(
        [String]$documentName,
        [String]$documentDescription,
        [NinjaOneCustomField[]]$fields,
        [Int]$documentTemplateId,
        [Int]$organisationId
    ) {
        $this.documentName = $documentName
        $this.documentDescription = $documentDescription
        $this.fields = $fields
        $this.documentTemplateId = $documentTemplateId
        $this.organisationId = $organisationId
    }
    ## No template id constructor.
    NinjaOneOrganisationDocument(
        [String]$documentName,
        [String]$documentDescription,
        [NinjaOneCustomField[]]$fields,
        [Int]$organisationId
    ) {
        $this.documentName = $documentName
        $this.documentDescription = $documentDescription
        $this.fields = $fields
        $this.organisationId = $organisationId
    }
    ## No description constructor.
    NinjaOneOrganisationDocument(
        [String]$documentName,
        [NinjaOneCustomField[]]$fields,
        [Int]$documentTemplateId,
        [Int]$organisationId
    ) {
        $this.documentName = $documentName
        $this.fields = $fields
        $this.documentTemplateId = $documentTemplateId
        $this.organisationId = $organisationId
    }
    ## No template id or description constructor.
    NinjaOneOrganisationDocument(
        [String]$documentName,
        [NinjaOneCustomField[]]$fields,
        [Int]$organisationId
    ) {
        $this.documentName = $documentName
        $this.fields = $fields
        $this.organisationId = $organisationId
    }
    # Update object contructors.
    ## Full object constructor.
    NinjaOneOrganisationDocument(
        [Int]$documentId,
        [String]$documentName,
        [String]$documentDescription,
        [NinjaOneCustomField[]]$fields,
        [Int]$organisationId
    ) {
        $this.documentId = $documentId
        $this.documentName = $documentName
        $this.documentDescription = $documentDescription
        $this.fields = $fields
        $this.organisationId = $organisationId
    }
    ## 
}
#>