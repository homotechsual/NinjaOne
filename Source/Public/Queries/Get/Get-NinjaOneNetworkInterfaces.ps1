function Get-NinjaOneNetworkInterfaces {
	<#
		.SYNOPSIS
			Gets the network interfaces from the NinjaOne API.
		.DESCRIPTION
			Retrieves the network interfaces for each device from the NinjaOne v2 API.
		.FUNCTIONALITY
			Network Interfaces Query
		.EXAMPLE
			PS> Get-NinjaOneNetworkInterfaces

			Gets all network interfaces.
		.EXAMPLE
			PS> Get-NinjaOneNetworkInterfaces -deviceFilter 'org = 1'

			Gets the network interfaces for all devices for the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/networkinterfacesquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoni')]
	[MetadataAttribute(
		'/v2/queries/network-interfaces',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter devices.
		[Parameter(Position = 0)]
		[Alias('df')]
		[String]$deviceFilter,
		# Cursor name.
		[Parameter(Position = 1)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 2)]
		[Int]$pageSize
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/queries/network-interfaces'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$NetworkInterfaces = New-NinjaOneGETRequest @RequestParams
			if ($NetworkInterfaces) {
				return $NetworkInterfaces
			} else {
				throw 'No network interfaces found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}