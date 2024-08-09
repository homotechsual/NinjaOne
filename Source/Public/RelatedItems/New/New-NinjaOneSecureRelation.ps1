function New-NinjaOneSecureRelation {
	<#
		.SYNOPSIS
			Creates a new secure value relation using the NinjaOne API.
		.DESCRIPTION
			Create a new secure value relation using the NinjaOne v2 API.
		.FUNCTIONALITY
			Secure Value Relation
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/securevaluerelation
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnosr')]
	[MetadataAttribute(
		'/v2/related-items/entity/{entityType}/{entityId}/secure',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUsernameAndPasswordParams', '', Justification = 'Secure value relation requires username and password parameters.')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Secure value relation requires a plain text password parameter.')]
	Param(
		# The entity type to create the secre relation for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id to create the secucre relation for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId,
		# The name of the secure value.
		[Parameter(Mandatory, Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('name')]
		[String]$secureValueName,
		# The URL for the secure value.
		[Parameter(Position = 3, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('url', 'uri')]
		[String]$secureValueURL,
		# Notes to accompany the secure value.
		[Parameter(Position = 4, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('notes')]
		[String]$secureValueNotes,
		# The username for the secure value.
		[Parameter(Position = 5, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('username')]
		[String]$secureValueUsername,
		# The password for the secure value.
		[Parameter(Position = 6, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('password')]
		[String]$secureValuePassword,
		# Show the secure relation that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/related-items/entity/{0}/{1}/secure' -f $entityType, $entityId)
			$Body = @{
				name = $secureValueName
			}
			if ($secureValueURL) {
				$Body.url = $secureValueURL
			}
			if ($secureValueNotes) {
				$Body.notes = $secureValueNotes
			}
			if ($secureValueUsername) {
				$Body.username = $secureValueUsername
			}
			if ($secureValuePassword) {
				$Body.password = $secureValuePassword
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ShouldProcess(('Secure relation for {0} with id {1}' -f $entityType, $entityId), 'Create')) {
				$SecureRelationCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $SecureRelationCreate
				} else {
					$OIP = $InformationPreference
					$InformationPreference = 'Continue'
					Write-Information ('Secure relation between {0} and {2} with id {3} created.' -f $entityType, $entityId, $secureValueName)
					$InformationPreference = $OIP
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}