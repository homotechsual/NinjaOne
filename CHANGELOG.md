# Changelog

Please note that backwards compatibility breaks are prefixed with `{"BC"}` (short for Breaking Change).

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

* Fix multiple parameters which were incorrect set as mandatory

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
  