#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '6.1.0'; MaximumVersion = '6.999' }

$ModuleName = 'NinjaOne'
$RepoRoot = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\')).Path
$ModulePath = $env:NINJAONE_MODULE_MANIFEST
if ([string]::IsNullOrWhiteSpace($ModulePath)) {
	$ModulePath = Get-ChildItem -Path ('{0}\Output\{1}\*\{1}.psd1' -f $RepoRoot, $ModuleName) -ErrorAction Stop | Select-Object -Last 1 -ExpandProperty FullName
}

Describe 'Set-NinjaOneOrganisation' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id} with the supplied body' {
		Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'Acme' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/7'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'Acme' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'org-patch-failed' }
		{ Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'X' } -Confirm:$false } | Pester\Should -Throw '*org-patch-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneLocation' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id}/locations/{locationId} with the supplied body' {
		Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'HQ' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/3/locations/9'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'HQ' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'location-patch-failed' }
		{ Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'X' } -Confirm:$false } | Pester\Should -Throw '*location-patch-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDevice' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/device/{id} with the supplied body' {
		Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'WebServer01' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/42'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'WebServer01' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'device-patch-failed' }
		{ Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'X' } -Confirm:$false } | Pester\Should -Throw '*device-patch-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneOrganisationCustomFields' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id}/custom-fields with the supplied body' {
		Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ field1 = 'val1' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/5/custom-fields'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ f = 'v' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'orgcf-patch-failed' }
		{ Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ f = 'v' } -Confirm:$false } | Pester\Should -Throw '*orgcf-patch-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceCustomFields' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/device/{id}/custom-fields with the supplied body' {
		Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ field1 = 'val1' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/11/custom-fields'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ f = 'v' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'devcf-patch-failed' }
		{ Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ f = 'v' } -Confirm:$false } | Pester\Should -Throw '*devcf-patch-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneTicket' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { return [PSCustomObject]@{ id = 99; subject = 'Test ticket' } }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST /v2/ticketing/ticket with the ticket body' {
		New-NinjaOneTicket -ticket @{ subject = 'Test' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket'
		}
	}

	It 'returns the created ticket when -show is specified' {
		$result = New-NinjaOneTicket -ticket @{ subject = 'Test' } -show -Confirm:$false
		$result.id | Pester\Should -Be 99
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'ticket-post-failed' }
		{ New-NinjaOneTicket -ticket @{ subject = 'Test' } -Confirm:$false } | Pester\Should -Throw '*ticket-post-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneTicket' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT /v2/ticketing/ticket/{ticketId} with the ticket body' {
		Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'Updated' } -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/50'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'Updated' } -Confirm:$false } | Pester\Should -Not -Throw
	}

	It 'delegates PUT failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'ticket-put-failed' }
		{ Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'X' } -Confirm:$false } | Pester\Should -Throw '*ticket-put-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceApproval' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST /v2/devices/approval/APPROVE with the device id list' {
		Set-NinjaOneDeviceApproval -mode 'APPROVE' -deviceIds @(1, 2) -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices/approval/APPROVE'
		}
	}

	It 'calls POST /v2/devices/approval/REJECT for reject mode' {
		Set-NinjaOneDeviceApproval -mode 'REJECT' -deviceIds @(3) -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices/approval/REJECT'
		}
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'approval-post-failed' }
		{ Set-NinjaOneDeviceApproval -mode 'APPROVE' -deviceIds @(1) -Confirm:$false } | Pester\Should -Throw '*approval-post-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneOrganisationPolicies' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT /v2/organization/{id}/policies for Single parameter set' {
		Set-NinjaOneOrganisationPolicies -organisationId 4 -nodeRoleId 10 -policyId 20 -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/4/policies'
		}
	}

	It 'calls PUT /v2/organization/{id}/policies for Multiple parameter set' {
		$assignments = @(@{ nodeRoleId = 10; policyId = 20 }, @{ nodeRoleId = 11; policyId = 21 })
		Set-NinjaOneOrganisationPolicies -organisationId 4 -policyAssignments $assignments -Confirm:$false
		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/4/policies'
		}
	}

	It 'delegates PUT failures to New-NinjaOneError for Single parameter set' {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'policies-put-failed' }
		{ Set-NinjaOneOrganisationPolicies -organisationId 4 -nodeRoleId 10 -policyId 20 -Confirm:$false } | Pester\Should -Throw '*policies-put-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceDisks' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'Disk0' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device disks endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceDisks -deviceId 88

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/88/disks'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-disks-failed' }

		{ Get-NinjaOneDeviceDisks -deviceId 88 } | Pester\Should -Throw '*device-disks-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceNetworkInterfaces' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'Ethernet0' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device network interfaces endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceNetworkInterfaces -deviceId 55

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/55/network-interfaces'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-nics-failed' }

		{ Get-NinjaOneDeviceNetworkInterfaces -deviceId 55 } | Pester\Should -Throw '*device-nics-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceVolumes' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'C:' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device volumes endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceVolumes -deviceId 101

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/101/volumes'
		}
	}

	It 'passes include as a query parameter' {
		$null = Get-NinjaOneDeviceVolumes -deviceId 101 -include 'bl'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('include')
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-volumes-failed' }

		{ Get-NinjaOneDeviceVolumes -deviceId 101 } | Pester\Should -Throw '*device-volumes-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketAttributes' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Priority' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticket attributes endpoint' {
		$null = Get-NinjaOneTicketAttributes

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/attributes'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketAttributes } | Pester\Should -Throw '*No ticket attributes found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketBoards' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 10; name = 'Default Board' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticket boards endpoint' {
		$null = Get-NinjaOneTicketBoards

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/trigger/boards'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketBoards } | Pester\Should -Throw '*No boards found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketStatuses' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 20; name = 'Open' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticket statuses endpoint and returns statuses' {
		$result = Get-NinjaOneTicketStatuses

		$result[0].name | Pester\Should -Be 'Open'
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/statuses'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketStatuses } | Pester\Should -Throw '*No ticket statuses found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Additional single-resource query coverage' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ id = 25; resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets an end user by id' {
		$result = Get-NinjaOneEndUser -id 25

		$result.resource | Pester\Should -Be 'v2/user/end-user/25'
	}

	It 'delegates missing end user results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneEndUser -id 25 } | Pester\Should -Throw '*End user 25 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets a technician by id' {
		$result = Get-NinjaOneTechnician -id 26

		$result.resource | Pester\Should -Be 'v2/user/technician/26'
	}

	It 'delegates missing technician results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTechnician -id 26 } | Pester\Should -Throw '*Technician 26 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets a tab by id' {
		$result = Get-NinjaOneTab -tabId 27

		$result.resource | Pester\Should -Be 'v2/tab/27'
	}

	It 'delegates missing tab results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTab -tabId 27 } | Pester\Should -Throw '*Tab 27 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneBackupJobs' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'COMPLETED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the backup jobs endpoint' {
		$null = Get-NinjaOneBackupJobs

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'preprocesses single status into a statusFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -status 'RUNNING'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}


	It 'preprocesses startTimeAfter into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -startTimeAfter (Get-Date '2024-01-01')

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'preprocesses startTimeBetween into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -startTimeBetween @((Get-Date '2024-01-01'), (Get-Date '2024-01-02'))

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'backup-jobs-failed' }

		{ Get-NinjaOneBackupJobs } | Pester\Should -Throw '*backup-jobs-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneIntegrityCheckJobs' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'COMPLETED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the integrity check jobs endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses single status into a statusFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -status 'RUNNING'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses startTimeAfter into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -startTimeAfter (Get-Date '2024-01-01')

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses startTimeBetween into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -startTimeBetween @((Get-Date '2024-01-01'), (Get-Date '2024-01-02'))

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'integrity-jobs-failed' }

		{ Get-NinjaOneIntegrityCheckJobs } | Pester\Should -Throw '*integrity-jobs-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTickets' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 1; subject = 'Test ticket' }
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ data = @([pscustomobject]@{ id = 1; subject = 'Test ticket' }); metadata = [pscustomobject]@{ total = 1 } }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses GET to the single ticket endpoint for the Single parameter set' {
		$null = Get-NinjaOneTickets -ticketId 7

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/7'
		}
	}

	It 'uses POST to the board run endpoint for the Board parameter set' {
		$null = Get-NinjaOneTickets -boardId 'board-1'

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/trigger/board/board-1/run'
		}
	}

	It 'builds board request body fields and parseDateTime when board options are supplied' {
		$null = Get-NinjaOneTickets -boardId 'board-1' -pageSize 25 -searchCriteria 'router' -includeColumns @('subject') -lastCursorId 'cursor-1' -parseDateTime

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/trigger/board/board-1/run' -and
			$Body.pageSize -eq 25 -and
			$Body.searchCriteria -eq 'router' -and
			$Body.includeColumns[0] -eq 'subject' -and
			$Body.lastCursorId -eq 'cursor-1' -and
			$ParseDateTime
		}
	}

	It 'returns only the data property from Board response when includeMetadata is not set' {
		$result = Get-NinjaOneTickets -boardId 'board-1'

		$result | Pester\Should -Not -BeNullOrEmpty
		# result should be the .data array, not the full response object
		$result[0].id | Pester\Should -Be 1
	}

	It 'caps board pageSize <Requested> at <Effective>' -ForEach @(
		@{ Requested = 25; Effective = 25 }
		@{ Requested = 1000; Effective = 1000 }
		@{ Requested = 1001; Effective = 1000 }
		@{ Requested = 2000; Effective = 1000 }
	) {
		$result = @(Get-NinjaOneTickets -boardId 'board-1' -pageSize $Requested -lastCursorId 'cursor-1' -WarningVariable warnings -WarningAction SilentlyContinue)

		$result.Count | Pester\Should -Be 1
		@($warnings).Count | Pester\Should -Be ([Int]($Requested -gt 1000))
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -Exactly -ParameterFilter {
			$Body.pageSize -eq $Effective -and $Body.lastCursorId -eq 'cursor-1'
		}
	}

	It 'returns the full response from Board when includeMetadata is set' {
		$result = Get-NinjaOneTickets -boardId 'board-1' -includeMetadata

		$result.data | Pester\Should -Not -BeNullOrEmpty
		$result.metadata | Pester\Should -Not -BeNullOrEmpty
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTickets -ticketId 7 } | Pester\Should -Throw '*No tickets found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneRelatedItems' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; type = 'DOCUMENT' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls v2/related-items for the all parameter set' {
		$null = Get-NinjaOneRelatedItems -all

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items'
		}
	}

	It 'calls the entity-type route when relatedTo is used with entityType only' {
		$null = Get-NinjaOneRelatedItems -relatedTo -entityType 'ORGANIZATION'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-entity-type/ORGANIZATION'
		}
	}

	It 'calls the entity route when relatedTo is used with entityType and entityId' {
		$null = Get-NinjaOneRelatedItems -relatedTo -entityType 'ORGANIZATION' -entityId 5

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-entity/ORGANIZATION/5'
		}
	}

	It 'calls the related-entity-type route when relatedFrom is used with entityType only' {
		$null = Get-NinjaOneRelatedItems -relatedFrom -entityType 'ORGANIZATION'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-related-entity-type/ORGANIZATION'
		}
	}

	It 'calls the related-entity route when relatedFrom is used with entityType and entityId' {
		$null = Get-NinjaOneRelatedItems -relatedFrom -entityType 'ORGANIZATION' -entityId 5

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-related-entity/ORGANIZATION/5'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneRelatedItems -all } | Pester\Should -Throw '*No related items found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOrganisationDocuments' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Doc 1' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the single-organisation documents endpoint when organisationId is supplied' {
		$null = Get-NinjaOneOrganisationDocuments -organisationId 12

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/12/documents'
		}
	}

	It 'calls the all-organisations documents endpoint when no organisationId is supplied' {
		$null = Get-NinjaOneOrganisationDocuments

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/documents'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOrganisationDocuments -organisationId 12 } | Pester\Should -Throw '*No documents found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketingUsers' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Alice Tech' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticketing users endpoint' {
		$null = Get-NinjaOneTicketingUsers

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/app-user-contact'
		}
	}

	It 'passes userType as a query parameter' {
		$null = Get-NinjaOneTicketingUsers -userType 'TECHNICIAN'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('userType')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketingUsers } | Pester\Should -Throw '*No ticketing users found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceOSPatchInstalls' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ patchId = 42; status = 'INSTALLED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device OS patch installs endpoint for the supplied device id' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'converts installedAfter DateTime to epoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 -installedAfter (Get-Date '2024-01-01')

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'accepts installedAfterUnixEpoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 -installedAfterUnixEpoch 1704067200

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'os-patch-installs-failed' }

		{ Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 } | Pester\Should -Throw '*os-patch-installs-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceSoftwarePatchInstalls' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ patchId = 99; status = 'INSTALLED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device software patch installs endpoint for the supplied device id' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'converts installedAfter DateTime to epoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 -installedAfter (Get-Date '2024-01-01')

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'accepts installedBeforeUnixEpoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 -installedBeforeUnixEpoch 1704153600

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'sw-patch-installs-failed' }

		{ Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 } | Pester\Should -Throw '*sw-patch-installs-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneDocumentTemplate' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 500; name = 'Template A' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/document-templates with the expected body' {
		$field = [pscustomobject]@{
			fieldName = 'Hostname'
			fieldType = 'TEXT'
		}
		$field.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		$fields = @($field)

		$null = New-NinjaOneDocumentTemplate -Name 'Template A' -fields $fields -description 'desc' -allowMultiple -mandatory -availableToAllTechnicians -allowedTechnicianRoles @(1, 2) -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/document-templates' -and
			$Body.name -eq 'Template A' -and
			$Body.description -eq 'desc' -and
			$Body.allowMultiple -eq $true -and
			$Body.mandatory -eq $true -and
			$Body.availableToAllTechnicians -eq $true -and
			$Body.allowedTechnicianRoles.Count -eq 2 -and
			$Body.fields.Count -eq 1
		}
	}

	It 'returns created template when -show is supplied' {
		$field = [pscustomobject]@{
			fieldName = 'Hostname'
			fieldType = 'TEXT'
		}
		$field.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		$fields = @($field)

		$result = New-NinjaOneDocumentTemplate -Name 'Template A' -fields $fields -show -Confirm:$false

		$result.id | Pester\Should -Be 500
		$result.name | Pester\Should -Be 'Template A'
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'doc-template-create-failed' }
		$field = [pscustomobject]@{
			fieldName = 'Hostname'
			fieldType = 'TEXT'
		}
		$field.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		$fields = @($field)

		{ New-NinjaOneDocumentTemplate -Name 'Template A' -fields $fields -Confirm:$false } | Pester\Should -Throw '*doc-template-create-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDocumentTemplate' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/document-templates/{id} with updated properties' {
		$fields = @(
			@{
				fieldName = 'Hostname'
				fieldType = 'TEXT'
			}
		)

		$null = Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -description 'updated' -allowMultiple -mandatory -fields $fields -availableToAllTechnicians -allowedTechnicianRoles @(1) -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/document-templates/5' -and
			$Body.name -eq 'Template B' -and
			$Body.description -eq 'updated' -and
			$Body.allowMultiple -eq $true -and
			$Body.mandatory -eq $true -and
			$Body.availableToAllTechnicians -eq $true -and
			$Body.allowedTechnicianRoles.Count -eq 1 -and
			$Body.fields.Count -eq 1
		}
	}

	It 'returns update response when -show is supplied' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 5; name = 'Template B' }
		}
		$fields = @(
			@{
				fieldName = 'Hostname'
				fieldType = 'TEXT'
			}
		)

		$result = Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -show -Confirm:$false

		$result.id | Pester\Should -Be 5
	}

	It 'throws validation error when DROPDOWN field has no fieldContent' {
		$fields = @(
			@{
				fieldName = 'Choice'
				fieldType = 'DROPDOWN'
			}
		)

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Pester\Should -Throw '*Field content must be specified*'
	}

	It 'throws validation error when DROPDOWN fieldContent has no values' {
		$fields = @(
			@{
				fieldName = 'Choice'
				fieldType = 'DROPDOWN'
				fieldContent = [pscustomobject]@{
					required = $true
				}
			}
		)

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Pester\Should -Throw '*Field content values must be specified*'
	}

	It 'delegates request failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'doc-template-update-failed' }
		$fields = @(
			@{
				fieldName = 'Hostname'
				fieldType = 'TEXT'
			}
		)

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Pester\Should -Throw '*doc-template-update-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwarePatchInstalls' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'INSTALLED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the software patch installs query endpoint' {
		$null = Get-NinjaOneSoftwarePatchInstalls

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software-patch-installs'
		}
	}

	It 'promotes installedBeforeUnixEpoch to installedBefore in query parameters' {
		$null = Get-NinjaOneSoftwarePatchInstalls -installedBeforeUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedBefore') -and -not $Parameters.ContainsKey('installedBeforeUnixEpoch')
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneSoftwarePatchInstalls -timeStampUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwarePatchInstalls } | Pester\Should -Throw '*No software patch installs found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOSPatchInstalls' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'INSTALLED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the OS patch installs query endpoint' {
		$null = Get-NinjaOneOSPatchInstalls

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/os-patch-installs'
		}
	}

	It 'promotes installedAfterUnixEpoch to installedAfter in query parameters' {
		$null = Get-NinjaOneOSPatchInstalls -installedAfterUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedAfter') -and -not $Parameters.ContainsKey('installedAfterUnixEpoch')
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneOSPatchInstalls -timeStampUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOSPatchInstalls } | Pester\Should -Throw '*No OS patch installs found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneCustomField' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ fieldName = 'department'; updated = $true }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT v2/custom-fields/field-name/{fieldName} with the supplied body' {
		$body = @{ description = 'Department of the user' }

		$null = Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/custom-fields/field-name/department' -and
			$Body.description -eq 'Department of the user'
		}
	}

	It 'returns the PUT response' {
		$body = @{ description = 'Department of the user' }

		$result = Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false

		$result.updated | Pester\Should -Be $true
	}

	It 'does not call PUT when -WhatIf is used' {
		$body = @{ description = 'Department of the user' }

		$null = Set-NinjaOneCustomField -fieldName 'department' -customField $body -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates request failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'custom-field-update-failed' }
		$body = @{ description = 'Department of the user' }

		{ Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false } | Pester\Should -Throw '*custom-field-update-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Invoke-NinjaOneDeviceScript' {
	BeforeEach {
		Pester\Mock -CommandName Get-NinjaOneDevice -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 44; SystemName = 'WS-44' }
		}
		Pester\Mock -CommandName Get-NinjaOneDeviceScriptingOptions -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 12; uid = [guid]'11111111-1111-1111-1111-111111111111'; type = 'SCRIPT'; Name = 'Collect Logs' },
				[pscustomobject]@{ id = 99; uid = [guid]'22222222-2222-2222-2222-222222222222'; type = 'ACTION'; Name = 'Restart Service' }
			)
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'posts script run requests to v2/device/{id}/script/run with script id' {
		$null = Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' -parameters 'mode=quick'

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/44/script/run' -and
			$Body.type -eq 'SCRIPT' -and
			$Body.id -eq 12 -and
			$Body.runAs -eq 'system' -and
			$Body.parameters -eq 'mode=quick'
		}
	}

	It 'posts action run requests with action uid' {
		$actionUId = [guid]'22222222-2222-2222-2222-222222222222'
		$null = Invoke-NinjaOneDeviceScript -deviceId 44 -type 'ACTION' -actionUId $actionUId -runAs 'loggedonuser'

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/44/script/run' -and
			$Body.type -eq 'ACTION' -and
			$Body.uid -eq $actionUId -and
			$Body.runAs -eq 'loggedonuser' -and
			-not $Body.ContainsKey('id')
		}
	}

	It 'returns 204 when -show is supplied' {
		$result = Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' -show

		$result | Pester\Should -Be 204
	}

	It 'delegates not-found script failures to New-NinjaOneError' {
		Pester\Mock -CommandName Get-NinjaOneDeviceScriptingOptions -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; type = 'SCRIPT'; Name = 'Different script' })
		}

		{ Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' } | Pester\Should -Throw '*Script with id 12 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneInstaller' {
	BeforeEach {
		Pester\Mock -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 7; name = 'Contoso' })
		}
		Pester\Mock -CommandName Get-NinjaOneLocations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 17; name = 'HQ' })
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ url = 'https://example.test/installer' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'creates an installer from individual parameters and returns the URL' {
		$result = New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false

		$result | Pester\Should -Be 'https://example.test/installer'
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/generate-installer' -and
			$Body.organization_id -eq 7 -and
			$Body.location_id -eq 17 -and
			$Body.installer_type -eq 'WINDOWS_MSI'
		}
	}

	It 'creates an installer from body parameter set and returns the URL' {
		$installer = @{
			organizationId = 7
			locationId = 17
			installer_type = 'WINDOWS_MSI'
			content = @{ nodeRoleId = 'auto' }
		}

		$result = New-NinjaOneInstaller -installer $installer -Confirm:$false

		$result | Pester\Should -Be 'https://example.test/installer'
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/generate-installer'
		}
	}

	It 'delegates validation failures to New-NinjaOneError when organisation/location do not exist' {
		Pester\Mock -CommandName Get-NinjaOneLocations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 99; name = 'Other' })
		}

		{ New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false } | Pester\Should -Throw '*does not exist*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'installer-create-failed' }

		{ New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false } | Pester\Should -Throw '*installer-create-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwarePatches' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'APPROVED' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the software patches query endpoint' {
		$null = Get-NinjaOneSoftwarePatches

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software-patches'
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneSoftwarePatches -timeStampUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwarePatches } | Pester\Should -Throw '*No software patches found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneCustomField' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ fieldName = 'department'; type = 'TEXT' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/custom-fields with the supplied body' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$null = New-NinjaOneCustomField -customField $body -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/custom-fields' -and
			$Body.fieldName -eq 'department' -and
			$Body.type -eq 'TEXT'
		}
	}

	It 'returns the created custom field' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$result = New-NinjaOneCustomField -customField $body -Confirm:$false

		$result.fieldName | Pester\Should -Be 'department'
	}

	It 'does not call POST when -WhatIf is supplied' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$null = New-NinjaOneCustomField -customField $body -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates request failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'custom-field-create-failed' }
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		{ New-NinjaOneCustomField -customField $body -Confirm:$false } | Pester\Should -Throw '*custom-field-create-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceMaintenance' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT v2/device/{id}/maintenance with DateTime values converted to Unix epoch' {
		$start = [datetime]'2024-01-01T00:00:00Z'
		$end = [datetime]'2024-01-01T01:00:00Z'

		$null = Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -start $start -end $end -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/maintenance' -and
			$Body.disabledFeatures[0] -eq 'ALERTS' -and
			$Body.start -is [int] -and
			$Body.end -is [int]
		}
	}

	It 'calls PUT with unixStart and unixEnd values' {
		$null = Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('PATCHING') -unixStart 1704067200 -unixEnd 1704070800 -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/maintenance' -and
			$Body.start -eq 1704067200 -and
			$Body.end -eq 1704070800
		}
	}

	It 'throws when no end or unixEnd is specified' {
		{ Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -start ([datetime]'2024-01-01T00:00:00Z') -Confirm:$false } | Pester\Should -Throw '*An end date/time must be specified*'
	}

	It 'delegates PUT failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'maintenance-update-failed' }

		{ Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -unixStart 1704067200 -unixEnd 1704070800 -Confirm:$false } | Pester\Should -Throw '*maintenance-update-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneOrganisation' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 501; name = 'Contoso Ltd' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/organizations with organisation body and optional template query' {
		$body = @{ name = 'Contoso Ltd'; description = 'Test org' }

		$null = New-NinjaOneOrganisation -templateOrganisationId '12' -organisation $body -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations' -and
			$Body.name -eq 'Contoso Ltd'
		}
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('templateOrganisationId') -and -not $Parameters.ContainsKey('organisation')
		}
	}

	It 'returns created organisation when -show is supplied' {
		$body = @{ name = 'Contoso Ltd' }

		$result = New-NinjaOneOrganisation -organisation $body -show -Confirm:$false

		$result.id | Pester\Should -Be 501
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'organisation-create-failed' }
		$body = @{ name = 'Contoso Ltd' }

		{ New-NinjaOneOrganisation -organisation $body -Confirm:$false } | Pester\Should -Throw '*organisation-create-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneCustomFields' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; field = 'department' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses v2/queries/custom-fields for default parameter set' {
		$null = Get-NinjaOneCustomFields

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/custom-fields'
		}
	}

	It 'uses v2/queries/custom-fields-detailed when -detailed is supplied in default set' {
		$null = Get-NinjaOneCustomFields -detailed

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/custom-fields-detailed'
		}
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('detailed')
		}
	}

	It 'uses v2/queries/scoped-custom-fields for scoped parameter set' {
		$null = Get-NinjaOneCustomFields -scopes @('NODE')

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/scoped-custom-fields'
		}
	}

	It 'uses v2/queries/scoped-custom-fields-detailed when scoped and detailed are supplied' {
		$null = Get-NinjaOneCustomFields -scopes @('NODE') -detailed

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/scoped-custom-fields-detailed'
		}
	}

	It 'promotes updatedAfterUnixEpoch to updatedAfter in query parameters' {
		$null = Get-NinjaOneCustomFields -updatedAfterUnixEpoch 1619712000000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('updatedAfter') -and -not $Parameters.ContainsKey('updatedAfterUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneCustomFields } | Pester\Should -Throw '*No custom fields found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneInstanceCapabilities' {
	BeforeEach {
		Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
			param($baseUrl, $Force)
			[pscustomobject]@{
				BaseUrl = $baseUrl
				Version = '1.2.3'
				SpecUrl = ($baseUrl.TrimEnd('/') + '/api/docs-2.0/openapi.json')
				RetrievedAt = [datetime]'2024-01-01T00:00:00Z'
				Paths = @{
					'/v2/devices' = @('GET')
					'/v2/organizations' = @('GET', 'POST')
				}
			}
		}
	}

	It 'returns summary fields when baseUrl is provided' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com'

		$result.BaseUrl | Pester\Should -Be 'https://fed.ninjarmm.com'
		$result.AppVersion | Pester\Should -Be '1.2.3'
		$result.PathCount | Pester\Should -Be 2
		Pester\Should-Invoke -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$baseUrl -eq 'https://fed.ninjarmm.com' -and -not $Force
		}
	}

	It 'resolves a named instance to its configured base URL' {
		$result = Get-NinjaOneInstanceCapabilities -instance 'fed'

		$result.BaseUrl | Pester\Should -Be 'https://fed.ninjarmm.com'
		Pester\Should-Invoke -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$baseUrl -eq 'https://fed.ninjarmm.com'
		}
	}

	It 'passes refresh switch through as Force to internal loader' {
		$null = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -refresh

		Pester\Should-Invoke -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$baseUrl -eq 'https://fed.ninjarmm.com' -and $Force
		}
	}

	It 'includes paths when includePaths is supplied' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includePaths

		$result.Paths.Keys.Count | Pester\Should -Be 2
	}

	It 'classifies cmdlets as unknown when metadata is absent with includeCmdlets' {
		Pester\Mock -CommandName Get-Module -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				ExportedFunctions = @{
					'Get-FakeOne' = $null
					'Set-FakeTwo' = $null
				}
			}
		}
		Pester\Mock -CommandName Get-Command -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ Name = 'Get-FakeOne'; ScriptBlock = [scriptblock]::Create('param()') },
				[pscustomobject]@{ Name = 'Set-FakeTwo'; ScriptBlock = [scriptblock]::Create('param()') }
			)
		}

		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includeCmdlets

		$result.UnknownCmdletCount | Pester\Should -Be 2
		$result.SupportedCmdletCount | Pester\Should -Be 0
		$result.UnsupportedCmdletCount | Pester\Should -Be 0
	}

	It 'throws when internal loader returns null capabilities' {
		Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' } | Pester\Should -Throw '*Unable to retrieve OpenAPI spec*'
	}
}

