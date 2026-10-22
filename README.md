# NinjaOne - A [PowerShell](https://microsoft.com/powershell) module for [NinjaOne](https://NinjaOne.com/) software

[![Homotechsual Discord](https://img.shields.io/discord/1075421628424523816?style=for-the-badge&logo=discord&logoColor=white&label=Homotechsual%20Discord)](https://discord.gg/NrCjh5ht7K)
[![NinjaOne Discord](https://img.shields.io/discord/676451788395642880?style=for-the-badge&logo=discord&logoColor=white&label=NinjaOne%20Discord)](https://discord.gg/NinjaOne)
[![GitHub contributors](https://img.shields.io/github/contributors/homotechsual/ninjaone?style=for-the-badge&logo=github)](https://github.com/homotechsual/ninjaone/)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/homotechsual/NinjaOne/build-and-publish.yml?style=for-the-badge&label=Build%20and%20Publish)](https://github.com/homotechsual/NinjaOne/actions/workflows/build-and-publish.yml)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/homotechsual/NinjaOne/ci.yml?branch=develop&style=for-the-badge&label=CI)](https://github.com/homotechsual/NinjaOne/actions/workflows/ci.yml)
[![Codecov (with branch)](https://img.shields.io/codecov/c/github/homotechsual/NinjaOne/develop?style=for-the-badge)](https://codecov.io/gh/homotechsual/NinjaOne)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/NinjaOne?style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaOne/)
[![License](https://img.shields.io/github/license/homotechsual/NinjaOne?style=for-the-badge)](https://mit.license.homotechsual.dev/)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/homotechsual?style=for-the-badge)](https://github.com/sponsors/homotechsual/)
[![Stable Release](https://img.shields.io/powershellgallery/v/NinjaOne?label=Stable+Release&style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaOne/)
[![Preview Release](https://img.shields.io/powershellgallery/v/NinjaOne?label=Preview+Release&include_prereleases&style=for-the-badge)](https://www.powershellgallery.com/packages/NinjaOne/)

## Where's the content?

Use the [docs website](https://docs.homotechsual.dev/modules/ninjaone) for the most up-to-date information and a full automatically generated commandlet reference.

## Pagination

GET commands automatically combine pages for supported pagination endpoints, including
global locations, devices, organisations, queries, activities, and anchored ticketing lists.
Supplying `-pageSize` controls the size of each request; it does not limit the total results
or disable pagination. Page sizes above 1000 are capped at 1000 with a warning, including
ticket board requests. Smaller sizes are preserved and omitted sizes use the API default.
Ticket board requests retain their existing single-response behavior with `-lastCursorId`;
they are not automatically paginated.

For example, `Get-NinjaOneLocations -pageSize 2000` requests pages of up to 1000 locations
and continues until all locations have been retrieved.

## Additional endpoint coverage

- `Get-NinjaOneDeviceGeolocationHistory` retrieves a page of mobile device geolocation history.
  `-after` and `-before` accept epoch seconds (including fractions); the window is limited
  to seven days. Use `-pageSize` (10-500) and `-cursor` for pagination.
- `Get-NinjaOneKnowledgeBaseArticle -articleId 1 -details` retrieves the article object.
  Without `-details`, the existing download behavior is unchanged; `-signedUrls` remains available.
- `Get-NinjaOneGlobalKnowledgeBaseArticle -articleId 1` retrieves a global article object.
- `Get-NinjaOneGlobalCustomFields` and `Set-NinjaOneGlobalCustomFields -globalCustomFields @{ region = 'Europe' }`
  retrieve and update global custom field **values**, not field definitions.
  Updates support `-WhatIf` and `-Confirm`.

Instance capability discovery warns and returns a null `AppVersion` when the version endpoint
returns HTML, another invalid response, or cannot be reached. Endpoint discovery still proceeds
using the OpenAPI specification; invalid version content is not cached or included in reports.

## Tooling locations

Common dev and build tooling lives under DevOps:

- Build: DevOps/Build/build.ps1, DevOps/Build/bootstrap.ps1
- Quality: DevOps/Quality/run-pssa.ps1, DevOps/Quality/test.ps1
- Help generation: DevOps/Help/Orchestrate-HelpGeneration.ps1
