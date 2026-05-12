# Copilot instructions for NinjaOne

This repository is a PowerShell module for the NinjaOne API with supporting C# helper assemblies and GitHub Actions workflows.

## General expectations

* Prefer small, targeted changes over wide refactors.
* Preserve the repository's PowerShell formatting conventions:
  * tabs for indentation
  * OTBS/K\&R brace style
  * comment-based help for public functions
* Keep public cmdlet names, aliases, and metadata consistent with existing patterns.
* Avoid editing generated output under `Output/` unless explicitly asked.

## Testing and verification

* Verify changes with the existing repo tasks when appropriate:
  * `Build NinjaOne (build only)`
  * `Test NinjaOne`
  * `Run PSScriptAnalyzer`
* For coverage reporting, always use repository scripts/tasks as the source of truth:
  * `Show Coverage Summary` (`DevOps/Quality/show-coverage.ps1`)
  * `Show Coverage Detail` (`DevOps/Quality/show-coverage.ps1 -Detail Full`)
  * `DevOps/Quality/test.ps1` for suite coverage gate enforcement
* For approval-friendly terminal runs in VS Code, prefer a stable workspace task first:
  * `Run Public Suite Tail`
  * If a terminal command is needed, use `pwsh -File .\DevOps\Quality\run-public-suite-tail.ps1 -Last 45`
  * Avoid ad-hoc inline pipelines like `... | Select-Object -Last N` when command approval consistency matters.
* For endpoint drift / endpoint coverage reporting, use `DevOps/Quality/check-instance-capabilities.ps1` or the `Check Instance Capabilities` task.
* Do not use ad-hoc coverage parsing as the reported source of truth.
* Treat CI/workflow changes carefully and keep them minimal.
* Prefer assertions that are robust across Windows and Linux path differences.

## Release and workflow guidance

* Stable release tags like `vX.Y.Z` must respect the repository workflow and be reachable from `main`.
* PRs and release changes should respect existing GitHub Actions in `.github/workflows/`.
* For endpoint drift work, focus on:
  * live endpoints without matching cmdlet coverage
  * removals from live endpoints compared against repo spec and cmdlet metadata

## PowerShell module conventions

* Public functions belong under `Source/Public/` and should include comment-based help.
* Internal helpers belong under `Source/Private/`.
* Endpoint mappings are expressed via `MetadataAttribute` on exported cmdlets.
* Cross-platform compatibility matters, especially for PowerShell on Linux and Azure Functions.