Describe 'New-NinjaOneSecureRelation' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[PSCustomObject]@{ id = 42; name = 'TestSecret'; entityType = 'ORGANIZATION'; entityId = 1 }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the correct resource endpoint' {
		New-NinjaOneSecureRelation -entityType 'ORGANIZATION' -entityId 1 -secureValueName 'TestSecret'

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/related-items/entity/ORGANIZATION/1/secure'
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$result = New-NinjaOneSecureRelation -entityType 'ORGANIZATION' -entityId 1 -secureValueName 'TestSecret' -show

		$result.name | Pester\Should -Be 'TestSecret'
	}

	It 'includes optional body fields when provided' {
		New-NinjaOneSecureRelation -entityType 'NODE' -entityId 5 -secureValueName 'S' -secureValueURL 'https://example.com' -secureValueUsername 'admin' -secureValuePassword 'pass' -secureValueNotes 'notes'

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/related-items/entity/NODE/5/secure' -and
			$Body.url -eq 'https://example.com' -and
			$Body.username -eq 'admin' -and
			$Body.notes -eq 'notes'
		} -Times 1 -Exactly
	}

	It 'skips POST when WhatIf is used' {
		New-NinjaOneSecureRelation -entityType 'ORGANIZATION' -entityId 1 -secureValueName 'S' -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces errors via New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API error' }

		{ New-NinjaOneSecureRelation -entityType 'ORGANIZATION' -entityId 1 -secureValueName 'S' } | Pester\Should -Throw
	}
}

Describe 'New-NinjaOneOrganisationDocument' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[PSCustomObject]@{ id = 10; documentName = 'Doc1'; organizationId = 3 }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the correct resource endpoint' {
		$doc = [PSCustomObject]@{ documentName = 'Doc1'; fields = @{} }
		New-NinjaOneOrganisationDocument -organisationId '3' -documentTemplateId '7' -organisationDocument $doc

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/organization/3/template/7/document'
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$doc = [PSCustomObject]@{ documentName = 'Doc1'; fields = @{} }
		$result = New-NinjaOneOrganisationDocument -organisationId '3' -documentTemplateId '7' -organisationDocument $doc -show

		$result.documentName | Pester\Should -Be 'Doc1'
	}

	It 'skips POST when WhatIf is used' {
		$doc = [PSCustomObject]@{ documentName = 'Doc1'; fields = @{} }
		New-NinjaOneOrganisationDocument -organisationId '3' -documentTemplateId '7' -organisationDocument $doc -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces errors via New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API error' }
		$doc = [PSCustomObject]@{ documentName = 'Doc1'; fields = @{} }

		{ New-NinjaOneOrganisationDocument -organisationId '3' -documentTemplateId '7' -organisationDocument $doc } | Pester\Should -Throw
	}
}

