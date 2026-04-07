***

applyTo: "CHANGELOG.md,Source/NinjaOne.psd1,.github/workflows/\*\*/\*.{yml,yaml}"
description: "Use for version bumps and releases in NinjaOne: update changelog and manifest carefully and follow the repo's tag and branch policies."
-----------------------------------------------------------------------------------------------------------------------------------------------------

# Release instructions

* Update `CHANGELOG.md` and `Source/NinjaOne.psd1` together for releases.
* Use the next semantic version based on existing tags and changelog entries.
* Do not assume a stable tag can be pushed from `develop`; respect the repository's branch validation workflow.
* Keep release notes concise and focused on user-visible fixes and updates.
