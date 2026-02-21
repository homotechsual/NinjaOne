function Get-NinjaOneRAIDDrives {
	<#
		.SYNOPSIS
			Gets the RAID drives from the NinjaOne API.
		.DESCRIPTION
			Retrieves the RAID drives from the NinjaOne v2 API.
		.FUNCTIONALITY
			RAID Drives Query
		.EXAMPLE
			PS> Get-NinjaOneRAIDDrives

			Gets the RAID drives.
		.EXAMPLE
			PS> Get-NinjaOneRAIDDrives -deviceFilter 'org = 1'

			Gets the RAID drives for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneRAIDDrives -timeStamp 1619712000

			Gets the RAID drives with a monitoring timestamp at or after 1619712000.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/raiddrivesquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoraidd')]
	[MetadataAttribute(
		'/v2/queries/raid-drives',
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
			$Resource = 'v2/queries/raid-drives'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$RAIDDrives = New-NinjaOneGETRequest @RequestParams
			if ($RAIDDrives) {
				return $RAIDDrives
			} else {
				throw 'No RAID drives found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