Describe 'New-NinjaOneOrganisationDocuments' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ id = 11; organizationId = 4 }, [PSCustomObject]@{ id = 12; organizationId = 5 })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the correct resource endpoint' {
		$docs = @([PSCustomObject]@{ documentName = 'D1'; organizationId = 4 })
		New-NinjaOneOrganisationDocuments -organisationDocuments $docs

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/organization/documents'
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$docs = @([PSCustomObject]@{ documentName = 'D1'; organizationId = 4 })
		$result = New-NinjaOneOrganisationDocuments -organisationDocuments $docs -show

		$result | Pester\Should -Not -BeNullOrEmpty
	}

	It 'skips POST when WhatIf is used' {
		$docs = @([PSCustomObject]@{ documentName = 'D1'; organizationId = 4 })
		New-NinjaOneOrganisationDocuments -organisationDocuments $docs -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces errors via New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API error' }
		$docs = @([PSCustomObject]@{ documentName = 'D1'; organizationId = 4 })

		{ New-NinjaOneOrganisationDocuments -organisationDocuments $docs } | Pester\Should -Throw
	}
}

Describe 'New-NinjaOnePolicy' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[PSCustomObject]@{ id = 20; name = 'TestPolicy'; nodeClass = 'WINDOWS_SERVER' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the correct resource endpoint' {
		$policy = [PSCustomObject]@{ name = 'TestPolicy'; nodeClass = 'WINDOWS_SERVER'; enabled = $true }
		New-NinjaOnePolicy -mode 'NEW' -policy $policy

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/policies'
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$policy = [PSCustomObject]@{ name = 'TestPolicy'; nodeClass = 'WINDOWS_SERVER'; enabled = $true }
		$result = New-NinjaOnePolicy -mode 'NEW' -policy $policy -show

		$result.name | Pester\Should -Be 'TestPolicy'
	}

	It 'throws in begin block when CHILD mode has no parentPolicyId' {
		$policy = [PSCustomObject]@{ name = 'ChildPolicy'; nodeClass = 'WINDOWS_SERVER' }

		{ New-NinjaOnePolicy -mode 'CHILD' -policy $policy } | Pester\Should -Throw '*parent policy id*'
	}

	It 'throws in begin block when COPY mode has no templatePolicyId' {
		$policy = [PSCustomObject]@{ name = 'CopyPolicy'; nodeClass = 'WINDOWS_SERVER' }

		{ New-NinjaOnePolicy -mode 'COPY' -policy $policy } | Pester\Should -Throw '*template policy id*'
	}

	It 'allows COPY mode when templatePolicyId is provided' {
		$policy = [PSCustomObject]@{ name = 'CopyPolicy'; nodeClass = 'WINDOWS_SERVER' }

		New-NinjaOnePolicy -mode 'COPY' -policy $policy -templatePolicyId 10

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -Exactly
	}

	It 'skips POST when WhatIf is used' {
		$policy = [PSCustomObject]@{ name = 'TestPolicy'; nodeClass = 'WINDOWS_SERVER'; enabled = $true }
		New-NinjaOnePolicy -mode 'NEW' -policy $policy -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces errors via New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API error' }
		$policy = [PSCustomObject]@{ name = 'TestPolicy'; nodeClass = 'WINDOWS_SERVER'; enabled = $true }

		{ New-NinjaOnePolicy -mode 'NEW' -policy $policy } | Pester\Should -Throw
	}
}

Describe 'Get-NinjaOneAntiVirusStatus' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ deviceId = 1; productName = 'Defender'; productState = 'ON' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'calls the correct endpoint' {
		Get-NinjaOneAntiVirusStatus

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/queries/antivirus-status'
		} -Times 1 -Exactly
	}

	It 'returns results' {
		$result = Get-NinjaOneAntiVirusStatus

		$result | Pester\Should -Not -BeNullOrEmpty
		$result[0].productName | Pester\Should -Be 'Defender'
	}

	It 'applies deviceFilter parameter' {
		Get-NinjaOneAntiVirusStatus -deviceFilter 'org = 1'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -Exactly
	}

	It 'converts timeStampUnixEpoch to timeStamp' {
		Get-NinjaOneAntiVirusStatus -timeStampUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -Exactly
	}

	It 'throws when no results returned' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneAntiVirusStatus } | Pester\Should -Throw
	}
}

Describe 'New-NinjaOneWindowsEventPolicyCondition' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[PSCustomObject]@{ id = 99; displayName = 'TestCondition'; policyId = 15 }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the correct resource endpoint' {
		$condition = [PSCustomObject]@{ displayName = 'TestCondition'; enabled = $true }
		New-NinjaOneWindowsEventPolicyCondition -policyId 15 -windowsEventPolicyCondition $condition

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/policies/15/condition/windows-event'
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$condition = [PSCustomObject]@{ displayName = 'TestCondition'; enabled = $true }
		$result = New-NinjaOneWindowsEventPolicyCondition -policyId 15 -windowsEventPolicyCondition $condition -show

		$result.displayName | Pester\Should -Be 'TestCondition'
	}

	It 'skips POST when WhatIf is used' {
		$condition = [PSCustomObject]@{ displayName = 'TestCondition'; enabled = $true }
		New-NinjaOneWindowsEventPolicyCondition -policyId 15 -windowsEventPolicyCondition $condition -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces errors via New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API error' }
		$condition = [PSCustomObject]@{ displayName = 'TestCondition'; enabled = $true }

		{ New-NinjaOneWindowsEventPolicyCondition -policyId 15 -windowsEventPolicyCondition $condition } | Pester\Should -Throw
	}
}

Describe 'Reset-NinjaOneAlert' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'uses POST reset endpoint when activityData is provided' {
		$activityData = [PSCustomObject]@{ reason = 'manual reset' }

		Reset-NinjaOneAlert -uid '15' -activityData $activityData

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/alert/15/reset' -and
			$Body.reason -eq 'manual reset'
		} -Times 1 -Exactly
	}

	It 'uses DELETE endpoint when activityData is not provided' {
		Reset-NinjaOneAlert -uid '20'

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/alert/20'
		} -Times 1 -Exactly
	}

	It 'skips POST when WhatIf is used' {
		$activityData = [PSCustomObject]@{ reason = 'manual reset' }

		Reset-NinjaOneAlert -uid '30' -activityData $activityData -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'skips DELETE when WhatIf is used' {
		Reset-NinjaOneAlert -uid '31' -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces API errors through New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { throw 'API failure' }

		{ Reset-NinjaOneAlert -uid '99' } | Pester\Should -Throw
	}
}

Describe 'Get-NinjaOneTicketLogEntries' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ id = 1; type = 'DESCRIPTION'; message = 'entry' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'calls the expected ticket log endpoint' {
		Get-NinjaOneTicketLogEntries -ticketId '7'

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/7/log-entry'
		} -Times 1 -Exactly
	}

	It 'passes ParseDateTime when switch is set' {
		Get-NinjaOneTicketLogEntries -ticketId '8' -parseDateTime

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/8/log-entry' -and
			$ParseDateTime
		} -Times 1 -Exactly
	}

	It 'returns ticket log results' {
		$result = Get-NinjaOneTicketLogEntries -ticketId '9'

		$result | Pester\Should -Not -BeNullOrEmpty
		$result[0].type | Pester\Should -Be 'DESCRIPTION'
	}

	It 'throws specific message when no results and type is provided' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketLogEntries -ticketId '10' -type 'DESCRIPTION' } | Pester\Should -Throw '*with type DESCRIPTION*'
	}

	It 'throws specific message when no results and type is not provided' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketLogEntries -ticketId '11' } | Pester\Should -Throw '*No ticket log entries found for ticket 11*'
	}
}

Describe 'New-NinjaOneDocumentTemplateFieldObject' {
	It 'creates a Field object with required properties and type name' {
		$result = New-NinjaOneDocumentTemplateFieldObject -label 'Field A' -name 'fieldA' -type 'TEXT'

		$result.fieldLabel | Pester\Should -Be 'Field A'
		$result.fieldName | Pester\Should -Be 'fieldA'
		$result.fieldType | Pester\Should -Be 'TEXT'
		$result.PSObject.TypeNames[0] | Pester\Should -Be 'DocumentTemplateField'
	}

	It 'adds optional Field properties when specified' {
		$options = @('Option1', 'Option2')
		$result = New-NinjaOneDocumentTemplateFieldObject -label 'Field B' -name 'fieldB' -description 'desc' -type 'DROPDOWN' -defaultValue 'Option1' -options $options

		$result.fieldDescription | Pester\Should -Be 'desc'
		$result.fieldDefaultValue | Pester\Should -Be 'Option1'
		$result.fieldContent.Count | Pester\Should -Be 2
	}

	It 'creates a UI element object with required properties and type name' {
		$result = New-NinjaOneDocumentTemplateFieldObject -elementName 'Heading' -elementType 'TITLE' -elementValue 'Welcome'

		$result.uiElementName | Pester\Should -Be 'Heading'
		$result.uiElementType | Pester\Should -Be 'TITLE'
		$result.uiElementValue | Pester\Should -Be 'Welcome'
		$result.PSObject.TypeNames[0] | Pester\Should -Be 'DocumentTemplateField'
	}

	It 'omits UI element value when not provided' {
		$result = New-NinjaOneDocumentTemplateFieldObject -elementName 'Rule' -elementType 'SEPARATOR'

		$result.PSObject.Properties.Name -contains 'uiElementValue' | Pester\Should -BeFalse
	}
}

Describe 'Get-NinjaOneTicketForms' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ id = 1; name = 'Default Form' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'calls list endpoint when ticketFormId is not provided' {
		Get-NinjaOneTicketForms

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq '/v2/ticketing/ticket-form'
		} -Times 1 -Exactly
	}

	It 'calls single-item endpoint when ticketFormId is provided' {
		Get-NinjaOneTicketForms -ticketFormId 8

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq '/v2/ticketing/ticket-form/8'
		} -Times 1 -Exactly
	}

	It 'returns ticket forms' {
		$result = Get-NinjaOneTicketForms

		$result[0].name | Pester\Should -Be 'Default Form'
	}

	It 'throws when no ticket forms are found' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketForms } | Pester\Should -Throw '*No ticket forms found*'
	}
}

Describe 'Get-NinjaOneTicketingContacts' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith { [System.Web.HttpUtility]::ParseQueryString([String]::Empty) }
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ id = 1; name = 'Contact 1' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'calls the expected ticketing contacts endpoint' {
		Get-NinjaOneTicketingContacts

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/ticketing/contact/contacts'
		} -Times 1 -Exactly
	}

	It 'returns contacts when present' {
		$result = Get-NinjaOneTicketingContacts

		$result | Pester\Should -Not -BeNullOrEmpty
		$result[0].name | Pester\Should -Be 'Contact 1'
	}

	It 'throws when no contacts are found' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketingContacts } | Pester\Should -Throw '*No ticketing contacts found*'
	}
}

Describe 'New-NinjaOneEntityRelation' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[PSCustomObject]@{ id = 100; relEntityType = 'NODE'; relEntityId = 50 }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts to the expected relation endpoint' {
		New-NinjaOneEntityRelation -entityType 'ORGANIZATION' -entityId 1 -relatedEntityType 'NODE' -relatedEntityId 50

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/related-items/entity/ORGANIZATION/1/relation' -and
			$Body.relEntityType -eq 'NODE' -and
			$Body.relEntityId -eq 50
		} -Times 1 -Exactly
	}

	It 'returns result when -show is used' {
		$result = New-NinjaOneEntityRelation -entityType 'ORGANIZATION' -entityId 1 -relatedEntityType 'NODE' -relatedEntityId 50 -show

		$result.relEntityId | Pester\Should -Be 50
	}

	It 'skips POST when WhatIf is used' {
		New-NinjaOneEntityRelation -entityType 'ORGANIZATION' -entityId 1 -relatedEntityType 'NODE' -relatedEntityId 50 -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces API errors through New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API failure' }

		{ New-NinjaOneEntityRelation -entityType 'ORGANIZATION' -entityId 1 -relatedEntityType 'NODE' -relatedEntityId 50 } | Pester\Should -Throw
	}
}

Describe 'New-NinjaOneEntityRelations' {
	BeforeAll {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			@([PSCustomObject]@{ relEntityType = 'NODE'; relEntityId = 51 })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith { param($ErrorRecord); throw $ErrorRecord.Exception }
	}

	It 'posts relation array to the expected endpoint' {
		$relations = @([PSCustomObject]@{ relEntityType = 'NODE'; relEntityId = 51 })
		New-NinjaOneEntityRelations -entityType 'ORGANIZATION' -entityId 1 -entityRelations $relations

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -ParameterFilter {
			$Resource -eq 'v2/related-items/entity/ORGANIZATION/1/relations' -and
			$Body[0].relEntityId -eq 51
		} -Times 1 -Exactly
	}

	It 'returns created relations when -show is used' {
		$relations = @([PSCustomObject]@{ relEntityType = 'NODE'; relEntityId = 51 })
		$result = New-NinjaOneEntityRelations -entityType 'ORGANIZATION' -entityId 1 -entityRelations $relations -show

		$result[0].relEntityId | Pester\Should -Be 51
	}

	It 'skips POST when WhatIf is used' {
		$relations = @([PSCustomObject]@{ relEntityType = 'NODE'; relEntityId = 51 })
		New-NinjaOneEntityRelations -entityType 'ORGANIZATION' -entityId 1 -entityRelations $relations -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0 -Exactly
	}

	It 'surfaces API errors through New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'API failure' }
		$relations = @([PSCustomObject]@{ relEntityType = 'NODE'; relEntityId = 51 })

		{ New-NinjaOneEntityRelations -entityType 'ORGANIZATION' -entityId 1 -entityRelations $relations } | Pester\Should -Throw
	}
}

Get-Module -Name $ModuleName | Remove-Module -Force -ErrorAction SilentlyContinue
Import-Module $ModulePath -Force

