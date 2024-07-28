
function Get-NinjaOneSoftwareProducts {
	<#
		.SYNOPSIS
			Gets software products from the NinjaOne API.
		.DESCRIPTION
			Retrieves software products from the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Products
		.EXAMPLE
			PS> Get-NinjaOneSoftwareProducts

			Gets all software products.
		.EXAMPLE
			PS> Get-NinjaOneSoftwareProducts -deviceId 1

			Gets all software products for the device with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwareproducts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnosp')]
	[MetadataAttribute(
		'/v2/software-products',
		'get',
		'/v2/device/{id}/software',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device id to get software products for.
		[Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
		$Parameters.Remove('deviceId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($deviceId) {
				Write-Verbose ('Getting software products for device {0}.' -f $deviceId)
				$Resource = ('v2/device/{0}/software' -f $deviceId)
			} else {
				Write-Verbose 'Retrieving all software products.'
				$Resource = 'v2/software-products'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$SoftwareProductResults = New-NinjaOneGETRequest @RequestParams
			if ($SoftwareProductResults) {
				return $SoftwareProductResults
			} else {
				if ($deviceId) {
					throw ('No software products found for device {0}.' -f $deviceId)
				} else {
					throw 'No software products found.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}