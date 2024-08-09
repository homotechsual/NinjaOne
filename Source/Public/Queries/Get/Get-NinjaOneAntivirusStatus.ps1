function Get-NinjaOneAntiVirusStatus {
	<#
		.SYNOPSIS
			Gets the antivirus status from the NinjaOne API.
		.DESCRIPTION
			Retrieves the antivirus status from the NinjaOne v2 API.
		.FUNCTIONALITY
			AntiVirus Status Query
		.EXAMPLE
			PS> Get-NinjaOneAntivirusStatus -deviceFilter 'org = 1'

			Gets the antivirus status for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneAntivirusStatus -timeStamp 1619712000

			Gets the antivirus status at or after the timestamp 1619712000.
		.EXAMPLE
			PS> Get-NinjaOneAntivirusStatus -productState 'ON'

			Gets the antivirus status where the product state is ON.
		.EXAMPLE
			PS> Get-NinjaOneAntivirusStatus -productName 'Microsoft Defender Antivirus'

			Gets the antivirus status where the antivirus product name is Microsoft Defender Antivirus.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/antivirusstatusquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoavs')]
	[MetadataAttribute(
		'/v2/queries/antivirus-status',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter devices.
		[Parameter(Position = 0)]
		[Alias('df')]
		[String]$deviceFilter,
		# Monitoring timestamp filter.
		[Parameter(Position = 1)]
		[Alias('ts')]
		[DateTime]$timeStamp,
		# Monitoring timestamp filter in unix time.
		[Parameter(Position = 1)]
		[int]$timeStampUnixEpoch,
		# Filter by product state.
		[Parameter(Position = 2)]
		[String]$productState,
		# Filter by product name.
		[Parameter(Position = 3, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$productName,
		# Cursor name.
		[Parameter(Position = 4)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 5)]
		[Int]$pageSize
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# If the [DateTime] parameter $timeStamp is set convert the value to a Unix Epoch.
		if ($timeStamp) {
			[int]$timeStamp = ConvertTo-UnixEpoch -DateTime $timeStamp
		}
		# If the Unix Epoch parameter $timeStampUnixEpoch is set assign the value to the $timeStamp variable and null $timeStampUnixEpoch.
		if ($timeStampUnixEpoch) {
			$Parameters.Remove('timeStampUnixEpoch') | Out-Null
			[int]$timeStamp = $timeStampUnixEpoch
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/queries/antivirus-status'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$AntivirusStatus = New-NinjaOneGETRequest @RequestParams
			if ($AntivirusStatus) {
				return $AntivirusStatus
			} else {
				throw 'No antivirus status found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}