Describe 'Public function definitions' {
	It 'does not define the same public function in more than one source file' {
		$PublicRoot = Resolve-Path -Path (Join-Path -Path $RepoRoot -ChildPath 'Source\Public')
		$Definitions = foreach ($file in Get-ChildItem -Path $PublicRoot -Recurse -Filter '*.ps1') {
			$tokens = $null
			$parseErrors = $null
			$ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
			if ($parseErrors) {
				$ParseErrorSummary = $parseErrors | ForEach-Object {
					'{0}:{1}:{2}: {3}' -f $_.Extent.File, $_.Extent.StartLineNumber, $_.Extent.StartColumnNumber, $_.Message
				}
				throw ("Failed to parse public source file(s):`n{0}" -f ($ParseErrorSummary -join "`n"))
			}
			foreach ($function in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) {
				[pscustomobject]@{
					Name = $function.Name
					File = $file.FullName.Substring($RepoRoot.Length).TrimStart('\', '/')
				}
			}
		}

		$Duplicates = $Definitions | Group-Object Name | Where-Object Count -GT 1
		if ($Duplicates) {
			$Summary = $Duplicates | ForEach-Object {
				'{0}: {1}' -f $_.Name, (($_.Group.File | Sort-Object) -join ', ')
			}
			throw ("Duplicate public function definitions detected:`n{0}" -f ($Summary -join "`n"))
		}
	}
}

Describe 'Public Query Functions - Existence Tests' {
	It 'Get-NinjaOneCustomFields should exist' {
		Get-Command -Name Get-NinjaOneCustomFields -ErrorAction SilentlyContinue | Pester\Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusStatus should exist' {
		Get-Command -Name Get-NinjaOneAntivirusStatus -ErrorAction SilentlyContinue | Pester\Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusThreats should exist' {
		Get-Command -Name Get-NinjaOneAntivirusThreats -ErrorAction SilentlyContinue | Pester\Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneDeviceBackupUsage should exist' {
		Get-Command -Name Get-NinjaOneDeviceBackupUsage -ErrorAction SilentlyContinue | Pester\Should -Not -BeNullOrEmpty
	}
}

Describe 'Public Query Functions - Contract Matrix' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{
					id = 1
				}
			)
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$ContractCases = @(
		[pscustomobject]@{
			Name = 'Get-NinjaOneCustomFields default endpoint and fields query'
			InvokeSuccess = { Get-NinjaOneCustomFields }
			InvokeQuery = { Get-NinjaOneCustomFields -fields @('hasBatteries', 'autopilotHwid') }
			ExpectedResource = 'v2/queries/custom-fields'
			ExpectedQueryKey = 'fields'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No custom fields found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneCustomFields scoped detailed endpoint and scopes query'
			InvokeSuccess = { Get-NinjaOneCustomFields -scopes 'NODE' -detailed }
			InvokeQuery = { Get-NinjaOneCustomFields -scopes 'NODE' -detailed }
			ExpectedResource = 'v2/queries/scoped-custom-fields-detailed'
			ExpectedQueryKey = 'scopes'
			ExpectedRemovedQueryKey = 'detailed'
			ExpectedError = 'No custom fields found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneAntivirusStatus endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneAntivirusStatus }
			InvokeQuery = { Get-NinjaOneAntivirusStatus -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/antivirus-status'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No antivirus status found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneAntivirusThreats endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneAntivirusThreats }
			InvokeQuery = { Get-NinjaOneAntivirusThreats -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/antivirus-threats'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No antivirus threats found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneDeviceBackupUsage endpoint and includeDeleted query'
			InvokeSuccess = { Get-NinjaOneDeviceBackupUsage }
			InvokeQuery = { Get-NinjaOneDeviceBackupUsage -includeDeleted }
			ExpectedResource = 'v2/queries/backup/usage'
			ExpectedQueryKey = 'includeDeleted'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No backup usage found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneComputerSystems endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneComputerSystems }
			InvokeQuery = { Get-NinjaOneComputerSystems -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/computer-systems'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No computer systems found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneDeviceHealth endpoint and health query'
			InvokeSuccess = { Get-NinjaOneDeviceHealth }
			InvokeQuery = { Get-NinjaOneDeviceHealth -health 'UNHEALTHY' }
			ExpectedResource = 'v2/queries/device-health'
			ExpectedQueryKey = 'health'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No device health found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneDisks endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneDisks }
			InvokeQuery = { Get-NinjaOneDisks -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/disks'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No disks found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneLoggedOnUsers endpoint and deviceFilter query'
			InvokeSuccess = { Get-NinjaOneLoggedOnUsers }
			InvokeQuery = { Get-NinjaOneLoggedOnUsers -deviceFilter 'org = 1' }
			ExpectedResource = 'v2/queries/logged-on-users'
			ExpectedQueryKey = 'deviceFilter'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No logged on users found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneNetworkInterfaces endpoint and deviceFilter query'
			InvokeSuccess = { Get-NinjaOneNetworkInterfaces }
			InvokeQuery = { Get-NinjaOneNetworkInterfaces -deviceFilter 'org = 1' }
			ExpectedResource = 'v2/queries/network-interfaces'
			ExpectedQueryKey = 'deviceFilter'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No network interfaces found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneOperatingSystems endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneOperatingSystems }
			InvokeQuery = { Get-NinjaOneOperatingSystems -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/operating-systems'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No operating systems found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneProcessors endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneProcessors }
			InvokeQuery = { Get-NinjaOneProcessors -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/processors'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No processors found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneVolumes endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneVolumes }
			InvokeQuery = { Get-NinjaOneVolumes -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/volumes'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No volumes found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneRAIDControllers endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneRAIDControllers }
			InvokeQuery = { Get-NinjaOneRAIDControllers -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/raid-controllers'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No RAID controllers found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneRAIDDrives endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneRAIDDrives }
			InvokeQuery = { Get-NinjaOneRAIDDrives -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/raid-drives'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No RAID drives found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneOSPatches endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneOSPatches }
			InvokeQuery = { Get-NinjaOneOSPatches -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/os-patches'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No OS patches found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneOSPatchInstalls endpoint and installedBefore unix promotion'
			InvokeSuccess = { Get-NinjaOneOSPatchInstalls }
			InvokeQuery = { Get-NinjaOneOSPatchInstalls -installedBeforeUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/os-patch-installs'
			ExpectedQueryKey = 'installedBefore'
			ExpectedRemovedQueryKey = 'installedBeforeUnixEpoch'
			ExpectedError = 'No OS patch installs found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOnePolicyOverrides endpoint and deviceFilter query'
			InvokeSuccess = { Get-NinjaOnePolicyOverrides }
			InvokeQuery = { Get-NinjaOnePolicyOverrides -deviceFilter 'org = 1' }
			ExpectedResource = 'v2/queries/policy-overrides'
			ExpectedQueryKey = 'deviceFilter'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No policy overrides found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneSoftwarePatches endpoint and timestamp unix promotion'
			InvokeSuccess = { Get-NinjaOneSoftwarePatches }
			InvokeQuery = { Get-NinjaOneSoftwarePatches -timeStampUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/software-patches'
			ExpectedQueryKey = 'timeStamp'
			ExpectedRemovedQueryKey = 'timeStampUnixEpoch'
			ExpectedError = 'No software patches found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneSoftwarePatchInstalls endpoint and installedAfter unix promotion'
			InvokeSuccess = { Get-NinjaOneSoftwarePatchInstalls }
			InvokeQuery = { Get-NinjaOneSoftwarePatchInstalls -installedAfterUnixEpoch 1619712000 }
			ExpectedResource = 'v2/queries/software-patch-installs'
			ExpectedQueryKey = 'installedAfter'
			ExpectedRemovedQueryKey = 'installedAfterUnixEpoch'
			ExpectedError = 'No software patch installs found.'
		}
		[pscustomobject]@{
			Name = 'Get-NinjaOneWindowsServices endpoint and state query'
			InvokeSuccess = { Get-NinjaOneWindowsServices }
			InvokeQuery = { Get-NinjaOneWindowsServices -state 'RUNNING' }
			ExpectedResource = 'v2/queries/windows-services'
			ExpectedQueryKey = 'state'
			ExpectedRemovedQueryKey = $null
			ExpectedError = 'No windows services found.'
		}
	)

	It 'returns data and calls expected resource for <Name>' -ForEach $ContractCases {
		$result = & $PSItem.InvokeSuccess

		@($result).Count | Pester\Should -Be 1
		$result[0].id | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.ExpectedResource
		}
	}

	It 'builds expected query keys for <Name>' -ForEach $ContractCases {
		$null = & $PSItem.InvokeQuery

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$HasExpected = $Parameters.ContainsKey($PSItem.ExpectedQueryKey)
			if ([string]::IsNullOrWhiteSpace($PSItem.ExpectedRemovedQueryKey)) {
				return $HasExpected
			}

			return $HasExpected -and (-not $Parameters.ContainsKey($PSItem.ExpectedRemovedQueryKey))
		}
	}

	It 'delegates no-result errors for <Name>' -ForEach $ContractCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		{ & $PSItem.InvokeSuccess } | Pester\Should -Throw ('*{0}*' -f $PSItem.ExpectedError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream API exceptions for <Name>' -ForEach $ContractCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw [System.InvalidOperationException]::new('upstream-api-failure')
		}

		{ & $PSItem.InvokeSuccess } | Pester\Should -Throw '*upstream-api-failure*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneTicketComment' {
	It 'wraps a simple comment object in a multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		Pester\InModuleScope $ModuleName {
			$script:CapturedTicketCommentRequest = $null
			function New-NinjaOnePOSTRequest {
				<#
					.SYNOPSIS
						Mock replacement for New-NinjaOnePOSTRequest used to capture call parameters in tests.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$Body,
					$UseMultipart
				)
				$script:CapturedTicketCommentRequest = [pscustomobject]@{
					Resource     = $Resource
					Body         = $Body
					UseMultipart = $UseMultipart
				}
				return $script:CapturedTicketCommentRequest
			}

			$result = New-NinjaOneTicketComment -ticketId 1003 -comment @{ public = $true; body = 'Test Comment via API' } -Confirm:$false -show

			$script:CapturedTicketCommentRequest | Pester\Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Pester\Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Pester\Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.public | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.body | Pester\Should -Be 'Test Comment via API'
			$result.Body.comment.body | Pester\Should -Be 'Test Comment via API'
		}
	}

	It 'preserves an explicit multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		Pester\InModuleScope $ModuleName {
			$script:CapturedTicketCommentRequest = $null
			$body = @{
				comment = @{
					public = $true
					body   = 'Test Comment via API'
				}
				files = @('C:\Temp\example.txt')
			}
			function New-NinjaOnePOSTRequest {
				<#
					.SYNOPSIS
						Mock replacement for New-NinjaOnePOSTRequest used to capture call parameters in tests.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$Body,
					$UseMultipart
				)
				$script:CapturedTicketCommentRequest = [pscustomobject]@{
					Resource     = $Resource
					Body         = $Body
					UseMultipart = $UseMultipart
				}
				return $script:CapturedTicketCommentRequest
			}

			$result = New-NinjaOneTicketComment -ticketId 1003 -comment $body -Confirm:$false -show

			$script:CapturedTicketCommentRequest | Pester\Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Pester\Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Pester\Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body.Contains('files') | Pester\Should -Be $true
			$script:CapturedTicketCommentRequest.Body.files[0] | Pester\Should -Be 'C:\Temp\example.txt'
			$result.Body.files[0] | Pester\Should -Be 'C:\Temp\example.txt'
		}
	}
}

Describe 'Get-NinjaOneActivities' {
	It 'does not emit boolean output when using -deviceId with -type' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		Pester\InModuleScope $ModuleName {
			function New-NinjaOneGETRequest {
				<#
				.SYNOPSIS
					Returns mock activity data for the `-deviceId` and `-type` test case.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$QSCollection,
					$Raw,
					$ParseDateTime
				)

				return [pscustomobject]@{
					lastActivityId = 42
					activities = @(
						[pscustomobject]@{
							id = 42
							type = 'Action'
						}
					)
				}
			}

			$result = @(Get-NinjaOneActivities -deviceId 123 -type 'Action')

			$result.Count | Pester\Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Pester\Should -Be 0
			$result[0].lastActivityId | Pester\Should -Be 42
			$result[0].activities[0].type | Pester\Should -Be 'Action'
		}
	}

	It 'does not emit boolean output when using -activityType' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		Pester\InModuleScope $ModuleName {
			function New-NinjaOneGETRequest {
				<#
				.SYNOPSIS
					Returns mock activity data for the `-activityType` test case.
				#>
				[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Test fixture mock - parameters mirror the real function signature.')]
				param(
					$Resource,
					$QSCollection,
					$Raw,
					$ParseDateTime
				)

				return [pscustomobject]@{
					lastActivityId = 7
					activities     = @(
						[pscustomobject]@{
							id   = 7
							type = 'Action'
						}
					)
				}
			}

			$result = @(Get-NinjaOneActivities -activityType 'Action')

			$result.Count | Pester\Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Pester\Should -Be 0
			$result[0].lastActivityId | Pester\Should -Be 7
			$result[0].activities[0].id | Pester\Should -Be 7
		}
	}
}

Describe 'Get-NinjaOneUsers' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			@{}
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{
					id = 1
					name = 'Test User'
				}
			)
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the default users endpoint when organisationId is not supplied' {
		$module = Get-Module -Name $ModuleName
		$result = Pester\InModuleScope $ModuleName {
			Get-NinjaOneUsers -includeRoles
		}

		@($result).Count | Pester\Should -Be 1
		$result[0].id | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/users' }
	}

	It 'uses the organisation users endpoint when organisationId is supplied' {
		$module = Get-Module -Name $ModuleName
		$result = Pester\InModuleScope $ModuleName {
			Get-NinjaOneUsers -organisationId 7 -userType END_USER
		}

		@($result).Count | Pester\Should -Be 1
		$result[0].name | Pester\Should -Be 'Test User'
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/organization/7/end-users' }
	}

	It 'delegates no-result default-path failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			{ Get-NinjaOneUsers } | Pester\Should -Throw '*No users found*'
		}

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result organisation-path failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		Pester\InModuleScope $ModuleName {
			{ Get-NinjaOneUsers -organisationId 12 -userType END_USER } | Pester\Should -Throw '*No users found for organisation 12*'
		}

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

# ============================================================================
# COMPREHENSIVE PUBLIC QUERY TEST SUITE SUMMARY
# ============================================================================
#
# This test suite validates public query functions in the NinjaOne PowerShell module.
# It uses Pester mocks to simulate API responses without requiring a live API connection.
#
# Test Categories:
# 1. Default Parameters - Verifies basic function calls retrieve data
# 2. Response Transformation - Validates JSON parsing and object construction
# 3. Parameter Passing - Ensures filters and options are sent to API correctly
# 4. Error Handling - Tests appropriate error responses from API
# 5. Pagination Support - Validates cursor-based pagination for large datasets
# 6. Data Validation - Ensures returned data has expected types and values
#
# Functions Tested:
# - Get-NinjaOneCustomFields: Device custom field definitions
# - Get-NinjaOneAntivirusStatus: Current antivirus product status per device
# - Get-NinjaOneAntivirusThreats: Historical antivirus threat detection records
# - Get-NinjaOneDeviceBackupUsage: Backup storage usage and quota information
#
# Mock Strategy:
# - Global Invoke-WebRequest mock in BeforeAll routes responses by API endpoint
# - Realistic JSON responses match actual NinjaOne API response structure
# - Error scenarios (401, 404, 500) tested with appropriate error responses
#
# Next Steps:
# - Expand to additional Queries category functions
# - Add tests for Users, Organization, Location, Ticketing categories
# - Test error scenarios comprehensively across all functions
# - Implement performance benchmarking for large dataset handling
#

