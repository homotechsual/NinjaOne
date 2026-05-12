#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0' }

$ModuleName = 'NinjaOne'
$RepoRoot = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\')).Path
$ModulePath = $env:NINJAONE_MODULE_MANIFEST
if ([string]::IsNullOrWhiteSpace($ModulePath)) {
	$ModulePath = Get-ChildItem -Path ('{0}\Output\{1}\*\{1}.psd1' -f $RepoRoot, $ModuleName) -ErrorAction Stop | Select-Object -Last 1 -ExpandProperty FullName
}

Describe 'Set-NinjaOneOrganisation' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id} with the supplied body' {
		Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'Acme' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/7'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'Acme' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'org-patch-failed' }
		{ Set-NinjaOneOrganisation -organisationId 7 -organisationInformation @{ name = 'X' } -Confirm:$false } | Should -Throw '*org-patch-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneLocation' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id}/locations/{locationId} with the supplied body' {
		Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'HQ' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/3/locations/9'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'HQ' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'location-patch-failed' }
		{ Set-NinjaOneLocation -organisationId 3 -locationId 9 -locationInformation @{ name = 'X' } -Confirm:$false } | Should -Throw '*location-patch-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDevice' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/device/{id} with the supplied body' {
		Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'WebServer01' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/42'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'WebServer01' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'device-patch-failed' }
		{ Set-NinjaOneDevice -deviceId 42 -deviceInformation @{ displayName = 'X' } -Confirm:$false } | Should -Throw '*device-patch-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneOrganisationCustomFields' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/organization/{id}/custom-fields with the supplied body' {
		Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ field1 = 'val1' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/5/custom-fields'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ f = 'v' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'orgcf-patch-failed' }
		{ Set-NinjaOneOrganisationCustomFields -organisationId 5 -organisationCustomFields @{ f = 'v' } -Confirm:$false } | Should -Throw '*orgcf-patch-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceCustomFields' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PATCH /v2/device/{id}/custom-fields with the supplied body' {
		Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ field1 = 'val1' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/11/custom-fields'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ f = 'v' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'devcf-patch-failed' }
		{ Set-NinjaOneDeviceCustomFields -deviceId 11 -deviceCustomFields @{ f = 'v' } -Confirm:$false } | Should -Throw '*devcf-patch-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneTicket' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { return [PSCustomObject]@{ id = 99; subject = 'Test ticket' } }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST /v2/ticketing/ticket with the ticket body' {
		New-NinjaOneTicket -ticket @{ subject = 'Test' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket'
		}
	}

	It 'returns the created ticket when -show is specified' {
		$result = New-NinjaOneTicket -ticket @{ subject = 'Test' } -show -Confirm:$false
		$result.id | Should -Be 99
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'ticket-post-failed' }
		{ New-NinjaOneTicket -ticket @{ subject = 'Test' } -Confirm:$false } | Should -Throw '*ticket-post-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneTicket' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT /v2/ticketing/ticket/{ticketId} with the ticket body' {
		Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'Updated' } -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/50'
		}
	}

	It 'writes an information message on 204' {
		{ Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'Updated' } -Confirm:$false } | Should -Not -Throw
	}

	It 'delegates PUT failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'ticket-put-failed' }
		{ Set-NinjaOneTicket -ticketId 50 -ticket @{ subject = 'X' } -Confirm:$false } | Should -Throw '*ticket-put-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceApproval' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST /v2/devices/approval/APPROVE with the device id list' {
		Set-NinjaOneDeviceApproval -mode 'APPROVE' -deviceIds @(1, 2) -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices/approval/APPROVE'
		}
	}

	It 'calls POST /v2/devices/approval/REJECT for reject mode' {
		Set-NinjaOneDeviceApproval -mode 'REJECT' -deviceIds @(3) -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices/approval/REJECT'
		}
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'approval-post-failed' }
		{ Set-NinjaOneDeviceApproval -mode 'APPROVE' -deviceIds @(1) -Confirm:$false } | Should -Throw '*approval-post-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneOrganisationPolicies' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { return 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT /v2/organization/{id}/policies for Single parameter set' {
		Set-NinjaOneOrganisationPolicies -organisationId 4 -nodeRoleId 10 -policyId 20 -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/4/policies'
		}
	}

	It 'calls PUT /v2/organization/{id}/policies for Multiple parameter set' {
		$assignments = @(@{ nodeRoleId = 10; policyId = 20 }, @{ nodeRoleId = 11; policyId = 21 })
		Set-NinjaOneOrganisationPolicies -organisationId 4 -policyAssignments $assignments -Confirm:$false
		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/4/policies'
		}
	}

	It 'delegates PUT failures to New-NinjaOneError for Single parameter set' {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'policies-put-failed' }
		{ Set-NinjaOneOrganisationPolicies -organisationId 4 -nodeRoleId 10 -policyId 20 -Confirm:$false } | Should -Throw '*policies-put-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceDisks' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'Disk0' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device disks endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceDisks -deviceId 88

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/88/disks'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-disks-failed' }

		{ Get-NinjaOneDeviceDisks -deviceId 88 } | Should -Throw '*device-disks-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceNetworkInterfaces' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'Ethernet0' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device network interfaces endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceNetworkInterfaces -deviceId 55

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/55/network-interfaces'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-nics-failed' }

		{ Get-NinjaOneDeviceNetworkInterfaces -deviceId 55 } | Should -Throw '*device-nics-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceVolumes' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ name = 'C:' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device volumes endpoint for the supplied id' {
		$null = Get-NinjaOneDeviceVolumes -deviceId 101

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/101/volumes'
		}
	}

	It 'passes include as a query parameter' {
		$null = Get-NinjaOneDeviceVolumes -deviceId 101 -include 'bl'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('include')
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'device-volumes-failed' }

		{ Get-NinjaOneDeviceVolumes -deviceId 101 } | Should -Throw '*device-volumes-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketAttributes' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Priority' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticket attributes endpoint' {
		$null = Get-NinjaOneTicketAttributes

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/attributes'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketAttributes } | Should -Throw '*No ticket attributes found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketBoards' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 10; name = 'Default Board' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticket boards endpoint' {
		$null = Get-NinjaOneTicketBoards

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/trigger/boards'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketBoards } | Should -Throw '*No boards found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneBackupJobs' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'COMPLETED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the backup jobs endpoint' {
		$null = Get-NinjaOneBackupJobs

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'preprocesses single status into a statusFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -status 'RUNNING'

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}


	It 'preprocesses startTimeAfter into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -startTimeAfter (Get-Date '2024-01-01')

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'preprocesses startTimeBetween into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneBackupJobs -startTimeBetween @((Get-Date '2024-01-01'), (Get-Date '2024-01-02'))

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/jobs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'backup-jobs-failed' }

		{ Get-NinjaOneBackupJobs } | Should -Throw '*backup-jobs-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneIntegrityCheckJobs' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'COMPLETED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the integrity check jobs endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses single status into a statusFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -status 'RUNNING'

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses startTimeAfter into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -startTimeAfter (Get-Date '2024-01-01')

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'preprocesses startTimeBetween into a startTimeFilter and calls the endpoint' {
		$null = Get-NinjaOneIntegrityCheckJobs -startTimeBetween @((Get-Date '2024-01-01'), (Get-Date '2024-01-02'))

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq '/v2/backup/integrity-check-jobs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'integrity-jobs-failed' }

		{ Get-NinjaOneIntegrityCheckJobs } | Should -Throw '*integrity-jobs-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTickets' {
	BeforeEach {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 1; subject = 'Test ticket' }
		}
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ data = @([pscustomobject]@{ id = 1; subject = 'Test ticket' }); metadata = [pscustomobject]@{ total = 1 } }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses GET to the single ticket endpoint for the Single parameter set' {
		$null = Get-NinjaOneTickets -ticketId 7

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/ticket/7'
		}
	}

	It 'uses POST to the board run endpoint for the Board parameter set' {
		$null = Get-NinjaOneTickets -boardId 'board-1'

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/trigger/board/board-1/run'
		}
	}

	It 'builds board request body fields and parseDateTime when board options are supplied' {
		$null = Get-NinjaOneTickets -boardId 'board-1' -pageSize 25 -searchCriteria 'router' -includeColumns @('subject') -lastCursorId 'cursor-1' -parseDateTime

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
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

		$result | Should -Not -BeNullOrEmpty
		# result should be the .data array, not the full response object
		$result[0].id | Should -Be 1
	}

	It 'returns the full response from Board when includeMetadata is set' {
		$result = Get-NinjaOneTickets -boardId 'board-1' -includeMetadata

		$result.data | Should -Not -BeNullOrEmpty
		$result.metadata | Should -Not -BeNullOrEmpty
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTickets -ticketId 7 } | Should -Throw '*No tickets found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneRelatedItems' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; type = 'DOCUMENT' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls v2/related-items for the all parameter set' {
		$null = Get-NinjaOneRelatedItems -all

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items'
		}
	}

	It 'calls the entity-type route when relatedTo is used with entityType only' {
		$null = Get-NinjaOneRelatedItems -relatedTo -entityType 'ORGANIZATION'

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-entity-type/ORGANIZATION'
		}
	}

	It 'calls the entity route when relatedTo is used with entityType and entityId' {
		$null = Get-NinjaOneRelatedItems -relatedTo -entityType 'ORGANIZATION' -entityId 5

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-entity/ORGANIZATION/5'
		}
	}

	It 'calls the related-entity-type route when relatedFrom is used with entityType only' {
		$null = Get-NinjaOneRelatedItems -relatedFrom -entityType 'ORGANIZATION'

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-related-entity-type/ORGANIZATION'
		}
	}

	It 'calls the related-entity route when relatedFrom is used with entityType and entityId' {
		$null = Get-NinjaOneRelatedItems -relatedFrom -entityType 'ORGANIZATION' -entityId 5

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/related-items/with-related-entity/ORGANIZATION/5'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneRelatedItems -all } | Should -Throw '*No related items found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOrganisationDocuments' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Doc 1' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the single-organisation documents endpoint when organisationId is supplied' {
		$null = Get-NinjaOneOrganisationDocuments -organisationId 12

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/12/documents'
		}
	}

	It 'calls the all-organisations documents endpoint when no organisationId is supplied' {
		$null = Get-NinjaOneOrganisationDocuments

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/documents'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOrganisationDocuments -organisationId 12 } | Should -Throw '*No documents found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTicketingUsers' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Alice Tech' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the ticketing users endpoint' {
		$null = Get-NinjaOneTicketingUsers

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/ticketing/app-user-contact'
		}
	}

	It 'passes userType as a query parameter' {
		$null = Get-NinjaOneTicketingUsers -userType 'TECHNICIAN'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('userType')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTicketingUsers } | Should -Throw '*No ticketing users found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceOSPatchInstalls' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ patchId = 42; status = 'INSTALLED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device OS patch installs endpoint for the supplied device id' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'converts installedAfter DateTime to epoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 -installedAfter (Get-Date '2024-01-01')

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'accepts installedAfterUnixEpoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 -installedAfterUnixEpoch 1704067200

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/77/os-patch-installs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'os-patch-installs-failed' }

		{ Get-NinjaOneDeviceOSPatchInstalls -deviceId 77 } | Should -Throw '*os-patch-installs-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceSoftwarePatchInstalls' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ patchId = 99; status = 'INSTALLED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the device software patch installs endpoint for the supplied device id' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'converts installedAfter DateTime to epoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 -installedAfter (Get-Date '2024-01-01')

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'accepts installedBeforeUnixEpoch and calls the endpoint' {
		$null = Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 -installedBeforeUnixEpoch 1704153600

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/33/software-patch-installs'
		}
	}

	It 'delegates GET failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'sw-patch-installs-failed' }

		{ Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 33 } | Should -Throw '*sw-patch-installs-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneDocumentTemplate' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 500; name = 'Template A' }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
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

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
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

		$result.id | Should -Be 500
		$result.name | Should -Be 'Template A'
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'doc-template-create-failed' }
		$field = [pscustomobject]@{
			fieldName = 'Hostname'
			fieldType = 'TEXT'
		}
		$field.PSObject.TypeNames.Insert(0, 'DocumentTemplateField')
		$fields = @($field)

		{ New-NinjaOneDocumentTemplate -Name 'Template A' -fields $fields -Confirm:$false } | Should -Throw '*doc-template-create-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDocumentTemplate' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
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

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
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
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 5; name = 'Template B' }
		}
		$fields = @(
			@{
				fieldName = 'Hostname'
				fieldType = 'TEXT'
			}
		)

		$result = Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -show -Confirm:$false

		$result.id | Should -Be 5
	}

	It 'throws validation error when DROPDOWN field has no fieldContent' {
		$fields = @(
			@{
				fieldName = 'Choice'
				fieldType = 'DROPDOWN'
			}
		)

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Should -Throw '*Field content must be specified*'
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

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Should -Throw '*Field content values must be specified*'
	}

	It 'delegates request failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'doc-template-update-failed' }
		$fields = @(
			@{
				fieldName = 'Hostname'
				fieldType = 'TEXT'
			}
		)

		{ Set-NinjaOneDocumentTemplate -documentTemplateId 5 -Name 'Template B' -fields $fields -Confirm:$false } | Should -Throw '*doc-template-update-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwarePatchInstalls' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'INSTALLED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the software patch installs query endpoint' {
		$null = Get-NinjaOneSoftwarePatchInstalls

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software-patch-installs'
		}
	}

	It 'promotes installedBeforeUnixEpoch to installedBefore in query parameters' {
		$null = Get-NinjaOneSoftwarePatchInstalls -installedBeforeUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedBefore') -and -not $Parameters.ContainsKey('installedBeforeUnixEpoch')
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneSoftwarePatchInstalls -timeStampUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwarePatchInstalls } | Should -Throw '*No software patch installs found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOSPatchInstalls' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'INSTALLED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the OS patch installs query endpoint' {
		$null = Get-NinjaOneOSPatchInstalls

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/os-patch-installs'
		}
	}

	It 'promotes installedAfterUnixEpoch to installedAfter in query parameters' {
		$null = Get-NinjaOneOSPatchInstalls -installedAfterUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedAfter') -and -not $Parameters.ContainsKey('installedAfterUnixEpoch')
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneOSPatchInstalls -timeStampUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneOSPatchInstalls } | Should -Throw '*No OS patch installs found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneCustomField' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ fieldName = 'department'; updated = $true }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT v2/custom-fields/field-name/{fieldName} with the supplied body' {
		$body = @{ description = 'Department of the user' }

		$null = Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false

		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/custom-fields/field-name/department' -and
			$Body.description -eq 'Department of the user'
		}
	}

	It 'returns the PUT response' {
		$body = @{ description = 'Department of the user' }

		$result = Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false

		$result.updated | Should -Be $true
	}

	It 'does not call PUT when -WhatIf is used' {
		$body = @{ description = 'Department of the user' }

		$null = Set-NinjaOneCustomField -fieldName 'department' -customField $body -WhatIf

		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates request failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'custom-field-update-failed' }
		$body = @{ description = 'Department of the user' }

		{ Set-NinjaOneCustomField -fieldName 'department' -customField $body -Confirm:$false } | Should -Throw '*custom-field-update-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Invoke-NinjaOneDeviceScript' {
	BeforeEach {
		Mock -CommandName Get-NinjaOneDevice -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 44; SystemName = 'WS-44' }
		}
		Mock -CommandName Get-NinjaOneDeviceScriptingOptions -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 12; uid = [guid]'11111111-1111-1111-1111-111111111111'; type = 'SCRIPT'; Name = 'Collect Logs' },
				[pscustomobject]@{ id = 99; uid = [guid]'22222222-2222-2222-2222-222222222222'; type = 'ACTION'; Name = 'Restart Service' }
			)
		}
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'posts script run requests to v2/device/{id}/script/run with script id' {
		$null = Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' -parameters 'mode=quick'

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
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

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/44/script/run' -and
			$Body.type -eq 'ACTION' -and
			$Body.uid -eq $actionUId -and
			$Body.runAs -eq 'loggedonuser' -and
			-not $Body.ContainsKey('id')
		}
	}

	It 'returns 204 when -show is supplied' {
		$result = Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' -show

		$result | Should -Be 204
	}

	It 'delegates not-found script failures to New-NinjaOneError' {
		Mock -CommandName Get-NinjaOneDeviceScriptingOptions -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; type = 'SCRIPT'; Name = 'Different script' })
		}

		{ Invoke-NinjaOneDeviceScript -deviceId 44 -type 'SCRIPT' -scriptId 12 -runAs 'system' } | Should -Throw '*Script with id 12 not found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneInstaller' {
	BeforeEach {
		Mock -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 7; name = 'Contoso' })
		}
		Mock -CommandName Get-NinjaOneLocations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 17; name = 'HQ' })
		}
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ url = 'https://example.test/installer' }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'creates an installer from individual parameters and returns the URL' {
		$result = New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false

		$result | Should -Be 'https://example.test/installer'
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
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

		$result | Should -Be 'https://example.test/installer'
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/generate-installer'
		}
	}

	It 'delegates validation failures to New-NinjaOneError when organisation/location do not exist' {
		Mock -CommandName Get-NinjaOneLocations -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 99; name = 'Other' })
		}

		{ New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false } | Should -Throw '*does not exist*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'installer-create-failed' }

		{ New-NinjaOneInstaller -organisationId 7 -locationId 17 -installerType 'WINDOWS_MSI' -Confirm:$false } | Should -Throw '*installer-create-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwarePatches' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; status = 'APPROVED' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls the software patches query endpoint' {
		$null = Get-NinjaOneSoftwarePatches

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software-patches'
		}
	}

	It 'promotes timeStampUnixEpoch to timeStamp in query parameters' {
		$null = Get-NinjaOneSoftwarePatches -timeStampUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('timeStamp') -and -not $Parameters.ContainsKey('timeStampUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwarePatches } | Should -Throw '*No software patches found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneCustomField' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ fieldName = 'department'; type = 'TEXT' }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/custom-fields with the supplied body' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$null = New-NinjaOneCustomField -customField $body -Confirm:$false

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/custom-fields' -and
			$Body.fieldName -eq 'department' -and
			$Body.type -eq 'TEXT'
		}
	}

	It 'returns the created custom field' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$result = New-NinjaOneCustomField -customField $body -Confirm:$false

		$result.fieldName | Should -Be 'department'
	}

	It 'does not call POST when -WhatIf is supplied' {
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		$null = New-NinjaOneCustomField -customField $body -WhatIf

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 0
	}

	It 'delegates request failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'custom-field-create-failed' }
		$body = @{ fieldName = 'department'; type = 'TEXT' }

		{ New-NinjaOneCustomField -customField $body -Confirm:$false } | Should -Throw '*custom-field-create-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneDeviceMaintenance' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { 204 }
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls PUT v2/device/{id}/maintenance with DateTime values converted to Unix epoch' {
		$start = [datetime]'2024-01-01T00:00:00Z'
		$end = [datetime]'2024-01-01T01:00:00Z'

		$null = Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -start $start -end $end -Confirm:$false

		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/maintenance' -and
			$Body.disabledFeatures[0] -eq 'ALERTS' -and
			$Body.start -is [int] -and
			$Body.end -is [int]
		}
	}

	It 'calls PUT with unixStart and unixEnd values' {
		$null = Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('PATCHING') -unixStart 1704067200 -unixEnd 1704070800 -Confirm:$false

		Assert-MockCalled -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/81/maintenance' -and
			$Body.start -eq 1704067200 -and
			$Body.end -eq 1704070800
		}
	}

	It 'throws when no end or unixEnd is specified' {
		{ Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -start ([datetime]'2024-01-01T00:00:00Z') -Confirm:$false } | Should -Throw '*An end date/time must be specified*'
	}

	It 'delegates PUT failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePUTRequest -ModuleName $ModuleName -MockWith { throw 'maintenance-update-failed' }

		{ Set-NinjaOneDeviceMaintenance -deviceId 81 -disabledFeatures @('ALERTS') -unixStart 1704067200 -unixEnd 1704070800 -Confirm:$false } | Should -Throw '*maintenance-update-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneOrganisation' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 501; name = 'Contoso Ltd' }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'calls POST v2/organizations with organisation body and optional template query' {
		$body = @{ name = 'Contoso Ltd'; description = 'Test org' }

		$null = New-NinjaOneOrganisation -templateOrganisationId '12' -organisation $body -Confirm:$false

		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations' -and
			$Body.name -eq 'Contoso Ltd'
		}
		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('templateOrganisationId') -and -not $Parameters.ContainsKey('organisation')
		}
	}

	It 'returns created organisation when -show is supplied' {
		$body = @{ name = 'Contoso Ltd' }

		$result = New-NinjaOneOrganisation -organisation $body -show -Confirm:$false

		$result.id | Should -Be 501
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'organisation-create-failed' }
		$body = @{ name = 'Contoso Ltd' }

		{ New-NinjaOneOrganisation -organisation $body -Confirm:$false } | Should -Throw '*organisation-create-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneCustomFields' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; field = 'department' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses v2/queries/custom-fields for default parameter set' {
		$null = Get-NinjaOneCustomFields

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/custom-fields'
		}
	}

	It 'uses v2/queries/custom-fields-detailed when -detailed is supplied in default set' {
		$null = Get-NinjaOneCustomFields -detailed

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/custom-fields-detailed'
		}
		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('detailed')
		}
	}

	It 'uses v2/queries/scoped-custom-fields for scoped parameter set' {
		$null = Get-NinjaOneCustomFields -scopes @('NODE')

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/scoped-custom-fields'
		}
	}

	It 'uses v2/queries/scoped-custom-fields-detailed when scoped and detailed are supplied' {
		$null = Get-NinjaOneCustomFields -scopes @('NODE') -detailed

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/scoped-custom-fields-detailed'
		}
	}

	It 'promotes updatedAfterUnixEpoch to updatedAfter in query parameters' {
		$null = Get-NinjaOneCustomFields -updatedAfterUnixEpoch 1619712000000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('updatedAfter') -and -not $Parameters.ContainsKey('updatedAfterUnixEpoch')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneCustomFields } | Should -Throw '*No custom fields found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneInstanceCapabilities' {
	BeforeEach {
		Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith {
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

		$result.BaseUrl | Should -Be 'https://fed.ninjarmm.com'
		$result.AppVersion | Should -Be '1.2.3'
		$result.PathCount | Should -Be 2
		Assert-MockCalled -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$baseUrl -eq 'https://fed.ninjarmm.com' -and -not $Force
		}
	}

	It 'passes refresh switch through as Force to internal loader' {
		$null = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -refresh

		Assert-MockCalled -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$baseUrl -eq 'https://fed.ninjarmm.com' -and $Force
		}
	}

	It 'includes paths when includePaths is supplied' {
		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includePaths

		$result.Paths.Keys.Count | Should -Be 2
	}

	It 'classifies cmdlets as unknown when metadata is absent with includeCmdlets' {
		Mock -CommandName Get-Module -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{
				ExportedFunctions = @{
					'Get-FakeOne' = $null
					'Set-FakeTwo' = $null
				}
			}
		}
		Mock -CommandName Get-Command -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ Name = 'Get-FakeOne'; ScriptBlock = [scriptblock]::Create('param()') },
				[pscustomobject]@{ Name = 'Set-FakeTwo'; ScriptBlock = [scriptblock]::Create('param()') }
			)
		}

		$result = Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' -includeCmdlets

		$result.UnknownCmdletCount | Should -Be 2
		$result.SupportedCmdletCount | Should -Be 0
		$result.UnsupportedCmdletCount | Should -Be 0
	}

	It 'throws when internal loader returns null capabilities' {
		Mock -CommandName Get-NinjaOneInstanceCapabilitiesInternal -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneInstanceCapabilities -baseUrl 'https://fed.ninjarmm.com' } | Should -Throw '*Unable to retrieve OpenAPI spec*'
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
		Get-Command -Name Get-NinjaOneCustomFields -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusStatus should exist' {
		Get-Command -Name Get-NinjaOneAntivirusStatus -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneAntivirusThreats should exist' {
		Get-Command -Name Get-NinjaOneAntivirusThreats -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}

	It 'Get-NinjaOneDeviceBackupUsage should exist' {
		Get-Command -Name Get-NinjaOneDeviceBackupUsage -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
	}
}

