function Get-NinjaOneChecklistTemplates {
	<#
		.SYNOPSIS
			Gets checklist templates.
		.DESCRIPTION
			Retrieves checklist templates via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Get-NinjaOneChecklistTemplates

			Gets all checklist templates.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/checklisttemplates
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoclt')]
	[MetadataAttribute(
		'/v2/checklist/templates',
		'get'
	)]
	Param()
	process {
		try {
			$Resource = 'v2/checklist/templates'
			$RequestParams = @{ Resource = $Resource }
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) { return $Results } else { throw 'No checklist templates found.' }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