Describe 'Get-NinjaOneAlerts' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ uid = 'alert-1'; message = 'CPU high' }
			)
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global alerts endpoint when deviceId is not supplied' {
		$result = Get-NinjaOneAlerts

		@($result).Count | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/alerts'
		}
	}

	It 'uses the device alerts endpoint when deviceId is supplied' {
		$result = Get-NinjaOneAlerts -deviceId 42

		@($result).Count | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/42/alerts'
		}
	}

	It 'passes sourceType as a query string parameter' {
		Get-NinjaOneAlerts -sourceType 'CONDITION_CUSTOM_FIELD'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('sourceType')
		}
	}

	It 'passes parseDateTime through to the GET request' {
		Get-NinjaOneAlerts -parseDateTime

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'throws no-result global errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneAlerts } | Pester\Should -Throw '*No alerts found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result device errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneAlerts -deviceId 7 } | Pester\Should -Throw '*No alerts found for device 7*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream global request failures to New-NinjaOneError without masking' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'Not found' }

		{ Get-NinjaOneAlerts } | Pester\Should -Throw '*Not found*'

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream device request failures to New-NinjaOneError without masking' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'Not found' }

		{ Get-NinjaOneAlerts -deviceId 7 } | Pester\Should -Throw '*Not found*'

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneJobs' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 1001; type = 'SOFTWARE_PATCH_MANAGEMENT'; status = 'COMPLETED' }
			)
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global jobs endpoint when deviceId is not supplied' {
		$result = Get-NinjaOneJobs

		@($result).Count | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/jobs'
		}
	}

	It 'uses the device jobs endpoint when deviceId is supplied' {
		$result = Get-NinjaOneJobs -deviceId 5

		@($result).Count | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/5/jobs'
		}
	}

	It 'passes jobType as a query string parameter' {
		Get-NinjaOneJobs -jobType 'SOFTWARE_PATCH_MANAGEMENT'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('jobType')
		}
	}

	It 'passes parseDateTime through to the GET request' {
		Get-NinjaOneJobs -parseDateTime

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'delegates no-result global failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneJobs } | Pester\Should -Throw '*No jobs found*'

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result device failures to New-NinjaOneError with device id' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneJobs -deviceId 5 } | Pester\Should -Throw '*No jobs found for device 5*'

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwareInventory' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 1; name = 'Microsoft Teams'; version = '1.6.0' }
			)
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'always uses the software query endpoint' {
		$result = Get-NinjaOneSoftwareInventory

		@($result).Count | Pester\Should -Be 1
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software'
		}
	}

	It 'passes deviceFilter as a query string parameter' {
		Get-NinjaOneSoftwareInventory -deviceFilter 'org = 1'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('deviceFilter')
		}
	}

	It 'converts installedBefore DateTime to Unix epoch before querying' {
		$dt = [datetime]'2024-05-01T00:00:00Z'
		Get-NinjaOneSoftwareInventory -installedBefore $dt

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedBefore')
		}
	}

	It 'converts installedAfter DateTime to Unix epoch before querying' {
		$dt = [datetime]'2024-01-01T00:00:00Z'
		Get-NinjaOneSoftwareInventory -installedAfter $dt

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedAfter')
		}
	}

	It 'removes installedBeforeUnixEpoch from parameters and promotes to installedBefore' {
		Get-NinjaOneSoftwareInventory -installedBeforeUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			(-not $Parameters.ContainsKey('installedBeforeUnixEpoch')) -and $Parameters.ContainsKey('installedBefore')
		}
	}

	It 'removes installedAfterUnixEpoch from parameters and promotes to installedAfter' {
		Get-NinjaOneSoftwareInventory -installedAfterUnixEpoch 1619712000

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			(-not $Parameters.ContainsKey('installedAfterUnixEpoch')) -and $Parameters.ContainsKey('installedAfter')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwareInventory } | Pester\Should -Throw '*No software inventory found*'

		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOrganisations' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Contoso' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the organisations endpoint by default' {
		$null = Get-NinjaOneOrganisations

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations'
		}
	}

	It 'uses the detailed organisations endpoint when -detailed is supplied' {
		$null = Get-NinjaOneOrganisations -detailed

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations-detailed'
		}
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('detailed')
		}
	}

	It 'uses the single-organisation endpoint when organisationId is supplied' {
		$null = Get-NinjaOneOrganisations -organisationId 21

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/21'
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError without masking' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'request-failed'
		}

		{ Get-NinjaOneOrganisations } | Pester\Should -Throw '*request-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result organisation errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOrganisations } | Pester\Should -Throw '*No organisations found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result single organisation errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOrganisations -organisationId 21 } | Pester\Should -Throw '*Organisation with id 21 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneLocations' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 101; name = 'London' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global locations endpoint when organisationId is not supplied' {
		$null = Get-NinjaOneLocations

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/locations'
		}
	}

	It 'uses the organisation locations endpoint when organisationId is supplied' {
		$null = Get-NinjaOneLocations -organisationId 12

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/12/locations'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneLocations -organisationId 12 } | Pester\Should -Throw '*No locations found for organisation 12*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDevices' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 7; systemName = 'WS-07' })
		}
		Pester\Mock -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 22 }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the devices endpoint by default' {
		$null = Get-NinjaOneDevices

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices'
		}
	}

	It 'uses the detailed devices endpoint when -detailed is supplied' {
		$null = Get-NinjaOneDevices -detailed

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices-detailed'
		}
	}

	It 'uses the single device endpoint when deviceId is supplied' {
		$null = Get-NinjaOneDevices -deviceId 7

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/7'
		}
	}

	It 'uses the organisation devices endpoint when organisationId is supplied and organisation exists' {
		$null = Get-NinjaOneDevices -organisationId 22

		Pester\Should-Invoke -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$organisationId -eq 22
		}
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/22/devices'
		}
	}

	It 'passes parseDateTime through to the GET request' {
		$null = Get-NinjaOneDevices -parseDateTime

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError without masking' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'request-failed'
		}

		{ Get-NinjaOneDevices -deviceId 7 } | Pester\Should -Throw '*request-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result global device errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDevices } | Pester\Should -Throw '*No devices found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result single device errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDevices -deviceId 7 } | Pester\Should -Throw '*Device with id 7 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneGroups' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Servers' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the groups endpoint' {
		$null = Get-NinjaOneGroups

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/groups'
		}
	}

	It 'passes languageTag as a query parameter' {
		$null = Get-NinjaOneGroups -languageTag 'en-GB'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('languageTag')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneGroups } | Pester\Should -Throw '*No groups found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOnePolicies' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Workstation Policy' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the policies endpoint' {
		$null = Get-NinjaOnePolicies

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/policies'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOnePolicies } | Pester\Should -Throw '*No policies found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneRoles' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Server' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the roles endpoint' {
		$null = Get-NinjaOneRoles

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/roles'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneRoles } | Pester\Should -Throw '*No roles found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTasks' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Daily Health Check' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the tasks endpoint' {
		$null = Get-NinjaOneTasks

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tasks'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTasks } | Pester\Should -Throw '*No tasks found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneNotificationChannels' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Email' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the notification channels endpoint by default' {
		$null = Get-NinjaOneNotificationChannels

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/notification-channels'
		}
	}

	It 'uses the enabled notification channels endpoint when -enabled is supplied' {
		$null = Get-NinjaOneNotificationChannels -enabled

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/notification-channels/enabled'
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'notification-request-failed'
		}

		{ Get-NinjaOneNotificationChannels } | Pester\Should -Throw '*notification-request-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result notification channel errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneNotificationChannels } | Pester\Should -Throw '*No notification channels found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneAutomations' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Reboot Device' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the automation scripts endpoint' {
		$null = Get-NinjaOneAutomations

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/automation/scripts'
		}
	}

	It 'passes languageTag as a query parameter' {
		$null = Get-NinjaOneAutomations -languageTag 'en'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('languageTag')
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'automation-request-failed'
		}

		{ Get-NinjaOneAutomations } | Pester\Should -Throw '*automation-request-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'throws no-result automation errors when the API returns null' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneAutomations } | Pester\Should -Throw '*No automation scripts found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneContact' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 42; name = 'Sam Contact' }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the contact endpoint with the provided id' {
		$null = Get-NinjaOneContact -id 42

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contact/42'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneContact -id 42 } | Pester\Should -Throw '*Contact with id 42 not found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceCustomFields' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ scope = 'node'; fieldName = 'assetTag' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global custom fields endpoint by default' {
		$null = Get-NinjaOneDeviceCustomFields

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device-custom-fields'
		}
	}

	It 'uses the device custom fields endpoint when deviceId is supplied' {
		$null = Get-NinjaOneDeviceCustomFields -deviceId 99

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/99/custom-fields'
		}
	}

	It 'passes scope as a query parameter' {
		$null = Get-NinjaOneDeviceCustomFields -scope 'node'

		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('scope')
		}
	}
}

Describe 'Get-NinjaOneSoftwareProducts' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Microsoft Edge' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global software products endpoint when deviceId is not supplied' {
		$null = Get-NinjaOneSoftwareProducts

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/software-products'
		}
	}

	It 'uses the device software endpoint when deviceId is supplied' {
		$null = Get-NinjaOneSoftwareProducts -deviceId 7

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/7/software'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError with device id' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwareProducts -deviceId 7 } | Pester\Should -Throw '*No software products found for device 7*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSystemContacts' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 9; name = 'Operations Team' })
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the contacts endpoint' {
		$null = Get-NinjaOneSystemContacts

		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contacts'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSystemContacts } | Pester\Should -Throw '*No system contacts found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneContact' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'posts contact payload to the contacts endpoint when confirmed' {
		$payload = @{ firstName = 'Jane'; lastName = 'Doe'; email = 'jane@example.com' }
		$result = New-NinjaOneContact -contact $payload -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/contacts'
		$result.body.firstName | Pester\Should -Be 'Jane'
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contacts'
		}
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'create-contact-failed' }

		{ New-NinjaOneContact -contact @{ firstName = 'Jane' } -Confirm:$false } | Pester\Should -Throw '*create-contact-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneContact' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'patches contact payload to the specific contact endpoint when confirmed' {
		$payload = @{ phone = '+3100000000' }
		$result = Set-NinjaOneContact -id 123 -contact $payload -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/contact/123'
		$result.body.phone | Pester\Should -Be '+3100000000'
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contact/123'
		}
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'update-contact-failed' }

		{ Set-NinjaOneContact -id 123 -contact @{ phone = '+3100000000' } -Confirm:$false } | Pester\Should -Throw '*update-contact-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneUserRoles' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets user roles from the user roles endpoint' {
		$result = Get-NinjaOneUserRoles

		$result.resource | Pester\Should -Be 'v2/user/roles'
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/user/roles'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'get-user-roles-failed' }

		{ Get-NinjaOneUserRoles } | Pester\Should -Throw '*get-user-roles-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTags' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets tags from the tags endpoint' {
		$result = Get-NinjaOneTags

		$result.resource | Pester\Should -Be 'v2/tag'
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tag'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'get-tags-failed' }

		{ Get-NinjaOneTags } | Pester\Should -Throw '*get-tags-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneTab' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'posts the tab payload when confirmed' {
		$payload = @{ name = 'Operations'; entityType = 'ORGANIZATION' }
		$result = New-NinjaOneTab -tab $payload -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/tab'
		$result.body.name | Pester\Should -Be 'Operations'
		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tab' -and $Body.name -eq 'Operations'
		}
	}

	It 'does not post the tab payload when WhatIf is used' {
		New-NinjaOneTab -tab @{ name = 'Operations' } -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'create-tab-failed' }

		{ New-NinjaOneTab -tab @{ name = 'Operations' } -Confirm:$false } | Pester\Should -Throw '*create-tab-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneTab' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'patches the tab payload to the specific tab endpoint when confirmed' {
		$payload = @{ position = 2 }
		$result = Set-NinjaOneTab -tabId 14 -tab $payload -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/tab/14'
		$result.body.position | Pester\Should -Be 2
		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tab/14' -and $Body.position -eq 2
		}
	}

	It 'does not patch the tab payload when WhatIf is used' {
		Set-NinjaOneTab -tabId 14 -tab @{ position = 2 } -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'update-tab-failed' }

		{ Set-NinjaOneTab -tabId 14 -tab @{ position = 2 } -Confirm:$false } | Pester\Should -Throw '*update-tab-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}
Describe 'Billing query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$BillingQueryCases = @(
		[pscustomobject]@{
			Name = 'accounts'
			InvokeCollection = { Get-NinjaOneBillingAccounts }
			InvokeItem = { Get-NinjaOneBillingAccounts -id 11 }
			CollectionResource = 'v2/billing/accounts'
			ItemResource = 'v2/billing/accounts/11'
			NoResultError = 'No billing accounts found.'
		}
		[pscustomobject]@{
			Name = 'agreements'
			InvokeCollection = { Get-NinjaOneBillingAgreements }
			InvokeItem = { Get-NinjaOneBillingAgreements -id 12 }
			CollectionResource = 'v2/billing/agreements'
			ItemResource = 'v2/billing/agreements/12'
			NoResultError = 'No billing agreements found.'
		}
		[pscustomobject]@{
			Name = 'invoices'
			InvokeCollection = { Get-NinjaOneBillingInvoices }
			InvokeItem = { Get-NinjaOneBillingInvoices -id 13 }
			CollectionResource = 'v2/billing/invoices'
			ItemResource = 'v2/billing/invoices/13'
			NoResultError = 'No billing invoices found.'
		}
		[pscustomobject]@{
			Name = 'products'
			InvokeCollection = { Get-NinjaOneBillingProducts }
			InvokeItem = { Get-NinjaOneBillingProducts -id 14 }
			CollectionResource = 'v2/billing/products'
			ItemResource = 'v2/billing/products/14'
			NoResultError = 'No billing products found.'
		}
	)

	It 'gets the <Name> collection' -ForEach $BillingQueryCases {
		$result = & $PSItem.InvokeCollection

		$result.resource | Pester\Should -Be $PSItem.CollectionResource
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.CollectionResource
		}
	}

	It 'gets a specific <Name> item and removes id from the query' -ForEach $BillingQueryCases {
		$result = & $PSItem.InvokeItem

		$result.resource | Pester\Should -Be $PSItem.ItemResource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('Id')
		}
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.ItemResource
		}
	}

	It 'delegates no-result errors for <Name>' -ForEach $BillingQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.InvokeCollection } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream API errors for <Name>' -ForEach $BillingQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'billing-api-failed' }

		{ & $PSItem.InvokeCollection } | Pester\Should -Throw '*billing-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}
Describe 'Device detail query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$DeviceDetailCases = @(
		[pscustomobject]@{
			Name = 'last logged on user'
			Invoke = { Get-NinjaOneDeviceLastLoggedOnUser -deviceId 21 }
			Resource = 'v2/device/21/last-logged-on-user'
		}
		[pscustomobject]@{
			Name = 'OS patches'
			Invoke = { Get-NinjaOneDeviceOSPatches -deviceId 22 -status 'APPROVED' -type 'SECURITY_UPDATES' -severity 'CRITICAL' }
			Resource = 'v2/device/22/os-patches'
		}
		[pscustomobject]@{
			Name = 'processors'
			Invoke = { Get-NinjaOneDeviceProcessors -deviceId 23 }
			Resource = 'v2/device/23/processors'
		}
		[pscustomobject]@{
			Name = 'software patches'
			Invoke = { Get-NinjaOneDeviceSoftwarePatches -deviceId 24 -status 'APPROVED' -type 'PATCH' -impact 'CRITICAL' }
			Resource = 'v2/device/24/software-patches'
		}
		[pscustomobject]@{
			Name = 'Windows services'
			Invoke = { Get-NinjaOneDeviceWindowsServices -deviceId 25 -name 'NinjaRMMAgent' -state 'RUNNING' }
			Resource = 'v2/device/25/windows-services'
		}
	)

	It 'gets device <Name> and excludes deviceId from the query' -ForEach $DeviceDetailCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('deviceId')
		}
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.Resource
		}
	}

	It 'delegates upstream API errors for device <Name>' -ForEach $DeviceDetailCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-detail-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*device-detail-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'returns policy overrides without expansion by default' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				id = 26
				overrides = @('antivirus', 'patching')
			}
		}

		$result = Get-NinjaOneDevicePolicyOverrides -deviceId 26

		$result.id | Pester\Should -Be 26
		$result.overrides | Pester\Should -HaveCount 2
	}

	It 'expands policy overrides when requested' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				overrides = @('antivirus', 'patching')
			}
		}

		$result = Get-NinjaOneDevicePolicyOverrides -deviceId 26 -expandOverrides

		$result | Pester\Should -HaveCount 2
		$result[0] | Pester\Should -Be 'antivirus'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('deviceId')
		}
	}

	It 'delegates policy override API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'policy-overrides-api-failed' }

		{ Get-NinjaOneDevicePolicyOverrides -deviceId 26 } | Pester\Should -Throw '*policy-overrides-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Backup and patch install query families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{ resource = $Resource; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$BackupCases = @(
		[pscustomobject]@{
			Name = 'backup jobs'
			Invoke = { Get-NinjaOneBackupJobs -status 'RUNNING' -deviceFilter 'all' }
			Resource = '/v2/backup/jobs'
			NoResultError = $null
		}
		[pscustomobject]@{
			Name = 'integrity check jobs'
			Invoke = { Get-NinjaOneIntegrityCheckJobs -status 'RUNNING' -deviceFilter 'all' }
			Resource = '/v2/backup/integrity-check-jobs'
			NoResultError = $null
		}
		[pscustomobject]@{
			Name = 'OS patch installs'
			Invoke = { Get-NinjaOneOSPatchInstalls -status 'FAILED' -deviceFilter 'all' -pageSize 10 }
			Resource = 'v2/queries/os-patch-installs'
			NoResultError = 'No OS patch installs found.'
		}
	)

	It 'gets <Name>' -ForEach $BackupCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'handles empty <Name> results' -ForEach $BackupCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		if ($PSItem.NoResultError) {
			{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		}
		else {
			{ & $PSItem.Invoke } | Pester\Should -Not -Throw
		}
	}

	It 'delegates <Name> API failures' -ForEach $BackupCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'backup-query-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*backup-query-failed*'
	}
}

