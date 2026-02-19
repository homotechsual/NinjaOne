<#
	.SYNOPSIS
		Based on the PowerShell Script Analyzer (PSSA) presets.
	.LINK
		https://github.com/PowerShell/PSScriptAnalyzer/blob/master/Engine/Settings/
#>
@{
	Filter = @(
		'**/*.ps1',
		'**/*.psm1',
		'!**/Tests/*.ps1'
	)
	Severity = @(
		'Error',
		'Warning',
		'Information'
	)
	IncludeRules = @(
		'PSAlignAssignmentStatement',
		'PSAvoidAssignmentToAutomaticVariable',
		'PSAvoidDefaultValueForMandatoryParameter',
		'PSAvoidDefaultValueSwitchParameter',
		'PSAvoidGlobalAliases',
		'PSAvoidGlobalFunctions',
		'PSAvoidGlobalVars',
		'PSAvoidInvokingEmptyMembers',
		'PSAvoidNullOrEmptyHelpMessageAttribute',
		'PSAvoidSemicolonsAsLineTerminators',
		'PSAvoidShouldContinueWithoutForce',
		'PSAvoidTrailingWhitespace',
		'PSAvoidUsingBrokenHashAlgorithms',
		'PSAvoidUsingCmdletAliases',
		'PSAvoidUsingComputerNameHardcoded',
		'PSAvoidUsingConvertToSecureStringWithPlainText',
		'PSAvoidUsingDeprecatedManifestFields',
		'PSAvoidUsingDoubleQuotesForConstantString',
		'PSAvoidUsingEmptyCatchBlock',
		'PSAvoidUsingInvokeExpression',
		'PSAvoidUsingPlainTextForPassword',
		'PSAvoidUsingPositionalParameters',
		'PSAvoidUsingUserNameAndPasswordParams',
		'PSAvoidUsingWMICmdlet',
		'PSAvoidUsingWriteHost',
		'PSDSC*',
		'PSMisleadingBacktick',
		'PSMissingModuleManifestField',
		'PSPlaceCloseBrace',
		'PSPlaceOpenBrace',
		'PSPossibleIncorrectComparisonWithNull',
		'PSPossibleIncorrectUsageOfAssignmentOperator',
		'PSPossibleIncorrectUsageOfRedirectionOperator'
		'PSProvideCommentHelp',
		'PSReservedCmdletChar',
		'PSReservedParams',
		'PSReviewUnusedParameter',
		'PSShouldProcess',
		'PSUseApprovedVerbs',
		'PSUseBOMForUnicodeEncodedFile',
		'PSUseCmdletCorrectly',
		'PSUseCompatibleCmdlets',
		'PSUseCompatibleCommands',
		'PSUseCompatibleSyntax',
		'PSUseCompatibleTypes',
		'PSUseConsistentIndentation',
		'PSUseConsistentWhitespace',
		'PSUseCorrectCasing',
		'PSUseDeclaredVarsMoreThanAssignments',
		'PSUseLiteralInitializerForHashtable',
		'PSUseOutputTypeCorrectly',
		'PSUseProcessBlockForPipelineCommand',
		'PSUsePSCredentialType',
		'PSUseShouldProcessForStateChangingFunctions',
		'PSUseLowerCaseForBooleanVariables',
		'PSUseLowerCaseForBuiltInFunctions',
		'PSUseLowerCaseForParameters',
		'PSUseSingularNouns',
		'PSUseTitleCaseForCmdletParameters',
		'PSUseTitleCaseForConstants',
		'PSUseTitleCaseForNonConstants',
		'PSUseTitleCaseFunctionNames',
		'PSUseTitleCaseVerbs'
	)
	Rules = @{
		PSAlignAssignmentStatement = @{
			Enable = $false
		}
		PSPlaceCloseBrace = @{
			Enable = $true
			NewLineAfter = $false
			IgnoreOneLineBlock = $true
			NoEmptyLineBefore = $false
		}
		PSPlaceOpenBrace = @{
			Enable = $true
			OnSameLine = $true
			NewLineAfter = $true
			IgnoreOneLineBlock = $true
		}
		PSReviewUnusedParameter = @{
			Enable = $true
			CommandsToTraverse = @(
				'New-NinjaOneQuery'
			)
		}
		PSUseCompatibleCmdlets = @{
			Enable = $true
			Compatibility = @(
				'desktop-5.1.14393.206-windows',
				'core-6.1.0-windows',
				'core-6.1.0-linux',
				'core-6.1.0-linux-arm'
				'core-6.1.0-macos'
			)
		}
		PSUseCompatibleCommands = @{
			Enable = $false
		}
		PSUseCompatibleSyntax = @{
			Enable = $true
			TargetVersions = @(
				'5.1',
				'6.0',
				'7.0'
			)
		}
		PSUseConsistentIndentation = @{
			Enable = $true
			Kind = 'tab'
			PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
		}
		PSUseConsistentWhitespace = @{
			Enable = $true
			CheckInnerBrace = $true
			CheckOpenBrace = $true
			CheckOpenParen = $true
			CheckOperator = $true
			CheckPipe = $true
			CheckPipeForRedundantWhitespace = $true
			CheckSeparator = $true
			CheckParameter = $true
			IgnoreAssignmentOperatorInsideHashTable = $true
		}
		PSUseCorrectCasing = @{
			Enable = $true
		}
		PSUseSingularNouns = @{
			Enable = $false
		}
		PSAvoidUsingDoubleQuotesForConstantString = @{
			Enable = $true
		}
	}
}