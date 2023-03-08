# Changelog

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
  