Describe 'Custom field query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$CustomFieldQueryCases = @(
		[pscustomobject]@{
			Name = 'document signed URLs'
			Invoke = { Get-NinjaOneCustomFieldSignedURLs -clientDocumentId 31 }
			Resource = 'v2/organization/document/31/signed-urls'
			RemovedParameters = @('clientDocumentId')
			NoResultError = 'No custom field signed URLs found for custom field 31.'
		}
		[pscustomobject]@{
			Name = 'entity signed URLs'
			Invoke = { Get-NinjaOneEntityCustomFieldsSignedURLs -entityType 'ORGANIZATION' -entityId 32 }
			Resource = 'v2/custom-fields/entity-type/ORGANIZATION/32/signed-urls'
			RemovedParameters = @('entityType', 'entityId')
			NoResultError = 'No custom field signed URLs found for ORGANIZATION 32.'
		}
		[pscustomobject]@{
			Name = 'location custom fields'
			Invoke = { Get-NinjaOneLocationCustomFields -organisationId 33 -locationId 34 -withInheritance $true }
			Resource = 'v2/organization/33/location/34/custom-fields'
			RemovedParameters = @('organisationId', 'locationId')
			NoResultError = 'No custom fields found for organisation 33 - location 34.'
		}
	)

	It 'gets <Name> and excludes route parameters from the query' -ForEach $CustomFieldQueryCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ExpectedRemoved = $PSItem.RemovedParameters
			-not ($ExpectedRemoved | Where-Object { $Parameters.ContainsKey($_) })
		}
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.Resource
		}
	}

	It 'delegates no-result errors for <Name>' -ForEach $CustomFieldQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream errors for <Name>' -ForEach $CustomFieldQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'custom-field-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*custom-field-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets paged custom field schema results' {
		$result = Get-NinjaOneCustomFieldsSchema -cursorName 'next-page' -pageSize 25

		$result.resource | Pester\Should -Be 'v2/custom-fields'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('cursorName') -and $Parameters.ContainsKey('pageSize')
		}
	}

	It 'delegates custom field schema API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'schema-api-failed' }

		{ Get-NinjaOneCustomFieldsSchema } | Pester\Should -Throw '*schema-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneGroupMembers' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets group members and excludes groupId from the query' {
		$result = Get-NinjaOneGroupMembers -groupId 41 -refresh 'true'

		$result.resource | Pester\Should -Be 'v2/group/41/device-ids'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('groupId') -and $Parameters.ContainsKey('refresh')
		}
	}

	It 'delegates no-result errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneGroupMembers -groupId 41 } | Pester\Should -Throw '*No group members found for group 41.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'group-members-api-failed' }

		{ Get-NinjaOneGroupMembers -groupId 41 } | Pester\Should -Throw '*group-members-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Policy condition query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$PolicyConditionCases = @(
		[pscustomobject]@{
			Name = 'custom field condition'
			Invoke = { Get-NinjaOneCustomFieldsPolicyCondition -policyId 51 -conditionId 52 }
			Resource = 'v2/policies/51/condition/custom-fields/52'
			RemovedParameters = @('policyId', 'conditionId')
		}
		[pscustomobject]@{
			Name = 'Windows event condition'
			Invoke = { Get-NinjaOneWindowsEventPolicyCondition -policyId 53 -conditionId 54 }
			Resource = 'v2/policies/53/condition/windows-event/54'
			RemovedParameters = @('policyId', 'conditionId')
		}
	)

	It 'gets a specific <Name> and excludes route parameters' -ForEach $PolicyConditionCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ExpectedRemoved = $PSItem.RemovedParameters
			-not ($ExpectedRemoved | Where-Object { $Parameters.ContainsKey($_) })
		}
	}

	It 'delegates upstream API errors for <Name>' -ForEach $PolicyConditionCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'policy-condition-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*policy-condition-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	$PolicyConditionCollectionCases = @(
		[pscustomobject]@{
			Name = 'custom field conditions'
			Invoke = { Get-NinjaOneCustomFieldsPolicyConditions -policyId 55 }
			Resource = 'v2/policies/55/condition/custom-fields'
			NoResultError = 'No custom fields conditions found for policy 55.'
		}
		[pscustomobject]@{
			Name = 'Windows event conditions'
			Invoke = { Get-NinjaOneWindowsEventPolicyConditions -policyId 56 }
			Resource = 'v2/policies/56/condition/windows-event'
			NoResultError = 'No windows event conditions found for policy 56.'
		}
	)

	It 'gets <Name> and excludes policyId from the query' -ForEach $PolicyConditionCollectionCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('policyId')
		}
	}

	It 'delegates no-result errors for <Name>' -ForEach $PolicyConditionCollectionCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates collection API errors for <Name>' -ForEach $PolicyConditionCollectionCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'policy-conditions-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*policy-conditions-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneNodeRoles' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets assignable node roles' {
		$result = Get-NinjaOneNodeRoles -isAssignable

		$result.resource | Pester\Should -Be 'v2/noderole/list'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('isAssignable')
		}
	}

	It 'delegates upstream API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'node-roles-api-failed' }

		{ Get-NinjaOneNodeRoles } | Pester\Should -Throw '*node-roles-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Knowledge base query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$KnowledgeBaseCollectionCases = @(
		[pscustomobject]@{
			Name = 'global articles'
			Invoke = { Get-NinjaOneGlobalKnowledgeBaseArticles -articleName 'Runbook' }
			Resource = 'v2/knowledgebase/global/articles'
			ExpectedQueryParameters = @('articleName')
		}
		[pscustomobject]@{
			Name = 'organisation articles'
			Invoke = { Get-NinjaOneOrganisationKnowledgeBaseArticles -articleName 'Runbook' -organisationIds '61,62' }
			Resource = 'v2/knowledgebase/organization/articles'
			ExpectedQueryParameters = @('articleName', 'organisationIds')
		}
	)

	It 'gets <Name> with expected query parameters' -ForEach $KnowledgeBaseCollectionCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ExpectedParameters = $PSItem.ExpectedQueryParameters
			-not ($ExpectedParameters | Where-Object { -not $Parameters.ContainsKey($_) })
		}
	}

	It 'delegates upstream API errors for <Name>' -ForEach $KnowledgeBaseCollectionCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'knowledge-base-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*knowledge-base-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'downloads a knowledge base article by default' {
		$result = Get-NinjaOneKnowledgeBaseArticle -articleId 63

		$result.resource | Pester\Should -Be 'v2/knowledgebase/article/63/download'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('articleId')
		}
	}

	It 'gets signed URLs for a knowledge base article' {
		$result = Get-NinjaOneKnowledgeBaseArticle -articleId 63 -signedUrls

		$result.resource | Pester\Should -Be 'v2/knowledgebase/article/63/signed-urls'
	}

	It 'delegates knowledge base article API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'article-api-failed' }

		{ Get-NinjaOneKnowledgeBaseArticle -articleId 63 } | Pester\Should -Throw '*article-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets all knowledge base folders with filters' {
		$result = Get-NinjaOneKnowledgeBaseFolders -folderPath 'Operations/Runbooks' -organisationId 64

		$result.resource | Pester\Should -Be 'v2/knowledgebase/folder'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('folderId') -and
			$Parameters.ContainsKey('folderPath') -and
			$Parameters.ContainsKey('organisationId')
		}
	}

	It 'gets a specific knowledge base folder' {
		$result = Get-NinjaOneKnowledgeBaseFolders -folderId 65

		$result.resource | Pester\Should -Be 'v2/knowledgebase/folder/65'
	}

	It 'delegates knowledge base folder API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'folder-api-failed' }

		{ Get-NinjaOneKnowledgeBaseFolders } | Pester\Should -Throw '*folder-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Organisation and management query functions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection, $Raw)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
				raw = $Raw
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord, $Message)
			if ($ErrorRecord) {
				throw $ErrorRecord.Exception
			}
			throw $Message
		}
	}

	It 'gets organisation devices with paging parameters' {
		Pester\Mock -CommandName Get-NinjaOneDevices -ModuleName $ModuleName -MockWith {
			param($organisationId, $after, $pageSize)
			[pscustomobject]@{
				organisationId = $organisationId
				after = $after
				pageSize = $pageSize
			}
		}

		$result = Get-NinjaOneOrganisationDevices -organisationId 71 -after 10 -pageSize 25

		$result.organisationId | Pester\Should -Be 71
		$result.after | Pester\Should -Be 10
		$result.pageSize | Pester\Should -Be 25
	}

	It 'gets backup usage for all organisation locations' {
		$result = Get-NinjaOneOrganisationLocationBackupUsage -organisationId 72

		$result.resource | Pester\Should -Be 'v2/organization/72/locations/backup/usage'
	}

	It 'gets backup usage for a specific organisation location' {
		$result = Get-NinjaOneOrganisationLocationBackupUsage -organisationId 72 -locationId 73

		$result.resource | Pester\Should -Be 'v2/organization/72/locations/73/backup/usage'
	}

	It 'delegates organisation backup usage API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'backup-usage-api-failed' }

		{ Get-NinjaOneOrganisationLocationBackupUsage -organisationId 72 } | Pester\Should -Throw '*backup-usage-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets a raw device dashboard redirect' {
		$result = Get-NinjaOneDeviceDashboardURL -deviceId 74 -redirect

		$result.resource | Pester\Should -Be 'v2/device/74/dashboard-url'
		$result.raw | Pester\Should -BeTrue
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('deviceId')
		}
	}

	It 'delegates empty dashboard URL results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDeviceDashboardURL -deviceId 74 } | Pester\Should -Throw
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets an installer and excludes route parameters' {
		$result = Get-NinjaOneInstaller -organisationId 75 -locationId 76 -installerType 'WINDOWS_MSI'

		$result.resource | Pester\Should -Be 'v2/organization/75/location/76/installer/WINDOWS_MSI'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('organisationId') -and
			-not $Parameters.ContainsKey('locationId') -and
			-not $Parameters.ContainsKey('installerType')
		}
	}

	It 'delegates installer API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'installer-api-failed' }

		{ Get-NinjaOneInstaller -organisationId 75 -locationId 76 -installerType 'WINDOWS_MSI' } | Pester\Should -Throw '*installer-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Device management actions' {
	BeforeEach {
		Pester\Mock -CommandName Get-NinjaOneDevice -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				id = 81
				systemName = 'WORKSTATION-81'
			}
		}

		Pester\Mock -CommandName Get-NinjaOneDeviceWindowsServices -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				displayName = 'Print Spooler'
			}
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'restarts a device with a reason when confirmed' {
		Restart-NinjaOneDevice -deviceId 81 -mode 'FORCED' -reason 'Maintenance' -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/reboot/FORCED' -and $Body.reason -eq 'Maintenance'
		}
	}

	It 'does not restart a device when WhatIf is used' {
		Restart-NinjaOneDevice -deviceId 81 -mode 'NORMAL' -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates restart API errors' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'restart-api-failed' }

		{ Restart-NinjaOneDevice -deviceId 81 -mode 'NORMAL' -Confirm:$false } | Pester\Should -Throw '*restart-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'resets device policy overrides when confirmed' {
		Reset-NinjaOneDevicePolicyOverrides -deviceId 81 -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/policy/overrides'
		}
	}

	It 'delegates missing devices when resetting policy overrides' {
		Pester\Mock -CommandName Get-NinjaOneDevice -ModuleName $ModuleName -MockWith { $null }

		{ Reset-NinjaOneDevicePolicyOverrides -deviceId 81 -Confirm:$false } | Pester\Should -Throw '*Device with id 81 not found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'invokes a Windows service action when confirmed' {
		Invoke-NinjaOneWindowsServiceAction -deviceId 81 -serviceId 'Spooler' -action 'RESTART' -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/windows-service/Spooler/control' -and $Body.action -eq 'RESTART'
		}
	}

	It 'delegates missing Windows services' {
		Pester\Mock -CommandName Get-NinjaOneDeviceWindowsServices -ModuleName $ModuleName -MockWith { $null }

		{ Invoke-NinjaOneWindowsServiceAction -deviceId 81 -serviceId 'Missing' -action 'START' -Confirm:$false } | Pester\Should -Throw '*Service with id Missing not found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates missing devices for Windows service actions' {
		Pester\Mock -CommandName Get-NinjaOneDevice -ModuleName $ModuleName -MockWith { $null }

		{ Invoke-NinjaOneWindowsServiceAction -deviceId 81 -serviceId 'Spooler' -action 'START' -Confirm:$false } | Pester\Should -Throw '*Device with id 81 not found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'does not invoke a Windows service action when WhatIf is used' {
		Invoke-NinjaOneWindowsServiceAction -deviceId 81 -serviceId 'Spooler' -action 'STOP' -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}
}

Describe 'Additional public API coverage' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				query = $QSCollection
			}
		}

		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'post'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'put'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{ method = 'delete'; resource = $Resource; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets all asset relationships' {
		$result = Get-NinjaOneAssetRelationships

		$result.resource | Pester\Should -Be 'v2/itam/asset-relationship/relations'
	}

	It 'gets asset relationships for a specific entity' {
		$result = Get-NinjaOneAssetRelationships -entityType 'DEVICE' -entityId 91

		$result.resource | Pester\Should -Be 'v2/itam/asset-relationship/DEVICE/91/relations'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('EntityType') -and -not $Parameters.ContainsKey('EntityId')
		}
	}

	It 'delegates empty asset relationship results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneAssetRelationships } | Pester\Should -Throw '*No asset relationships found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets billing products for a ticket' {
		$result = Get-NinjaOneBillingTicketProducts -ticketId 92

		$result.resource | Pester\Should -Be 'v2/billing/ticket-products/ticket/92'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('TicketId')
		}
	}

	It 'delegates empty billing ticket product results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneBillingTicketProducts -ticketId 92 } | Pester\Should -Throw '*No billing ticket products found for ticket 92.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'creates custom fields in bulk' {
		$result = Invoke-NinjaOneCustomFieldsBulk -operation 'create' -customFields @(@{ name = 'Region' }) -Confirm:$false

		$result.method | Pester\Should -Be 'post'
		$result.resource | Pester\Should -Be 'v2/custom-fields/bulk'
	}

	It 'updates custom fields in bulk' {
		$result = Invoke-NinjaOneCustomFieldsBulk -operation 'update' -customFields @(@{ name = 'Region'; label = 'Office Region' }) -Confirm:$false

		$result.method | Pester\Should -Be 'put'
		$result.body[0].label | Pester\Should -Be 'Office Region'
	}

	It 'deletes custom fields in bulk' {
		$result = Invoke-NinjaOneCustomFieldsBulk -operation 'delete' -fieldNames @('Region', 'Floor') -Confirm:$false

		$result.method | Pester\Should -Be 'delete'
		$result.resource | Pester\Should -Be 'v2/custom-fields/bulk'
		$result.query.fieldNames | Pester\Should -Be 'Region,Floor'
	}

	It 'does not execute bulk custom field operations with WhatIf' {
		Invoke-NinjaOneCustomFieldsBulk -operation 'create' -customFields @(@{ name = 'Region' }) -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}
}

