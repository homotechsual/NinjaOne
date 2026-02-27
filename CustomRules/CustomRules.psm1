<#
.SYNOPSIS
Measure RequiredCommentBasedHelp.

.DESCRIPTION
Internal helper function for Measure-RequiredCommentBasedHelp operations.

This function provides supporting functionality for the NinjaOne module.

.PARAMETER ScriptBlockAst
    Specifies the ScriptBlockAst parameter.

.EXAMPLE
    PS> Measure-RequiredCommentBasedHelp -ScriptBlockAst "value"

    measure the specified RequiredCommentBasedHelp.

.OUTPUTS
Returns information about the RequiredCommentBasedHelp resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
function Measure-RequiredCommentBasedHelp {
	<#
		.SYNOPSIS
			Ensure functions have required comment-based help (CBH) sections.
		.DESCRIPTION
			This rule verifies that functions contain required comment-based help sections.
			Public functions should have .SYNOPSIS, .DESCRIPTION, and .EXAMPLE sections.
			Private functions should at least have .SYNOPSIS.
		.EXAMPLE
			Detects functions with missing .SYNOPSIS, .DESCRIPTION (for public), or .EXAMPLE sections.
		.INPUTS
			[System.Management.Automation.Language.ScriptBlockAst]
		.OUTPUTS
			[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
	#>
	[CmdletBinding()]
	[OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
	)

	process {
		try {
			$scriptPath = $ScriptBlockAst.Extent.File
			if ($scriptPath -and $scriptPath -like '*\CustomRules\*') {
				return
			}
			
			# Get script content for checking help blocks before function keyword
			$scriptContent = $ScriptBlockAst.Extent.Text
			
			# Find all function and class definitions
			$functions = $ScriptBlockAst.FindAll({
					param([System.Management.Automation.Language.Ast]$Ast)
					$Ast -is [System.Management.Automation.Language.FunctionDefinitionAst]
				}, $false)

			# Also find classes to exclude their constructors
			$classes = $ScriptBlockAst.FindAll({
					param([System.Management.Automation.Language.Ast]$Ast)
					$Ast -is [System.Management.Automation.Language.TypeDefinitionAst]
				}, $false)
			
			# Get list of class names
			$classNames = @()
			foreach ($classAst in $classes) {
				$classNames += $classAst.Name
			}

			foreach ($function in $functions) {
				$functionName = $function.Name
				$isPublic = $scriptPath -and $scriptPath -like '*\Public\*'
				
				# Skip internal helper functions and cmdlet helpers
				if ($functionName -match '^(Get|Invoke|WriteMessage|InvokeTask|GetModulePath|GetFunctions|AssertOutputBinariesUnlocked|Push|Publish|Clean)$') {
					continue
				}
				
				# Skip class constructors (they share the class help)
				if ($functionName -in $classNames) {
					continue
				}
				
				# Get the function body AST
				$funcBody = $function.Body
				if (-not $funcBody) {
					continue
				}
				
				# Get the raw help text - check both the function extent AND preceding content
				$functionText = $function.Extent.Text
				
				# For help that appears BEFORE the function keyword, we need to search the script content
				# Look backwards from the function line to find help block
				$functionStartLine = $function.Extent.StartLineNumber
				$scriptLines = $scriptContent -split "`n"
				
				# Get text from 50 lines before function to the function start
				$searchStart = [Math]::Max(0, $functionStartLine - 50 - 1)
				$searchEnd = $functionStartLine - 1
				$precedingText = ($scriptLines[$searchStart..$searchEnd] -join "`n")
				
				# Combine preceding text and function text for help search
				$searchText = $precedingText + "`n" + $functionText
				
				# Check if help exists - look for .SYNOPSIS in the combined text
				# Use (?s) flag to make . match newlines for multiline matching
				if (-not ($searchText -match '(?s)\<#.*?\.SYNOPSIS.*?#\>')) {
					$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
						"Function '$functionName' is missing comment-based help. Add a <# .SYNOPSIS ... #> help block.",
						$function.Extent,
						'PSRequiredCommentBasedHelp',
						[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning,
						$null,
						$null,
						$null
					)
					$result
					continue
				}
				
				# Check for required sections based on function location
				$hasSynopsis = $searchText -match '\.SYNOPSIS'
				$hasDescription = $searchText -match '\.DESCRIPTION'
				$hasExample = $searchText -match '\.EXAMPLE'
				$hasParameters = $searchText -match '\.PARAMETER'
				
				if (-not $hasSynopsis) {
					$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
						"Function '$functionName' help is missing .SYNOPSIS section.",
						$function.Extent,
						'PSRequiredCommentBasedHelp',
						[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning,
						$null,
						$null,
						$null
					)
					$result
				}
				
				if ($isPublic -and -not $hasDescription) {
					$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
						"Public function '$functionName' help is missing .DESCRIPTION section.",
						$function.Extent,
						'PSRequiredCommentBasedHelp',
						[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning,
						$null,
						$null,
						$null
					)
					$result
				}
				
				if ($isPublic -and -not $hasExample) {
					$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
						"Public function '$functionName' help is missing .EXAMPLE section.",
						$function.Extent,
						'PSRequiredCommentBasedHelp',
						[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Information,
						$null,
						$null,
						$null
					)
					$result
				}
			}
		} catch {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}

function Measure-RequireProperTypeAcceleratorCasing {
	<#
		.SYNOPSIS
			Ensures type accelerators use proper casing.
		.DESCRIPTION
			Flags any type accelerator that is not cased to match the underlying type name.
		.EXAMPLE
			Reports [pscustomobject] and suggests [PSCustomObject].
		.INPUTS
			[System.Management.Automation.Language.ScriptBlockAst]
		.OUTPUTS
			[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
		#>
	[CmdletBinding()]
	[OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
	)

	process {
		try {
			$scriptPath = $ScriptBlockAst.Extent.File
			if ($scriptPath -and $scriptPath -like '*\CustomRules\*') {
				return
			}

			$acceleratorType = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators', $false)
			if (-not $acceleratorType) {
				return
			}
			$accelerators = $null
			$method = $acceleratorType.GetMethod('Get', [System.Reflection.BindingFlags]'Public,NonPublic,Static')
			if ($method) {
				$accelerators = $method.Invoke($null, @())
			}
			if (-not $accelerators) {
				$field = $acceleratorType.GetField('typeAccelerators', [System.Reflection.BindingFlags]'NonPublic,Static')
				if ($field) {
					$accelerators = $field.GetValue($null)
				}
			}
			if (-not $accelerators) {
				return
			}
			$acceleratorMap = @{}
			foreach ($key in $accelerators.Keys) {
				$acceleratorMap[$key.ToLowerInvariant()] = $accelerators[$key].Name
			}

			$typeAsts = $ScriptBlockAst.FindAll({
					param([System.Management.Automation.Language.Ast]$Ast)
					$Ast -is [System.Management.Automation.Language.TypeExpressionAst] -or
					$Ast -is [System.Management.Automation.Language.TypeConstraintAst]
				}, $true)

			foreach ($typeAst in $typeAsts) {
				$typeName = $typeAst.TypeName
				if (-not $typeName) {
					continue
				}
				$rawName = $typeName.Name
				if (-not $rawName) {
					continue
				}

				$baseName = $rawName
				$suffix = ''
				$match = [regex]::Match($rawName, '^(?<base>[^\[]+)(?<suffix>\[.*\])$')
				if ($match.Success) {
					$baseName = $match.Groups['base'].Value
					$suffix = $match.Groups['suffix'].Value
				}

				$baseKey = $baseName.ToLowerInvariant()
				if (-not $acceleratorMap.ContainsKey($baseKey)) {
					continue
				}

				$preferredBase = $acceleratorMap[$baseKey]
				$preferredName = $preferredBase + $suffix
				if ($rawName -ceq $preferredName) {
					continue
				}

				$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
					"Type accelerator '$rawName' should be cased as '$preferredName'.",
					$typeAst.Extent,
					'PSUseProperTypeAcceleratorCasing',
					[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning,
					$null,
					$null,
					$null
				)
				$result
			}
		} catch {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}

function Measure-EmptyCommentBasedHelpSections {
	<#
		.SYNOPSIS
			Ensure functions do not have empty CBH sections.
		.DESCRIPTION
			This rule verifies that functions do not contain empty comment-based help (CBH) sections.
			Empty CBH sections (like .SYNOPSIS, .DESCRIPTION, .EXAMPLE, .OUTPUTS, .LINK, etc.) are
			usually placeholders that were never filled in or mistakenly left without content.
		.EXAMPLE
			Detects functions with empty CBH sections containing only whitespace.
		.INPUTS
			[System.Management.Automation.Language.ScriptBlockAst]
		.OUTPUTS
			[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
	#>
	[CmdletBinding()]
	[OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
	param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
	)

	process {
		try {
			# Only check functions
			$functions = $ScriptBlockAst.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
			
			foreach ($function in $functions) {
				$help = $function.GetHelpContent()
				
				if ($null -eq $help -or $help.Count -eq 0) {
					continue
				}

				# Parse the comment-based help to find empty sections
				$helpText = $help -join "`n"
				
				# Pattern: any CBH keyword followed by only whitespace, then another keyword or #>
				# Matches: .SYNOPSIS, .DESCRIPTION, .PARAMETER, .EXAMPLE, .OUTPUTS, .LINK, .FUNCTIONALITY, .NOTES, .INPUTS, .COMPONENT
				$emptyPattern = '\.(?:SYNOPSIS|DESCRIPTION|PARAMETER|EXAMPLE|OUTPUTS|LINK|FUNCTIONALITY|NOTES|INPUTS|COMPONENT)\s*\n\s*(?=\.(?:SYNOPSIS|DESCRIPTION|PARAMETER|EXAMPLE|OUTPUTS|LINK|FUNCTIONALITY|NOTES|INPUTS|COMPONENT)|\s*#>)'
				
				if ($helpText -match $emptyPattern) {
					# Find which section is empty
					$sectionMatches = [regex]::Matches($helpText, $emptyPattern)
					foreach ($sectionMatch in $sectionMatches) {
						# Extract the keyword name
						$keywordMatch = [regex]::Match($sectionMatch.Value, '\.(\w+)')
						$keyword = $keywordMatch.Groups[1].Value
						
						$result = [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]::new(
							"Function '$($function.Name)' contains an empty .$keyword section. Either add content or remove the empty keyword.",
							$function.Extent,
							'PSCommentBasedHelpEmptySection',
							[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticSeverity]::Warning,
							$null,
							$null,
							$null
						)
						$result
					}
				}
			}
		} catch {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}

Export-ModuleMember -Function Measure-*