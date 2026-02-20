function Invoke-NinjaOneSoftwareLicenseUpsert {
	<#
		.SYNOPSIS
			Creates or updates a software license.
		.DESCRIPTION
			Creates or updates a software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> Invoke-NinjaOneSoftwareLicenseUpsert -License @{ name = 'Microsoft Office'; description = 'Office 365' }

			Creates or updates a software license.
		.OUTPUTS
			A PowerShell object containing the created or updated software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/softwarelicense-upsert
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inoosl-upsert', 'inoosl')]
	[MetadataAttribute(
		'/v2/software-license/upsert',
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
			$Resource = 'v2/software-license/upsert'
			$RequestParams = @{ Resource = $Resource; Body = $License }
			if ($PSCmdlet.ShouldProcess('Software License', 'Upsert')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