Describe 'Additional public query coverage' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{ resource = $Resource; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}


	$SimpleQueryCases = @(
		[pscustomobject]@{
			Name = 'asset relationship types'
			Invoke = { Get-NinjaOneAssetRelationshipTypes }
			Resource = 'v2/itam/asset-relationship/types'
			NoResultError = 'No asset relationship types found.'
		}
		[pscustomobject]@{
			Name = 'software licenses'
			Invoke = { Get-NinjaOneSoftwareLicenses }
			Resource = 'v2/software-license/licenses'
			NoResultError = 'No software licenses found.'
		}
		[pscustomobject]@{
			Name = 'contacts'
			Invoke = { Get-NinjaOneContacts }
			Resource = 'v2/contacts'
			NoResultError = 'No contacts found.'
		}
	)

	It 'gets <Name>' -ForEach $SimpleQueryCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'delegates empty results for <Name>' -ForEach $SimpleQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates API errors for <Name>' -ForEach $SimpleQueryCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'simple-query-api-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*simple-query-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'searches devices with query and limit parameters' {
		$result = Find-NinjaOneDevices -searchQuery 'WORKSTATION' -limit 10

		$result.resource | Pester\Should -Be 'v2/devices/search'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('searchQuery') -and $Parameters.ContainsKey('limit')
		}
	}

	It 'delegates device search API errors' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-search-api-failed' }

		{ Find-NinjaOneDevices -searchQuery 'WORKSTATION' } | Pester\Should -Throw '*device-search-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Instance capabilities' {
	BeforeEach {
		Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				BaseUrl = 'https://fed.ninjarmm.com'
				Version = '7.2.0'
				SpecUrl = 'https://fed.ninjarmm.com/openapi.json'
				RetrievedAt = [datetime]'2026-08-07T10:00:00Z'
				Paths = [ordered]@{
					'/v2/alerts' = @('GET')
				}
			}
		}
		Pester\Mock -CommandName Get-Module -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				ExportedFunctions = [ordered]@{ 'Get-NinjaOneAlerts' = $true; 'Get-NinjaOneMysteryCommand' = $true }
			}
		}
		Pester\Mock -CommandName Get-Command -ModuleName $ModuleName -MockWith {
			param($Module, $CommandType)

			@(
				[pscustomobject]@{
					Name = 'Get-NinjaOneAlerts'
					ScriptBlock = [scriptblock]::Create('param()')
				}
				[pscustomobject]@{
					Name = 'Get-NinjaOneMysteryCommand'
					ScriptBlock = [scriptblock]::Create('param();')
				}
			)
		}
	}

	It 'returns capability summary for an instance' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com'

		$result.BaseUrl | Pester\Should -Be 'https://fed.ninjarmm.com'
		$result.PathCount | Pester\Should -Be 1
	}

	It 'delegates missing instance selection' {
		Pester\Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneInstanceCapabilities } | Pester\Should -Throw '*No instance selected*'
	}

	It 'includes supported cmdlets when requested' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includeCmdlets

		$result.SupportedCmdletCount | Pester\Should -Be 0
		$result.UnsupportedCmdletCount | Pester\Should -Be 0
	}

	It 'includes raw paths when requested' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includePaths

		$result.Paths['/v2/alerts'] | Pester\Should -Contain 'GET'
	}
}

Describe 'Scripting options and document templates' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{
				resource = $Resource
				categories = @('Maintenance', 'Security')
				scripts = @('Patch Devices', 'Collect Logs')
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'returns full device scripting options by default' {
		$result = Get-NinjaOneDeviceScriptingOptions -deviceId 101 -languageTag 'en-US'

		$result.resource | Pester\Should -Be 'v2/device/101/scripting/options'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('deviceId') -and $Parameters.ContainsKey('languageTag')
		}
	}

	It 'returns scripting categories only' {
		$result = Get-NinjaOneDeviceScriptingOptions -deviceId 101 -categories

		$result | Pester\Should -HaveCount 2
		$result[0] | Pester\Should -Be 'Maintenance'
	}

	It 'returns scripts only' {
		$result = Get-NinjaOneDeviceScriptingOptions -deviceId 101 -scripts

		$result | Pester\Should -HaveCount 2
		$result[0] | Pester\Should -Be 'Patch Devices'
	}

	It 'delegates empty scripting option results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDeviceScriptingOptions -deviceId 101 } | Pester\Should -Throw
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets all document templates' {
		$result = Get-NinjaOneDocumentTemplates

		$result.resource | Pester\Should -Be 'v2/document-templates'
	}

	It 'delegates missing document templates' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDocumentTemplates } | Pester\Should -Throw '*No document templates found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets a document template by id without recursion' {
		$result = Get-NinjaOneDocumentTemplates -documentTemplateId 102

		$result.resource | Pester\Should -Be 'v2/document-templates/102'
		Pester\Should-Invoke -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1
	}

	It 'delegates missing document template results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneDocumentTemplates -documentTemplateId 102 } | Pester\Should -Throw '*Document template with id 102 not found.*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'End user and removal operations' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body, $QSCollection)
			[pscustomobject]@{ resource = $Resource; body = $Body; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}


	It 'creates an end user and passes invitation options in the query' {
		$result = New-NinjaOneEndUser -endUser @{ firstName = 'Jane'; email = 'jane@example.com' } -sendInvitation -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/user/end-users'
		$result.body.firstName | Pester\Should -Be 'Jane'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('endUser') -and $Parameters.ContainsKey('sendInvitation')
		}
	}

	It 'does not create an end user when WhatIf is used' {
		New-NinjaOneEndUser -endUser @{ firstName = 'Jane' } -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'updates end user device access' {
		$result = Set-NinjaOneEndUserDeviceAccess -id 111 -addDeviceIds 1, 2 -removeDeviceIds 3 -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/user/end-user/111/device-access'
		$result.body.addDeviceIds | Pester\Should -HaveCount 2
		$result.body.removeDeviceIds[0] | Pester\Should -Be 3
	}

	It 'requires an end user device access change' {
		{ Set-NinjaOneEndUserDeviceAccess -id 111 -Confirm:$false } | Pester\Should -Throw '*Specify at least one*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'removes a tab by id' {
		Remove-NinjaOneTab -tabId 112 -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tab/112'
		}
	}

	It 'removes the webhook configuration default route' {
		Remove-NinjaOneWebhook -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/webhook'
		}
	}

	It 'removes a specific webhook route' {
		Remove-NinjaOneWebhook -webhookId 'hook-113' -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/webhook/hook-113'
		}
	}
}

Describe 'Attachment, backup, and document operations' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{ resource = $Resource; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body, $UseMultipart)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
				useMultipart = $UseMultipart
				jobUid = 'job-121'
			}
		}

		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}


	It 'creates and returns an attachment relation' {
		$result = New-NinjaOneAttachmentRelation -entityType 'ORGANIZATION' -entityId 121 -attachmentRelation @{ name = 'contract.pdf' } -show -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/related-items/entity/ORGANIZATION/121/attachment'
		$result.useMultipart | Pester\Should -BeTrue
	}

	It 'delegates attachment relation API errors' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'attachment-api-failed' }

		{ New-NinjaOneAttachmentRelation -entityType 'ORGANIZATION' -entityId 121 -attachmentRelation @{} -Confirm:$false } | Pester\Should -Throw '*attachment-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'does not create an attachment relation with WhatIf' {
		New-NinjaOneAttachmentRelation -entityType 'ORGANIZATION' -entityId 121 -attachmentRelation @{} -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'creates an integrity check job from individual parameters' {
		$planUid = [guid]'00000000-0000-0000-0000-000000000122'
		$result = New-NinjaOneIntegrityCheckJob -deviceId 122 -planUid $planUid -show -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/backup/integrity-check-jobs'
		$result.body.deviceId | Pester\Should -Be 122
		$result.body.planUid | Pester\Should -Be $planUid
	}

	It 'creates an integrity check job from a body' {
		$body = @{ deviceId = 123; planUid = [guid]'00000000-0000-0000-0000-000000000123' }
		$result = New-NinjaOneIntegrityCheckJob -integrityCheckJob $body -show -Confirm:$false

		$result.body.deviceId | Pester\Should -Be 123
	}

	It 'does not create an integrity check job with WhatIf' {
		$body = @{ deviceId = 123; planUid = [guid]'00000000-0000-0000-0000-000000000123' }

		New-NinjaOneIntegrityCheckJob -integrityCheckJob $body -WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates integrity check job API errors' {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'integrity-job-api-failed' }
		$body = @{ deviceId = 123; planUid = [guid]'00000000-0000-0000-0000-000000000123' }

		{ New-NinjaOneIntegrityCheckJob -integrityCheckJob $body -Confirm:$false } | Pester\Should -Throw '*integrity-job-api-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'gets organisation document signed URLs' {
		$result = Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 124

		$result.resource | Pester\Should -Be 'v2/organization/document/124/signed-urls'
		Pester\Should-Invoke -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('clientDocumentId')
		}
	}

	It 'delegates empty organisation document signed URL results' {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 124 } | Pester\Should -Throw '*No organisation document signed URLs found*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'User and tab query families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ id = 201; resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$SimpleUserCases = @(
		[pscustomobject]@{
			Name = 'end users'
			Invoke = { Get-NinjaOneEndUsers }
			Resource = 'v2/user/end-users'
			NoResultError = 'No end users found.'
		}
		[pscustomobject]@{
			Name = 'technicians'
			Invoke = { Get-NinjaOneTechnicians }
			Resource = 'v2/user/technicians'
			NoResultError = 'No technicians found.'
		}
	)

	It 'gets <Name>' -ForEach $SimpleUserCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'delegates empty <Name> results' -ForEach $SimpleUserCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates <Name> API failures' -ForEach $SimpleUserCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'user-query-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*user-query-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	$TabCases = @(
		[pscustomobject]@{
			Name = 'tab end user'
			Invoke = { Get-NinjaOneTabEndUser -tabId 202 }
			Resource = 'v2/tab/202/end-user'
			NoResultError = 'End-user for tab 202 not found.'
		}
		[pscustomobject]@{
			Name = 'tab organisation'
			Invoke = { Get-NinjaOneTabOrganisation -tabId 203 }
			Resource = 'v2/tab/203/organization'
			NoResultError = 'Organisation for tab 203 not found.'
		}
		[pscustomobject]@{
			Name = 'tab role'
			Invoke = { Get-NinjaOneTabRole -tabId 204 -roleId 205 }
			Resource = 'v2/tab/204/role/205'
			NoResultError = 'Tab 204 for role 205 not found.'
		}
	)

	It 'gets <Name>' -ForEach $TabCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'delegates empty <Name> results' -ForEach $TabCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates <Name> API failures' -ForEach $TabCases {
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'tab-query-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*tab-query-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Organisation checklist families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $QSCollection)
			[pscustomobject]@{ resource = $Resource; query = $QSCollection }
		}
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			204
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'gets all organisation checklists' {
		$result = Get-NinjaOneOrganisationChecklists

		$result.resource | Pester\Should -Be 'v2/organization/checklists'
	}

	It 'gets an organisation checklist by id' {
		$result = Get-NinjaOneOrganisationChecklist -checklistId 201

		$result.resource | Pester\Should -Be 'v2/organization/checklist/201'
	}

	It 'gets organisation checklist signed URLs' {
		$result = Get-NinjaOneOrganisationChecklistSignedURLs -checklistId 202

		$result.resource | Pester\Should -Be 'v2/organization/checklist/202/signed-urls'
	}

	It 'promotes organisation checklists with a new name' {
		$result = Invoke-NinjaOneOrganisationChecklistsPromoteWithName -request @{ checklistIds = @(1, 2); name = 'Renamed' } -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/organization/checklists/promote-with-name'
	}

	It 'removes an organisation checklist' {
		Remove-NinjaOneOrganisationChecklist -checklistId 203 -Confirm:$false

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/checklist/203'
		}
	}

	It 'creates organisation checklists from templates' {
		$result = New-NinjaOneOrganisationChecklistsFromTemplates -organisationId 204 -request @{ templateIds = @(10, 11) } -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/organization/204/checklists-from-templates'
	}

	It 'updates organisation checklists' {
		$result = Set-NinjaOneOrganisationChecklists -checklists @(@{ checklistId = 205; name = 'Updated' }) -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/organization/checklists'
	}

	It 'promotes organisation checklists' {
		$result = Invoke-NinjaOneOrganisationChecklistsPromote -request @{ checklistIds = @(206, 207) } -Confirm:$false

		$result.resource | Pester\Should -Be 'v2/organization/checklists/promote'
	}
}

