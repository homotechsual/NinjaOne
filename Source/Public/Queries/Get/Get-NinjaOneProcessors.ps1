function Get-NinjaOneProcessors {
	<#
		.SYNOPSIS
			Gets the processors from the NinjaOne API.
		.DESCRIPTION
			Retrieves the processors from the NinjaOne v2 API.
		.FUNCTIONALITY
			Processors Query
		.EXAMPLE
			PS> Get-NinjaOneProcessors

			Gets the processors.
		.EXAMPLE
			PS> Get-NinjaOneProcessors -deviceFilter 'org = 1'

			Gets the processors for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneProcessors -timeStamp 1619712000

			Gets the processors with a monitoring timestamp at or after 1619712000.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/processorsquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnop')]
	[MetadataAttribute(
		'/v2/queries/processors',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Filter devices.
		[Parameter(Position = 0)]
		[Alias('df')]
		[String]$deviceFilter,
		# Monitoring timestamp filter. PowerShell DateTime object.
		[Parameter(Position = 1)]
		[Alias('ts')]
		[DateTime]$timeStamp,
		# Monitoring timestamp filter. Unix Epoch time.
		[Parameter(Position = 1)]
		[Int]$timeStampUnixEpoch,
		# Cursor name.
		[Parameter(Position = 2)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 3)]
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
			$Resource = 'v2/queries/processors'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Processors = New-NinjaOneGETRequest @RequestParams
			if ($Processors) {
				return $Processors
			} else {
				throw 'No processors found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
