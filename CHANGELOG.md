# Changelog

Please note that backwards compatibility breaks are prefixed with `{"BC"}` (short for Breaking Change).

## 2024-09-03 - Version 2.0.2

* Fix incorrect parameter type for `-organisationDocument` and `-organisationDocuments` parameters on the `New-NinjaOneOrganisationDocument` and `New-NinjaOneOrganisationDocuments` commandlets.

## 2024-08-16 - Version 2.0.1

* Remove debugging statements forcing `Write-Information` output to always display.

## 2024-08-09 - Version 2.0.0

* No changes from 2.0.0-RC6

## 2024-07-28 - Version 2.0.0-RC6

* Fix double declaration of `Get-NinjaOneOrganisationInformation` (once as an alias and once as a new wrapper commandlet!)
* Fix incorrect output type on `New-NinjaOneCustomFieldsObject`.
* Fix incorrect output type on `New-NinjaOneDocumentTemplateObject`.
* Fix incorrect parameter alias on `policyId` param for Windows Event and Custom Field commandlets.
* Fix incorrect parameter alias on `deviceId` param for Integrity Check Job commandlet.

## 2024-07-28 - Version 2.0.0-RC5

* Add new commandlets:
  * `Get-NinjaOneAutomations`
  * `Get-NinjaOneNotificationChannels`
  * `Get-NinjaOneCustomFieldsPolicyConditions`
  * `Get-NinjaOneCustomFieldsPolicyCondition`
  * `Get-NinjaOneWindowsEventConditions`
  * `Get-NinjaOneWindowsEventCondition`
  * `Get-NinjaOneTicketingUsers`
  * `Get-NinjaOneKnowledgeBaseArticle`
  * `Get-NinjaOneOrganisationKnowledgeBaseArticles`
  * `Get-NinjaOneGlobalKnowledgeBaseArticles`
  * `Get-NinjaOneKnowledgeBaseFolders`
  * `Get-NinjaOneRelatedItemAttachment`
  * `Get-NinjaOneRelatedItemAttachmentSignedURLs`
  * `Get-NinjaOneCustomFieldSignedURLs`
  * `Get-NinjaOneIntegrityCheckJobs`
  * `New-NinjaOneCustomFieldsPolicyCondition`
  * `New-NinjaOneWindowsEventPolicyCondition`
  * `New-NinjaOneAttachmentRelation`
  * `New-NinjaOneEntityRelation`
  * `New-NinjaOneEntityRelations`
  * `New-NinjaOneSecureRelation`
  * `New-NinjaOneIntegrityCheckJob`
  * `Remove-NinjaOneRelatedItem`
  * `Remove-NinjaOneRelatedItems`
  * `Remove-NinjaOneOrganisationDocument`
  * `Remove-NinjaOnePolicyCondition`
* Remove deprecated commandlet:
  * `Get-NinjaOneAttachment`
