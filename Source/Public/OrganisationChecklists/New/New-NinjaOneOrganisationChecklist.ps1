function New-NinjaOneOrganisationChecklist {
	<#
		.SYNOPSIS
			Creates an organisation checklist.
		.DESCRIPTION
			Creates a new organisation checklist via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> New-NinjaOneOrganisationChecklist -checklist @{ name = 'Onboarding'; items = @('Step1','Step2') }

			Creates an organisation checklist.
		.OUTPUTS
			A PowerShell object containing the created checklist.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisationchecklist
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoocl')]
	[MetadataAttribute(
		'/v2/organization/checklists',
		'post'
	)]
	param(
		# Checklist payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklist
	)
	process {
		try {
			$Resource = 'v2/organization/checklists'
			$RequestParams = @{ Resource = $Resource; Body = $checklist }
			if ($PSCmdlet.ShouldProcess('Organisation checklist', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

