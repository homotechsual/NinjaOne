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

Export-ModuleMember -Function Measure-*