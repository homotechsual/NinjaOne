using namespace System.Management.Automation

<#
	.SYNOPSIS
		Represents a NinjaOne organisation document object.

	.DESCRIPTION
		Defines the structure of a NinjaOne organisation document including metadata,
		fields, and template associations. Provides multiple constructors for different
		object creation scenarios.

	.NOTES
		This is an internal class used for deserializing document data from the NinjaOne API.
#>
class NinjaOneOrganisationDocument {
	[Int]$documentId
	[String]$documentName
	[String]$documentDescription
	[Object[]]$fields
	[Int]$documentTemplateId
	[Int]$organisationId

	# New object constructors.
	# Full object constructor.
	NinjaOneOrganisationDocument(
		[String]$documentName,
		[String]$documentDescription,
		[Object[]]$fields,
		[Int]$documentTemplateId,
		[Int]$organisationId
	) {
		$this.documentName = $documentName
		$this.documentDescription = $documentDescription
		$this.fields = $fields
		$this.documentTemplateId = $documentTemplateId
		$this.organisationId = $organisationId
	}

	# No template id constructor.
	NinjaOneOrganisationDocument(
		[String]$documentName,
		[String]$documentDescription,
		[Object[]]$fields,
		[Int]$organisationId
	) {
		$this.documentName = $documentName
		$this.documentDescription = $documentDescription
		$this.fields = $fields
		$this.organisationId = $organisationId
	}

	# No description constructor.
	NinjaOneOrganisationDocument(
		[String]$documentName,
		[Object[]]$fields,
		[Int]$documentTemplateId,
		[Int]$organisationId
	) {
		$this.documentName = $documentName
		$this.fields = $fields
		$this.documentTemplateId = $documentTemplateId
		$this.organisationId = $organisationId
	}

	# No template id or description constructor.
	NinjaOneOrganisationDocument(
		[String]$documentName,
		[Object[]]$fields,
		[Int]$organisationId
	) {
		$this.documentName = $documentName
		$this.fields = $fields
		$this.organisationId = $organisationId
	}

	# Update object constructors.
	# Full object constructor.
	NinjaOneOrganisationDocument(
		[Int]$documentId,
		[String]$documentName,
		[String]$documentDescription,
		[Object[]]$fields,
		[Int]$organisationId
	) {
		$this.documentId = $documentId
		$this.documentName = $documentName
		$this.documentDescription = $documentDescription
		$this.fields = $fields
		$this.organisationId = $organisationId
	}
}