Describe 'Public Query Functions - Contract Matrix' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{
					id = 1
				}
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
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

		@($result).Count | Should -Be 1
		$result[0].id | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq $PSItem.ExpectedResource
		}
	}

	It 'builds expected query keys for <Name>' -ForEach $ContractCases {
		$null = & $PSItem.InvokeQuery

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$HasExpected = $Parameters.ContainsKey($PSItem.ExpectedQueryKey)
			if ([string]::IsNullOrWhiteSpace($PSItem.ExpectedRemovedQueryKey)) {
				return $HasExpected
			}

			return $HasExpected -and (-not $Parameters.ContainsKey($PSItem.ExpectedRemovedQueryKey))
		}
	}

	It 'delegates no-result errors for <Name>' -ForEach $ContractCases {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		{ & $PSItem.InvokeSuccess } | Should -Throw ('*{0}*' -f $PSItem.ExpectedError)
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates upstream API exceptions for <Name>' -ForEach $ContractCases {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw [System.InvalidOperationException]::new('upstream-api-failure')
		}

		{ & $PSItem.InvokeSuccess } | Should -Throw '*upstream-api-failure*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneTicketComment' {
	It 'wraps a simple comment object in a multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
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

			$script:CapturedTicketCommentRequest | Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.public | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.comment.body | Should -Be 'Test Comment via API'
			$result.Body.comment.body | Should -Be 'Test Comment via API'
		}
	}

	It 'preserves an explicit multipart envelope' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
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

			$script:CapturedTicketCommentRequest | Should -Not -BeNullOrEmpty
			$script:CapturedTicketCommentRequest.Resource | Should -Be 'v2/ticketing/ticket/1003/comment'
			$script:CapturedTicketCommentRequest.UseMultipart | Should -Be $true
			$script:CapturedTicketCommentRequest.Body | Should -BeOfType ([System.Collections.IDictionary])
			$script:CapturedTicketCommentRequest.Body.Contains('comment') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.Contains('files') | Should -Be $true
			$script:CapturedTicketCommentRequest.Body.files[0] | Should -Be 'C:\Temp\example.txt'
			$result.Body.files[0] | Should -Be 'C:\Temp\example.txt'
		}
	}
}

