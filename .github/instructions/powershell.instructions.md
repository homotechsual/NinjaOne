---
applyTo: "Source/**/*.ps1,Tests/**/*.ps1,DevOps/**/*.ps1"
description: "Use for PowerShell files in the NinjaOne repo: preserve formatting, help, metadata, and cross-platform compatibility patterns."
---

PowerShell file instructions
============================

* Match the existing repository style and indentation.
* Add or preserve comment-based help where required.
* For public cmdlets, keep parameter naming and `MetadataAttribute` usage consistent with nearby commands.
* Prefer fixes that work on both Windows PowerShell and PowerShell 7 on Linux.
* Avoid brittle path assertions or OS-specific assumptions in tests.
* When adjusting tests, validate real behavior rather than mock-only artifacts.
