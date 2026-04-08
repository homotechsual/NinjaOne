## Highlights

This release expands the NinjaOne PowerShell module with **35 new cmdlets** covering Billing, ITAM, and end-user device access workflows.

### New Billing cmdlets

* **Accounts**: `Get-NinjaOneBillingAccounts`, `New-NinjaOneBillingAccount`, `Set-NinjaOneBillingAccount`, `Remove-NinjaOneBillingAccount`
* **Agreements**: `Get-NinjaOneBillingAgreements`, `New-NinjaOneBillingAgreement`, `Set-NinjaOneBillingAgreement`, `Invoke-NinjaOneBillingAgreementDeactivate`
* **Invoices**: `Get-NinjaOneBillingInvoices`, `New-NinjaOneBillingInvoice`, `Set-NinjaOneBillingInvoice`, `Set-NinjaOneBillingInvoiceNote`, `Invoke-NinjaOneBillingInvoicesApprove`, `Invoke-NinjaOneBillingInvoicesArchive`, `Invoke-NinjaOneBillingInvoicesExport`, `Invoke-NinjaOneBillingInvoicesUnarchive`
* **Products and ticket products**: `Get-NinjaOneBillingProducts`, `New-NinjaOneBillingProduct`, `Set-NinjaOneBillingProduct`, `Invoke-NinjaOneBillingProductActivate`, `Invoke-NinjaOneBillingProductDeactivate`, `Get-NinjaOneBillingTicketProducts`, `New-NinjaOneBillingTicketProductAdHoc`, `New-NinjaOneBillingTicketProductCatalog`, `Set-NinjaOneBillingTicketProduct`, `Set-NinjaOneBillingTicketTimeEntry`, `Invoke-NinjaOneBillingTicketProductsDelete`

### New ITAM and user cmdlets

* `Get-NinjaOneAssetRelationships`, `New-NinjaOneAssetRelationship`, `Remove-NinjaOneAssetRelationship`
* `Get-NinjaOneAssetRelationshipTypes`, `New-NinjaOneAssetRelationshipType`
* `Get-NinjaOneSoftwareLicenses`, `Get-NinjaOneSoftwareLicenseAssignments`
* `Set-NinjaOneEndUserDeviceAccess`

### Reliability improvements

* Improved query/path parameter handling for the new Billing and ITAM cmdlets.
* Added a custom PSScriptAnalyzer rule to catch self-referential parameter aliases.
* Carries forward the recent Linux/Azure Functions module-loading fix from `2.4.2`.