Describe 'Get-NinjaOneActivities' {
	It 'does not emit boolean output when using -deviceId with -type' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
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

			$result.Count | Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Should -Be 0
			$result[0].lastActivityId | Should -Be 42
			$result[0].activities[0].type | Should -Be 'Action'
		}
	}

	It 'does not emit boolean output when using -activityType' {
		$module = Get-Module -Name 'NinjaOne' | Select-Object -First 1
		& $module {
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

			$result.Count | Should -Be 1
			($result | Where-Object { $_ -is [bool] }).Count | Should -Be 0
			$result[0].lastActivityId | Should -Be 7
			$result[0].activities[0].id | Should -Be 7
		}
	}
}

Describe 'Get-NinjaOneUsers' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			@{}
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{
					id = 1
					name = 'Test User'
				}
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the default users endpoint when organisationId is not supplied' {
		$module = Get-Module -Name $ModuleName
		$result = & $module {
			Get-NinjaOneUsers -includeRoles
		}

		@($result).Count | Should -Be 1
		$result[0].id | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/users' }
	}

	It 'uses the organisation users endpoint when organisationId is supplied' {
		$module = Get-Module -Name $ModuleName
		$result = & $module {
			Get-NinjaOneUsers -organisationId 7 -userType END_USER
		}

		@($result).Count | Should -Be 1
		$result[0].name | Should -Be 'Test User'
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter { $Resource -eq 'v2/organization/7/end-users' }
	}

	It 'delegates no-result default-path failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		& $module {
			{ Get-NinjaOneUsers } | Should -Throw '*No users found*'
		}

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result organisation-path failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			$null
		}

		$module = Get-Module -Name $ModuleName
		& $module {
			{ Get-NinjaOneUsers -organisationId 12 -userType END_USER } | Should -Throw '*No users found for organisation 12*'
		}

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
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
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ uid = 'alert-1'; message = 'CPU high' }
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global alerts endpoint when deviceId is not supplied' {
		$result = Get-NinjaOneAlerts

		@($result).Count | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/alerts'
		}
	}

	It 'uses the device alerts endpoint when deviceId is supplied' {
		$result = Get-NinjaOneAlerts -deviceId 42

		@($result).Count | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/42/alerts'
		}
	}

	It 'passes sourceType as a query string parameter' {
		Get-NinjaOneAlerts -sourceType 'CONDITION_CUSTOM_FIELD'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('sourceType')
		}
	}

	It 'passes parseDateTime through to the GET request' {
		Get-NinjaOneAlerts -parseDateTime

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'delegates no-result global failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'Not found' }

		{ Get-NinjaOneAlerts } | Should -Throw '*No alerts found*'

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result device failures to New-NinjaOneError with device id' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { throw 'Not found' }

		{ Get-NinjaOneAlerts -deviceId 7 } | Should -Throw '*No alerts found for device 7*'

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneJobs' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 1001; type = 'SOFTWARE_PATCH_MANAGEMENT'; status = 'COMPLETED' }
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global jobs endpoint when deviceId is not supplied' {
		$result = Get-NinjaOneJobs

		@($result).Count | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/jobs'
		}
	}

	It 'uses the device jobs endpoint when deviceId is supplied' {
		$result = Get-NinjaOneJobs -deviceId 5

		@($result).Count | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/5/jobs'
		}
	}

	It 'passes jobType as a query string parameter' {
		Get-NinjaOneJobs -jobType 'SOFTWARE_PATCH_MANAGEMENT'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('jobType')
		}
	}

	It 'passes parseDateTime through to the GET request' {
		Get-NinjaOneJobs -parseDateTime

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'delegates no-result global failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneJobs } | Should -Throw '*No jobs found*'

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}

	It 'delegates no-result device failures to New-NinjaOneError with device id' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneJobs -deviceId 5 } | Should -Throw '*No jobs found for device 5*'

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSoftwareInventory' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@(
				[pscustomobject]@{ id = 1; name = 'Microsoft Teams'; version = '1.6.0' }
			)
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'always uses the software query endpoint' {
		$result = Get-NinjaOneSoftwareInventory

		@($result).Count | Should -Be 1
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/queries/software'
		}
	}

	It 'passes deviceFilter as a query string parameter' {
		Get-NinjaOneSoftwareInventory -deviceFilter 'org = 1'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('deviceFilter')
		}
	}

	It 'converts installedBefore DateTime to Unix epoch before querying' {
		$dt = [datetime]'2024-05-01T00:00:00Z'
		Get-NinjaOneSoftwareInventory -installedBefore $dt

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedBefore')
		}
	}

	It 'converts installedAfter DateTime to Unix epoch before querying' {
		$dt = [datetime]'2024-01-01T00:00:00Z'
		Get-NinjaOneSoftwareInventory -installedAfter $dt

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('installedAfter')
		}
	}

	It 'removes installedBeforeUnixEpoch from parameters and promotes to installedBefore' {
		Get-NinjaOneSoftwareInventory -installedBeforeUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			(-not $Parameters.ContainsKey('installedBeforeUnixEpoch')) -and $Parameters.ContainsKey('installedBefore')
		}
	}

	It 'removes installedAfterUnixEpoch from parameters and promotes to installedAfter' {
		Get-NinjaOneSoftwareInventory -installedAfterUnixEpoch 1619712000

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			(-not $Parameters.ContainsKey('installedAfterUnixEpoch')) -and $Parameters.ContainsKey('installedAfter')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwareInventory } | Should -Throw '*No software inventory found*'

		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneOrganisations' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Contoso' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the organisations endpoint by default' {
		$null = Get-NinjaOneOrganisations

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations'
		}
	}

	It 'uses the detailed organisations endpoint when -detailed is supplied' {
		$null = Get-NinjaOneOrganisations -detailed

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organizations-detailed'
		}
		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			-not $Parameters.ContainsKey('detailed')
		}
	}

	It 'uses the single-organisation endpoint when organisationId is supplied' {
		$null = Get-NinjaOneOrganisations -organisationId 21

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/21'
		}
	}

	It 'normalizes upstream request failures to a no-organisations error via New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'request-failed'
		}

		{ Get-NinjaOneOrganisations } | Should -Throw '*No organisations found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneLocations' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 101; name = 'London' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global locations endpoint when organisationId is not supplied' {
		$null = Get-NinjaOneLocations

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/locations'
		}
	}

	It 'uses the organisation locations endpoint when organisationId is supplied' {
		$null = Get-NinjaOneLocations -organisationId 12

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/12/locations'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneLocations -organisationId 12 } | Should -Throw '*No locations found for organisation 12*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDevices' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 7; systemName = 'WS-07' })
		}
		Mock -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 22 }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the devices endpoint by default' {
		$null = Get-NinjaOneDevices

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices'
		}
	}

	It 'uses the detailed devices endpoint when -detailed is supplied' {
		$null = Get-NinjaOneDevices -detailed

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/devices-detailed'
		}
	}

	It 'uses the single device endpoint when deviceId is supplied' {
		$null = Get-NinjaOneDevices -deviceId 7

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/7'
		}
	}

	It 'uses the organisation devices endpoint when organisationId is supplied and organisation exists' {
		$null = Get-NinjaOneDevices -organisationId 22

		Assert-MockCalled -CommandName Get-NinjaOneOrganisations -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$organisationId -eq 22
		}
		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/organization/22/devices'
		}
	}

	It 'passes parseDateTime through to the GET request' {
		$null = Get-NinjaOneDevices -parseDateTime

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$ParseDateTime -eq $true
		}
	}

	It 'normalizes upstream request failures to a not-found device error via New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'request-failed'
		}

		{ Get-NinjaOneDevices -deviceId 7 } | Should -Throw '*Device with id 7 not found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneGroups' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Servers' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the groups endpoint' {
		$null = Get-NinjaOneGroups

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/groups'
		}
	}

	It 'passes languageTag as a query parameter' {
		$null = Get-NinjaOneGroups -languageTag 'en-GB'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('languageTag')
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneGroups } | Should -Throw '*No groups found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOnePolicies' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Workstation Policy' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the policies endpoint' {
		$null = Get-NinjaOnePolicies

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/policies'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOnePolicies } | Should -Throw '*No policies found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneRoles' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Server' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the roles endpoint' {
		$null = Get-NinjaOneRoles

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/roles'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneRoles } | Should -Throw '*No roles found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneTasks' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Daily Health Check' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the tasks endpoint' {
		$null = Get-NinjaOneTasks

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/tasks'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneTasks } | Should -Throw '*No tasks found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneNotificationChannels' {
	BeforeEach {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Email' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the notification channels endpoint by default' {
		$null = Get-NinjaOneNotificationChannels

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/notification-channels'
		}
	}

	It 'uses the enabled notification channels endpoint when -enabled is supplied' {
		$null = Get-NinjaOneNotificationChannels -enabled

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/notification-channels/enabled'
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'notification-request-failed'
		}

		{ Get-NinjaOneNotificationChannels } | Should -Throw '*No notification channels found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneAutomations' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Reboot Device' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the automation scripts endpoint' {
		$null = Get-NinjaOneAutomations

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/automation/scripts'
		}
	}

	It 'passes languageTag as a query parameter' {
		$null = Get-NinjaOneAutomations -languageTag 'en'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('languageTag')
		}
	}

	It 'delegates upstream request failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			throw 'automation-request-failed'
		}

		{ Get-NinjaOneAutomations } | Should -Throw '*No automation scripts found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneContact' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			[pscustomobject]@{ id = 42; name = 'Sam Contact' }
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the contact endpoint with the provided id' {
		$null = Get-NinjaOneContact -id 42

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contact/42'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneContact -id 42 } | Should -Throw '*Contact with id 42 not found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneDeviceCustomFields' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ scope = 'node'; fieldName = 'assetTag' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global custom fields endpoint by default' {
		$null = Get-NinjaOneDeviceCustomFields

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device-custom-fields'
		}
	}

	It 'uses the device custom fields endpoint when deviceId is supplied' {
		$null = Get-NinjaOneDeviceCustomFields -deviceId 99

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/99/custom-fields'
		}
	}

	It 'passes scope as a query parameter' {
		$null = Get-NinjaOneDeviceCustomFields -scope 'node'

		Assert-MockCalled -CommandName New-NinjaOneQuery -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Parameters.ContainsKey('scope')
		}
	}
}