Describe 'User removal families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ method = 'delete'; resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$RemovalCases = @(
		[pscustomobject]@{
			Name = 'end user removal'
			Invoke = { Remove-NinjaOneEndUser -id 431 -Confirm:$false }
			WhatIf = { Remove-NinjaOneEndUser -id 431 -WhatIf }
			Resource = 'v2/user/end-user/431'
		}
		[pscustomobject]@{
			Name = 'technician removal'
			Invoke = { Remove-NinjaOneTechnician -id 432 -Confirm:$false }
			WhatIf = { Remove-NinjaOneTechnician -id 432 -WhatIf }
			Resource = 'v2/user/technician/432'
		}
	)

	It 'executes <Name>' -ForEach $RemovalCases {
		& $PSItem.Invoke

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.Resource
		}
	}

	It 'does not execute <Name> with WhatIf' -ForEach $RemovalCases {
		& $PSItem.WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates <Name> failures' -ForEach $RemovalCases {
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { throw 'user-delete-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*user-delete-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'User set families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'patch'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$UserSetCases = @(
		[pscustomobject]@{
			Name = 'end user device access'
			Invoke = { Set-NinjaOneEndUserDeviceAccess -id 441 -addDeviceIds 10, 11 -removeDeviceIds 12 -Confirm:$false }
			WhatIf = { Set-NinjaOneEndUserDeviceAccess -id 441 -addDeviceIds 10, 11 -removeDeviceIds 12 -WhatIf }
			Resource = 'v2/user/end-user/441/device-access'
		}
		[pscustomobject]@{
			Name = 'user role organization permissions'
			Invoke = { Set-NinjaOneUserRoleOrganizationPermissions -roleId 442 -permissions @{ allowAll = $true } -Confirm:$false }
			WhatIf = { Set-NinjaOneUserRoleOrganizationPermissions -roleId 442 -permissions @{ allowAll = $true } -WhatIf }
			Resource = 'v2/user/role/442/permissions/organizations'
		}
	)

	It 'executes <Name>' -ForEach $UserSetCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'does not execute <Name> with WhatIf' -ForEach $UserSetCases {
		& $PSItem.WhatIf

		Pester\Should-Invoke -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates <Name> failures' -ForEach $UserSetCases {
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'user-set-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*user-set-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Tag mutation families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'post'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'put'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	Describe 'Ticketing query families' {
		BeforeEach {
			Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
				[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
			}
			Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
				param($Resource, $QSCollection)
				[pscustomobject]@{ resource = $Resource; query = $QSCollection }
			}
			Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
				param($ErrorRecord)
				throw $ErrorRecord.Exception
			}
		}

		Describe 'Device query families' {
			BeforeEach {
				Pester\Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
					[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
				}
				Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
					param($Resource, $QSCollection)
					[pscustomobject]@{ resource = $Resource; query = $QSCollection }
				}
				Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
					param($ErrorRecord)
					throw $ErrorRecord.Exception
				}
			}

			$DeviceCases = @(
				[pscustomobject]@{
					Name = 'device disks'
					Invoke = { Get-NinjaOneDeviceDisks -deviceId 408 }
					Resource = 'v2/device/408/disks'
					NoResultError = $null
				}
				[pscustomobject]@{
					Name = 'device network interfaces'
					Invoke = { Get-NinjaOneDeviceNetworkInterfaces -deviceId 409 }
					Resource = 'v2/device/409/network-interfaces'
					NoResultError = $null
				}
				[pscustomobject]@{
					Name = 'device volumes'
					Invoke = { Get-NinjaOneDeviceVolumes -deviceId 410 -include bl }
					Resource = 'v2/device/410/volumes'
					NoResultError = $null
				}
			)

			It 'gets <Name>' -ForEach $DeviceCases {
				$result = & $PSItem.Invoke

				$result.resource | Pester\Should -Be $PSItem.Resource
			}

			It 'returns a value for empty <Name> results' -ForEach $DeviceCases {
				Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

				{ & $PSItem.Invoke } | Pester\Should -Not -Throw
			}

			It 'delegates <Name> API failures' -ForEach $DeviceCases {
				Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-query-failed' }

				{ & $PSItem.Invoke } | Pester\Should -Throw '*device-query-failed*'
			}
		}

		$TicketingCases = @(
			[pscustomobject]@{
				Name = 'ticket attributes'
				Invoke = { Get-NinjaOneTicketAttributes }
				Resource = 'v2/ticketing/attributes'
				NoResultError = 'No ticket attributes found.'
			}
			[pscustomobject]@{
				Name = 'ticket boards'
				Invoke = { Get-NinjaOneTicketBoards }
				Resource = 'v2/ticketing/trigger/boards'
				NoResultError = 'No boards found.'
			}
			[pscustomobject]@{
				Name = 'ticket statuses'
				Invoke = { Get-NinjaOneTicketStatuses }
				Resource = 'v2/ticketing/statuses'
				NoResultError = 'No ticket statuses found.'
			}
			[pscustomobject]@{
				Name = 'ticketing contacts'
				Invoke = { Get-NinjaOneTicketingContacts }
				Resource = 'v2/ticketing/contact/contacts'
				NoResultError = 'No ticketing contacts found.'
			}
			[pscustomobject]@{
				Name = 'ticketing users'
				Invoke = { Get-NinjaOneTicketingUsers -anchorNaturalId 405 -clientId 406 -pageSize 10 -searchCriteria 'mikey' -userType TECHNICIAN }
				Resource = 'v2/ticketing/app-user-contact'
				NoResultError = 'No ticketing users found.'
			}
			[pscustomobject]@{
				Name = 'ticket forms'
				Invoke = { Get-NinjaOneTicketForms -ticketFormId 407 }
				Resource = '/v2/ticketing/ticket-form/407'
				NoResultError = 'No ticket forms found.'
			}
		)

		It 'gets <Name>' -ForEach $TicketingCases {
			$result = & $PSItem.Invoke

			$result.resource | Pester\Should -Be $PSItem.Resource
		}

		It 'delegates empty <Name> results' -ForEach $TicketingCases {
			Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

			{ & $PSItem.Invoke } | Pester\Should -Throw ('*{0}*' -f $PSItem.NoResultError)
		}

		It 'delegates <Name> API failures' -ForEach $TicketingCases {
			Pester\Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'ticketing-query-failed' }

			{ & $PSItem.Invoke } | Pester\Should -Throw '*ticketing-query-failed*'
		}
	}

	$MutationCases = @(
		[pscustomobject]@{
			Name = 'tag create'
			Invoke = { New-NinjaOneTag -tag @{ name = 'Priority-2'; description = 'Batch coverage' } -Confirm:$false }
			WhatIf = { New-NinjaOneTag -tag @{ name = 'Priority-2'; description = 'Batch coverage' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag'
		}
		[pscustomobject]@{
			Name = 'tag update'
			Invoke = { Set-NinjaOneTag -tagId 321 -tag @{ name = 'Priority-1' } -Confirm:$false }
			WhatIf = { Set-NinjaOneTag -tagId 321 -tag @{ name = 'Priority-1' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/tag/321'
		}
		[pscustomobject]@{
			Name = 'tag removal'
			Invoke = { Remove-NinjaOneTag -tagId 324 -Confirm:$false }
			WhatIf = { Remove-NinjaOneTag -tagId 324 -WhatIf }
			Command = 'New-NinjaOneDELETERequest'
		}
		[pscustomobject]@{
			Name = 'tag batch update'
			Invoke = { Set-NinjaOneTagBatch -assetType 'device' -tagUpdate @{ assetIds = @(123, 456); tagIdsToAdd = @(1, 2); tagIdsToRemove = @(3, 4) } -Confirm:$false }
			WhatIf = { Set-NinjaOneTagBatch -assetType 'device' -tagUpdate @{ assetIds = @(123, 456); tagIdsToAdd = @(1, 2); tagIdsToRemove = @(3, 4) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag/device'
		}
		[pscustomobject]@{
			Name = 'tag merge'
			Invoke = { Merge-NinjaOneTags -mergeRequest @{ sourceTagIds = @(322, 323); targetTagId = 321 } -Confirm:$false }
			WhatIf = { Merge-NinjaOneTags -mergeRequest @{ sourceTagIds = @(322, 323); targetTagId = 321 } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag/merge'
		}
	)

	It 'executes <Name>' -ForEach $MutationCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
	}

	It 'does not execute <Name> with WhatIf' -ForEach $MutationCases {
		& $PSItem.WhatIf

		Pester\Should-Invoke -CommandName $PSItem.Command -ModuleName $ModuleName -Times 0
	}

	It 'delegates <Name> failures' -ForEach $MutationCases {
		Pester\Mock -CommandName $PSItem.Command -ModuleName $ModuleName -MockWith { throw 'action-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*action-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Billing mutation families' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'post'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'put'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'patch'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith {
			param($Resource)
			[pscustomobject]@{ method = 'delete'; resource = $Resource }
		}
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}


	$BillingCases = @(
		[pscustomobject]@{
			Name = 'billing account creation'
			Invoke = { New-NinjaOneBillingAccount -billingAccount @{ name = 'Managed Services' } -Confirm:$false }
			WhatIf = { New-NinjaOneBillingAccount -billingAccount @{ name = 'Managed Services' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/billing/accounts'
		}
		[pscustomobject]@{
			Name = 'billing agreement creation'
			Invoke = { New-NinjaOneBillingAgreement -billingAgreement @{ name = 'Premium Support' } -Confirm:$false }
			WhatIf = { New-NinjaOneBillingAgreement -billingAgreement @{ name = 'Premium Support' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/billing/agreements'
		}
		[pscustomobject]@{
			Name = 'billing invoice creation'
			Invoke = { New-NinjaOneBillingInvoice -billingInvoice @{ invoiceNumber = 'INV-206' } -Confirm:$false }
			WhatIf = { New-NinjaOneBillingInvoice -billingInvoice @{ invoiceNumber = 'INV-206' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/billing/invoices'
		}
		[pscustomobject]@{
			Name = 'billing invoice archive'
			Invoke = { Invoke-NinjaOneBillingInvoicesArchive -request @{ invoiceIds = @(206) } -Confirm:$false }
			WhatIf = { Invoke-NinjaOneBillingInvoicesArchive -request @{ invoiceIds = @(206) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/billing/invoices/archive'
		}
		[pscustomobject]@{
			Name = 'billing account update'
			Invoke = { Set-NinjaOneBillingAccount -id 207 -billingAccount @{ name = 'Updated Account' } -Confirm:$false }
			WhatIf = { Set-NinjaOneBillingAccount -id 207 -billingAccount @{ name = 'Updated Account' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/billing/accounts/207'
		}
		[pscustomobject]@{
			Name = 'billing agreement update'
			Invoke = { Set-NinjaOneBillingAgreement -id 208 -billingAgreement @{ name = 'Updated Agreement' } -Confirm:$false }
			WhatIf = { Set-NinjaOneBillingAgreement -id 208 -billingAgreement @{ name = 'Updated Agreement' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/billing/agreements/208'
		}
		[pscustomobject]@{
			Name = 'billing invoice update'
			Invoke = { Set-NinjaOneBillingInvoice -id 209 -billingInvoice @{ note = 'Updated Invoice' } -Confirm:$false }
			WhatIf = { Set-NinjaOneBillingInvoice -id 209 -billingInvoice @{ note = 'Updated Invoice' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/billing/invoices/209'
		}
		[pscustomobject]@{
			Name = 'billing product activation'
			Invoke = { Invoke-NinjaOneBillingProductActivate -id 210 -Confirm:$false }
			WhatIf = { Invoke-NinjaOneBillingProductActivate -id 210 -WhatIf }
			Command = 'New-NinjaOnePATCHRequest'
			Resource = 'v2/billing/products/210/activate'
			BodyCount = 0
		}
		[pscustomobject]@{
			Name = 'billing product deactivation'
			Invoke = { Invoke-NinjaOneBillingProductDeactivate -id 211 -Confirm:$false }
			WhatIf = { Invoke-NinjaOneBillingProductDeactivate -id 211 -WhatIf }
			Command = 'New-NinjaOnePATCHRequest'
			Resource = 'v2/billing/products/211/deactivate'
			BodyCount = 0
		}
		[pscustomobject]@{
			Name = 'billing agreement deactivation'
			Invoke = { Invoke-NinjaOneBillingAgreementDeactivate -id 214 -Confirm:$false }
			WhatIf = { Invoke-NinjaOneBillingAgreementDeactivate -id 214 -WhatIf }
			Command = 'New-NinjaOnePATCHRequest'
			Resource = 'v2/billing/agreements/214/deactivate'
			BodyCount = 0
		}
		[pscustomobject]@{
			Name = 'billing account deletion'
			Invoke = { Remove-NinjaOneBillingAccount -id 213 -Confirm:$false }
			WhatIf = { Remove-NinjaOneBillingAccount -id 213 -WhatIf }
			Command = 'New-NinjaOneDELETERequest'
			Resource = 'v2/billing/accounts/213'
		}
	)

	It 'executes <Name>' -ForEach $BillingCases {
		$result = & $PSItem.Invoke

		$result.resource | Pester\Should -Be $PSItem.Resource
		if ($PSItem.Command -eq 'New-NinjaOnePATCHRequest') {
			$result.body.Count | Pester\Should -Be $PSItem.BodyCount
		}
	}

	It 'does not execute <Name> with WhatIf' -ForEach $BillingCases {
		& $PSItem.WhatIf

		Pester\Should-Invoke -CommandName $PSItem.Command -ModuleName $ModuleName -Times 0
	}

	It 'delegates <Name> failures' -ForEach $BillingCases {
		Pester\Mock -CommandName $PSItem.Command -ModuleName $ModuleName -MockWith { throw 'billing-mutation-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*billing-mutation-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

Describe 'Organisation and device actions' {
	BeforeEach {
		Pester\Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'post'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{ method = 'put'; resource = $Resource; body = $Body }
		}
		Pester\Mock -CommandName New-NinjaOneDELETERequest -ModuleName $ModuleName -MockWith { 204 }
		Pester\Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	$ActionCases = @(
		[pscustomobject]@{
			Name = 'organisation checklist creation'
			Invoke = { New-NinjaOneOrganisationChecklist -checklist @{ name = 'Onboarding' } -Confirm:$false }
			WhatIf = { New-NinjaOneOrganisationChecklist -checklist @{ name = 'Onboarding' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/organization/checklists'
		}
		[pscustomobject]@{
			Name = 'checklists from templates creation'
			Invoke = { New-NinjaOneOrganisationChecklistsFromTemplates -organisationId 311 -request @{ templateIds = @(1, 2) } -Confirm:$false }
			WhatIf = { New-NinjaOneOrganisationChecklistsFromTemplates -organisationId 311 -request @{ templateIds = @(1, 2) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/organization/311/checklists-from-templates'
		}
		[pscustomobject]@{
			Name = 'organisation checklists update'
			Invoke = { Set-NinjaOneOrganisationChecklists -checklists @(@{ checklistId = 318; name = 'Updated' }) -Confirm:$false }
			WhatIf = { Set-NinjaOneOrganisationChecklists -checklists @(@{ checklistId = 318; name = 'Updated' }) -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/organization/checklists'
		}
		[pscustomobject]@{
			Name = 'organisation checklists promote'
			Invoke = { Invoke-NinjaOneOrganisationChecklistsPromote -request @{ checklistIds = @(319, 320) } -Confirm:$false }
			WhatIf = { Invoke-NinjaOneOrganisationChecklistsPromote -request @{ checklistIds = @(319, 320) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/organization/checklists/promote'
		}
		[pscustomobject]@{
			Name = 'organisation checklists removal'
			Invoke = { Remove-NinjaOneOrganisationChecklists -request @{ checklistIds = @(314, 315) } -Confirm:$false }
			WhatIf = { Remove-NinjaOneOrganisationChecklists -request @{ checklistIds = @(314, 315) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/organization/checklists/delete'
		}
		[pscustomobject]@{
			Name = 'tag update'
			Invoke = { Set-NinjaOneTag -tagId 316 -tag @{ name = 'Priority-1' } -Confirm:$false }
			WhatIf = { Set-NinjaOneTag -tagId 316 -tag @{ name = 'Priority-1' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/tag/316'
		}
		[pscustomobject]@{
			Name = 'tag removals'
			Invoke = { Remove-NinjaOneTags -deleteRequest @{ tagIds = @(325, 326) } -Confirm:$false }
			WhatIf = { Remove-NinjaOneTags -deleteRequest @{ tagIds = @(325, 326) } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag/delete'
		}
		[pscustomobject]@{
			Name = 'OS patch apply'
			Invoke = { Start-NinjaOneOSPatchApply -deviceId 317 -Confirm:$false }
			WhatIf = { Start-NinjaOneOSPatchApply -deviceId 317 -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/device/317/patch/os/apply'
		}
		[pscustomobject]@{
			Name = 'tag update'
			Invoke = { Set-NinjaOneTag -tagId 321 -tag @{ name = 'Priority-1' } -Confirm:$false }
			WhatIf = { Set-NinjaOneTag -tagId 321 -tag @{ name = 'Priority-1' } -WhatIf }
			Command = 'New-NinjaOnePUTRequest'
			Resource = 'v2/tag/321'
		}
		[pscustomobject]@{
			Name = 'tag merge'
			Invoke = { Merge-NinjaOneTags -mergeRequest @{ sourceTagIds = @(322, 323); targetTagId = 321 } -Confirm:$false }
			WhatIf = { Merge-NinjaOneTags -mergeRequest @{ sourceTagIds = @(322, 323); targetTagId = 321 } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag/merge'
		}
		[pscustomobject]@{
			Name = 'tag create'
			Invoke = { New-NinjaOneTag -tag @{ name = 'Priority-2'; description = 'Batch coverage' } -Confirm:$false }
			WhatIf = { New-NinjaOneTag -tag @{ name = 'Priority-2'; description = 'Batch coverage' } -WhatIf }
			Command = 'New-NinjaOnePOSTRequest'
			Resource = 'v2/tag'
		}
	)

	It 'executes <Name>' -ForEach $ActionCases {
		$result = & $PSItem.Invoke

		if ($null -ne $PSItem.Resource) {
			$result.resource | Pester\Should -Be $PSItem.Resource
		}
		else {
			$result | Pester\Should -Not -BeNullOrEmpty
		}
	}

	It 'does not execute <Name> with WhatIf' -ForEach $ActionCases {
		& $PSItem.WhatIf

		Pester\Should-Invoke -CommandName $PSItem.Command -ModuleName $ModuleName -Times 0
	}

	It 'delegates <Name> failures' -ForEach $ActionCases {
		Pester\Mock -CommandName $PSItem.Command -ModuleName $ModuleName -MockWith { throw 'action-failed' }

		{ & $PSItem.Invoke } | Pester\Should -Throw '*action-failed*'
		Pester\Should-Invoke -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

}
