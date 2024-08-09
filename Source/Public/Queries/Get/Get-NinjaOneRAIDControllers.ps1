function Get-NinjaOneRAIDControllers {
	<#
		.SYNOPSIS
			Gets the RAID controllers from the NinjaOne API.
		.DESCRIPTION
			Retrieves the RAID controllers from the NinjaOne v2 API.
		.FUNCTIONALITY
			RAID Controllers Query
		.EXAMPLE
			PS> Get-NinjaOneRAIDControllers

			Gets the RAID controllers.
		.EXAMPLE
			PS> Get-NinjaOneRAIDControllers -deviceFilter 'org = 1'

			Gets the RAID controllers for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneRAIDControllers -timeStamp 1619712000

			Gets the RAID controllers with a monitoring timestamp at or after 1619712000.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/raidcontrollersquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoraidc')]
	[MetadataAttribute(
		'/v2/queries/raid-controllers',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
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
			$Resource = 'v2/queries/raid-controllers'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$RAIDControllers = New-NinjaOneGETRequest @RequestParams
			if ($RAIDControllers) {
				return $RAIDControllers
			} else {
				throw 'No RAID controllers found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}