Describe 'Get-NinjaOneSoftwareProducts' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 1; name = 'Microsoft Edge' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the global software products endpoint when deviceId is not supplied' {
		$null = Get-NinjaOneSoftwareProducts

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/software-products'
		}
	}

	It 'uses the device software endpoint when deviceId is supplied' {
		$null = Get-NinjaOneSoftwareProducts -deviceId 7

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/device/7/software'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError with device id' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSoftwareProducts -deviceId 7 } | Should -Throw '*No software products found for device 7*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Get-NinjaOneSystemContacts' {
	BeforeEach {
		Mock -CommandName New-NinjaOneQuery -ModuleName $ModuleName -MockWith {
			[System.Web.HttpUtility]::ParseQueryString([String]::Empty)
		}
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith {
			@([pscustomobject]@{ id = 9; name = 'Operations Team' })
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'uses the contacts endpoint' {
		$null = Get-NinjaOneSystemContacts

		Assert-MockCalled -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contacts'
		}
	}

	It 'delegates no-result failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOneGETRequest -ModuleName $ModuleName -MockWith { $null }

		{ Get-NinjaOneSystemContacts } | Should -Throw '*No system contacts found*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'New-NinjaOneContact' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'posts contact payload to the contacts endpoint when confirmed' {
		$payload = @{ firstName = 'Jane'; lastName = 'Doe'; email = 'jane@example.com' }
		$result = New-NinjaOneContact -contact $payload -Confirm:$false

		$result.resource | Should -Be 'v2/contacts'
		$result.body.firstName | Should -Be 'Jane'
		Assert-MockCalled -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contacts'
		}
	}

	It 'delegates POST failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePOSTRequest -ModuleName $ModuleName -MockWith { throw 'create-contact-failed' }

		{ New-NinjaOneContact -contact @{ firstName = 'Jane' } -Confirm:$false } | Should -Throw '*create-contact-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}

