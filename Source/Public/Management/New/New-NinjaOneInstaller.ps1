function New-NinjaOneInstaller {
	<#
		.SYNOPSIS
			Creates a new installer using the NinjaOne API.
		.DESCRIPTION
			Create a new installer download link using the NinjaOne v2 API.
		.FUNCTIONALITY
			Installer
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				installerType = "WINDOWS_MSI"
				locationId = 0
				content = @{
					nodeRoleId = "string"
				}
				organizationId = 0
				usageLimit = 0
			}
			PS> New-NinjaOneInstaller -installer $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/installer
	#>
	[CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
	[OutputType([Object])]
	[Alias('nnoi')]
	[MetadataAttribute(
		'/v2/organization/generate-installer',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organization id to use when creating the installer.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The location id to use when creating the installer.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[Int]$locationId,
		# The installer type to use when creating the installer.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[ValidateSet('WINDOWS_MSI', 'MAC_DMG', 'MAC_PKG', 'LINUX_DEB', 'LINUX_RPM')]
		[String]$installerType,
		# The node role id to use when creating the installer.
		[Parameter(Position = 3, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[ValidateNodeRoleId()]
		[Object]$nodeRoleId = 'auto',
		# The installer body object (alternative to individual parameters).
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Body')]
		[Alias('body')]
		[Object]$installer
	)
	process {
		try {
			$Resource = 'v2/organization/generate-installer'
			if ($PSCmdlet.ParameterSetName -eq 'Body') {
				$InstallerBody = $installer
				# Extract organisation and location IDs for validation if they exist in the body
				if ($installer.organization_id) {
					$organisationId = $installer.organization_id
				} elseif ($installer.organizationId) {
					$organisationId = $installer.organizationId
				}
				if ($installer.location_id) {
					$locationId = $installer.location_id
				} elseif ($installer.locationId) {
					$locationId = $installer.locationId
				}
			} else {
				$InstallerBody = @{
					organization_id = $organisationId
					location_id = $locationId
					installer_type = $installerType
					# usage_limit = $usageLimit
					content = @{
						nodeRoleId = $nodeRoleId
					}
				}
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $InstallerBody
			}
			if ($organisationId -and $locationId) {
				$OrganisationExists = @(Get-NinjaOneOrganisations -organisationId $organisationId).Count -gt 0
				$LocationExists = @(Get-NinjaOneLocations -organisationId $organisationId | Where-Object { $_.id -eq $locationId }).Count -gt 0
				if ($OrganisationExists -and $LocationExists) {
					if ($PSCmdlet.ShouldProcess('Installer', 'Create')) {
						$InstallerCreate = New-NinjaOnePOSTRequest @RequestParams
						return $InstallerCreate.url
					}
				} else {
					throw "Organisation '$organisationId' or location '$locationId' does not exist."
				}
			} else {
				# If body provided without validation IDs, proceed without validation
				if ($PSCmdlet.ShouldProcess('Installer', 'Create')) {
					$InstallerCreate = New-NinjaOnePOSTRequest @RequestParams
					return $InstallerCreate.url
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}












