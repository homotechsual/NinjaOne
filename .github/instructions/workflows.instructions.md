***

applyTo: ".github/workflows/**/\*.{yml,yaml},DevOps/**/\*.ps1"
description: "Use for CI/CD and automation changes in NinjaOne: keep workflows safe, explicit, and consistent with release and validation policies."
----------------------------------------------------------------------------------------------------------------------------------------------------

# Workflow and automation instructions

* Keep GitHub Actions changes minimal and focused.
* Prefer explicit failure handling for native commands in PowerShell workflow steps.
* Distinguish operational failures from domain-specific drift or validation failures.
* Preserve artifact upload steps and human-readable summaries when adding automation.
* Respect existing release policies:
  * stable tags from `main`
  * prerelease work from `develop`