* Fix bug in `Set-NinjaOneOrganisationDocument`.
* Fix auth endpoints in `Connect-NinjaOne` to use the `ws/oauth` paths.
* Apply a round of fixes to `Get-NinjaOneSecrets`.
* Remove early exits for endpoints which don't support `client_credentials` authentication as NinjaOne has added a native descriptive error for this issue.
* Add `of` / `organisationFilter` parameter to the `Get-NinjaOneOrganisations` commandlet.
* Fix handling of `scopes` parameter on `Get-NinjaOneDeviceCustomFields`.
* Reformat all code to use tabs instead of spaces - largely driven by accessibility benefits of using tabs over spaces. I was, for many years, a "spaces > tabs" guy. Until I was pointed at [this article by Alexander Sandberg](https://alexandersandberg.com/articles/default-to-tabs-instead-of-spaces-for-an-accessible-first-environment/). It managed to convince me that the accessibility benefits of tabs outweighed my attachment to spaces. Our workspace file uses whatever tab width you have set in VSCode you can change this using `editor.tabSize` in your settings.
* Add many new aliases to try and stay as close to Ninja's "entity" naming as we can. For example, `Get-NinjaOneRoles` now has the alias `Get-NinjaOneDeviceRoles`.
* Add many new wrapper commands to provide commandlets named consistently with Ninja's entity naming where we've combined endpoints into a single commandlet for expediency.
* Remove entity exists validation from all commandlets, we will no longer test if a device exists before you try to get it's disks. This reduces the volume of calls we make and you will now see Ninja's 404 response being returned when the given device does not exist. This has been done to drastically reduce the number of API calls we were making.
* Reorganise source folder to match Ninja's API groupings.
* Remove the `-usageLimit` parameter from `New-NinjaOneInstaller`.

## 2024-02-18 - Version 2.0.0-RC4

* Change secret vault to use the SecretManagement module.

## 2024-02-16 - Version 2.0.0-RC3

* Fix broken ticket commandlet.
* Remove Client Credentials block on Ticketing GET endpoints (thanks Ninja team and Luke Whitelock!)
* Fix device search commandlet.
* Test suite improvements.
* Fix broken class preventing correct commandlet functionality.
* Start implementing native secret vault support. Present but not entirely functional

## 2024-01-17 - Version 2.0.0-RC2

* Move classes to C# code and compile to DLLs for better portability and reliability.

## 2024-01-16 - Version 2.0.0-RC1

* Add new commandlets:
  * `Get-NinjaOneBackupJobs.ps1`
  * `Get-NinjaOneDeviceNetworkInterfaces.ps1`
  * `Get-NinjaOneDocumentTemplates`
  * `Get-NinjaOneNetworkInterfaces`
  * `New-NinjaOneDocumentTemplate`
  * `New-NinjaOneOrganisationDocument`
  * `Remove-NinjaOneDocumentTemplate`
  * `Set-NinjaOneDocumentTemplate`
  * `Set-NinjaOneOrganisationDocuments`
* Fix token refresh for `authorization_code` flows. Make sure you request the `offline_access` scope.
* New automated tests
* New automated documentation building
* New build system - we now compile to a single PSM1 file and PSD1 file for better handling of our bundled classes.

## 2023-12-12 - Version 2.0.0-beta8

* Add short aliases to all commandlets.
* Rewrite `Set-NinjaOneNodeRolePolicyAssignment` as `Set-NinjaOneOrganisationPolicies` and allow multiple role/policy assignments at a time.
* Refactor all commandlets to use the "advanced function" template for iterative pipeline support.

## 2023-11-17 - Version 2.0.0-beta7

* Fix the `-userType` parameter on `Get-NinjaOneUsers`.

## 2023-11-17 - Version 2.0.0-beta6

* Fix broken document existence check in `Set-NinjaOneOrganisationDocument`.

## 2023-11-17 - Version 2.0.0-beta5

* Add new `-Scripts` and `-Categories` parameters to `Get-NinjaOneDeviceScriptingOptions` to allow automatic expansion of the results.
* Rewrite `Invoke-NinjaOneDeviceScript` with better error handling and dependency checking.
* Introduce new automated tests for comment-based-help elements.

## 2023-11-17 - Version 2.0.0-beta4

* Fix help links, commandlet names and short names (for documentation).

## 2023-11-16 - Version 2.0.0-beta2

* Fix functions not being re-added to exports after name changes.

## 2023-11-15 - Version 2.0.0-beta1

* {"BC"} Refactoring of error handling to allow PowerShell 5.1 compatibility.
* {"BC"} Removal / change of the `id` alias on some parameters.
* {"BC"} Each commandlet now supports pipelining of the "primary" id value. Commandlets which require more than one `id` parameter do not support pipelining except by property name.
* {"BC"} Rename most `Update-*` commandlets to `Set-*`. Aliases are in place.
* {"BC"} Removal of all `*-NinjaRMM*` aliases to their `*-NinjaOne*` commandlets.
* {"BC"} All `Write-Debug` statements are now `Write-Verbose`.
* Add `-expandActivities` parameter to `Get-NinjaOneActivities`.
* Add `-expandOverrides` parameter to `Get-NinjaOneDevicePolicyOverrides`.
* Implement the framework for adding classes to build objects for `POST` endpoints.
* All commandlets which require an entity to exist will throw an error if the entity with the given id doesn't exist.
* The base `Get-*` commands for the core entities now throw if no results are returned.
* Refactor exception catches in Private utility commandlets.
* Reword error and verbose messaging throughout.
* Switch all string/variable interpolation to use the `-f` format string operator with single-quoted strings.
* Add `us2` instance.

## 2023-10-25 - Version 1.12.3

* Fix broken template policy id parameter handling in `New-NinjaOneOrganisation`.

## 2023-10-25 - Version 1.12.2

* Add missing aliases for various other `*organisation*` parameters.

## 2023-10-25 - Version 1.12.1

* Add alias for `Update-NinjaOneOrganization`.

## 2023-10-25 - Version 1.12.0

* Fix broken start/end parameters on `Set-NinjaOneDeviceMaintenance`.

## 2023-10-10 - Version 1.11.2

* Fix regression in the set device custom fields cmdlet.

## 2023-10-09 - Version 1.11.1

* Add organizationId as an alias to all organisationId parameters.

## 2023-09-27 - Version 1.10.1

* Fixes pipeline support for some cmdlets which were missing it or had it incorrectly implemented.

## 2023-09-25 - Version 1.10.0

* Add new endpoints from NinjaOne's 5.4 release.
* Update existing endpoints which changed in 5.4.

## 2023-05-11 - Version 1.9.1

* Refactored internals to separate out the parameters for `Invoke-NinjaOneRequest`.
* Refactored request type helper functions to splat rather than pass in a hashtable to `Invoke-NinjaOneRequest`.
* Improve examples for all commandlets.

## 2023-05-11 - Version 1.9.0

* Fix all date/time parameters - previous change in 1.7.1 was not functional.
* Add `Get-NinjaOneLocationBackupUsage` commandlet. Gets the backup usage for a location.
* Add `Get-NinjaOneBackupUsage` commandlet. Gets the backup usage broken down by device.
* Add `Get-NinjaOnePolicyOverrides` commandlet. Gets the policy overrides broken down by device.
* Add `New-NinjaOneInstaller` commandlet. Creates an advanced installer for a device with the ability to limit the number of uses for the installer.
* Fix `Get-NinjaOneTickets` commandlet. Now uses the correct HTTP method for single ticket retrieval.
* Add `Get-NinjaOneTicketAttributes` commandlet. Gets the attributes for tickets.
* Fix `Get-NinjaOneTicketForms` commandlet. Now allows single ticket form retrieval.

## 2023-05-05 - Version 1.8.0

* Commandlets whose endpoints do not support Client Credentials authentication now return an early error if the authentication mode in use is `client_credentials`.
* Fixed incorrect parameter type and function name for `Get-NinjaOneAttachment` commandlet.
* Fix incorrect variable expansion in `Get-NinjaOneAttachment` commandlet.
* Fix incorrect parameter types for `Invoke-NinjaOneWindowsServiceAction` commandlet.
* Fix incorrect resource path for `New-NinjaOneLocation` commandlet.
* Fix incorrect variable expansion in `New-NinjaOneLocation` commandlet.
* Add single ticket retrieval to `Get-NinjaOneTicket` commandlet.

## 2023-05-04 - Version 1.7.2

* Simplify DateTime to Unix conversion.

## 2023-05-04 - Version 1.7.1

* Complete rework of DateTime parameter handling to auto convert values to Unix Timestamps and add companion parameters for accepting Unix-y values.

## 2023-05-04 - Version 1.7.0

* Fix New-NinjaOnePolicy and Reset-NinjaOneDevicePolicyOverrides exports.
* Fix New-NinjaOnePolicy parameter type for `-mode` to be `[string]` instead of `[int]`.
* Expose Invoke-NinjaOneRequest as public cmdlet.

## 2023-04-07 - Version 1.6.11

* Fix an extra closing `)` in `Update-NinjaOneLocation` command.

## 2023-04-06 - Version 1.6.10

* Fix bug in connection logic that hard coded scopes for all `client_credentials` connections.

## 2023-04-03 - Version 1.6.9

* Fix multiple commandlets using incorrectly pluralised "Get-" commandlets.

## 2023-03-31 - Version 1.6.8

* Fix multiple bugs with `Update-NinjaOneNodeRolePolicyAssignment` command.

## 2023-03-08 - Version 1.6.7

* Fix an incorrect parameter type in `Update-NinjaOneDevice` command.

## 2023-01-17 - Version 1.6.7-Beta1

* Add `Update-NinjaOneOrganisationDocument`.

## 2022-12-15 - Version 1.6.6

* Fix an issue affecting multiple `Get-*` commands where the `Results` property was not being expanded correctly.

## 2022-11-10 - Version 1.6.5

* Fix incorrect body variable naming.

## 2022-11-10 - Version 1.6.4

* Fix an incorrect parameter type in `Update-NinjaOneOrganisation` command.

## 2022-11-10 - Version 1.6.3

* Fix a bug in `Update-NinjaOneOrganisation` command.

## 2022-11-01 - Version 1.6.2

* Add `Get-NinjaOneDevicePolicyOverrides` command.

## 2022-10-28 - Version 1.6.1

* Fix return value for `Get-NinjaOneJobs` command.
* Fix parameter not being removed from `Get-NinjaOneTicketLogEntries` command.

## 2022-10-28 - Version 1.6.0

* Fix multiple parameters which were incorrectly set as mandatory

## 2022-10-26 - Version 1.5.0

* Various bugfixes.

## 2022-10-26 - Version 1.4.0

* Add CA instance.
* Adjust project scaffold - PowerShell Script Analyzer rules, VSCode setup.

## 2022-08-30 - Version 1.3.0

* Replace OAuthListener with pure .NET classes and PowerShell implementation. Faster, easier and more maintainable.

## 2022-08-30 - Version 1.3.0-Beta1

* Testing .NET 6 fixes for OAuthListener

## 2022-05-28 - Version 1.2.3

* Fix 200 status code being returned instead of $null result for empty GET request responses. Thanks to Dru and Gavsto!

## 2022-05-26 - Version 1.2.2

* Fix another bug in results property handling. Thanks to TheBoWatts!

## 2022-05-25 - Version 1.2.1

* Fix a bug in results property expansion. Thanks to DopeLemon!

## 2022-05-04 - Version 1.2.0

* Add Policy commands.

## 2022-03-23 - Version 1.1.0

* Fixes for interactive authentication.

## 2022-03-15 - Version 1.0.0

* Add remaining Ticketing commands.
* Add more `Restart`, `Set` and `Update` commands.
* Refactor request handling.

## 2022-01-21 - Version 0.9.0

* Rename multiple commands to be more consistent with the API.
* Add Ticketing commands.
* Add `Reset-NinjaOneAlert` command.
* Add `New-NinjaOneOrganization` command.

## 2021-12-22 - Version 0.1.0-Beta1

* Fixes a bug with getting devices for an organisation.
* Overhauls error handling.
* Adds pipeline support.

## 2021-08-19 - Version 0.0.1-alpha

* Initial preview release of the NinjaRMM API PowerShell module.
  