function Get-NinjaOneComputerSystems {
	<#
		.SYNOPSIS
			Gets the computer systems from the NinjaOne API.
		.DESCRIPTION
			Retrieves the computer systems from the NinjaOne v2 API.
		.FUNCTIONALITY
			Computer Systems Query
		.EXAMPLE
			PS> Get-NinjaOneComputerSystems

			Gets all computer systems.
		.EXAMPLE
			PS> Get-NinjaOneComputerSystems -deviceFilter 'org = 1'

			Gets the computer systems for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneComputerSystems -timeStamp 1619712000

			Gets the computer systems with a monitoring timestamp at or after 1619712000.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/computersystemsquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnocs')]
	[MetadataAttribute(
		'/v2/queries/computer-systems',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
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
			$Resource = 'v2/queries/computer-systems'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$ComputerSystems = New-NinjaOneGETRequest @RequestParams
			if ($ComputerSystems) {
				return $ComputerSystems
			} else {
				throw 'No computer systems found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