Describe 'Set-NinjaOneContact' {
	BeforeEach {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith {
			param($Resource, $Body)
			[pscustomobject]@{
				resource = $Resource
				body = $Body
			}
		}
		Mock -CommandName New-NinjaOneError -ModuleName $ModuleName -MockWith {
			param($ErrorRecord)
			throw $ErrorRecord.Exception
		}
	}

	It 'patches contact payload to the specific contact endpoint when confirmed' {
		$payload = @{ phone = '+3100000000' }
		$result = Set-NinjaOneContact -id 123 -contact $payload -Confirm:$false

		$result.resource | Should -Be 'v2/contact/123'
		$result.body.phone | Should -Be '+3100000000'
		Assert-MockCalled -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -Times 1 -ParameterFilter {
			$Resource -eq 'v2/contact/123'
		}
	}

	It 'delegates PATCH failures to New-NinjaOneError' {
		Mock -CommandName New-NinjaOnePATCHRequest -ModuleName $ModuleName -MockWith { throw 'update-contact-failed' }

		{ Set-NinjaOneContact -id 123 -contact @{ phone = '+3100000000' } -Confirm:$false } | Should -Throw '*update-contact-failed*'
		Assert-MockCalled -CommandName New-NinjaOneError -ModuleName $ModuleName -Times 1
	}
}
