function New-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Creates a new software license.
		.DESCRIPTION
			Creates a new software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> New-NinjaOneSoftwareLicense -License @{ name = 'Microsoft Office'; description = 'Office 365 subscriptions' }

			Creates a new software license.
		.OUTPUTS
			A PowerShell object containing the created software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/softwarelicense
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoosl')]
	[MetadataAttribute(
		'/v2/software-license',
		'post'
	)]
	param(
		# Software license configuration per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$License
	)
	process {
		try {
			$Resource = 'v2/software-license'
			$RequestParams = @{ Resource = $Resource; Body = $License }
			if ($PSCmdlet.ShouldProcess('Software License', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
