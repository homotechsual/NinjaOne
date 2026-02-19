<#
	.SYNOPSIS
		Based on the PowerShell Script Analyzer (PSSA) presets.
	.LINK
		https://github.com/PowerShell/PSScriptAnalyzer/blob/master/Engine/Settings/
#>
@{
	Severity = @(
		'Error',
		'Warning',
		'Information'
	)
	IncludeRules = @(
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
		'PSAvoidUsingBrokenHashAlgorithms',
		'PSAvoidUsingCmdletAliases',
		'PSAvoidUsingComputerNameHardcoded',
		'PSAvoidUsingConvertToSecureStringWithPlainText',
		'PSAvoidUsingDeprecatedManifestFields',
		'PSAvoidUsingEmptyCatchBlock',
		'PSAvoidUsingInvokeExpression',
		'PSAvoidUsingPlainTextForPassword',
		'PSAvoidUsingPositionalParameters',
		'PSAvoidUsingUserNameAndPasswordParams',
		'PSAvoidUsingWMICmdlet',
		'PSDSC*',
		'PSMisleadingBacktick',
		'PSMissingModuleManifestField',
		'PSPossibleIncorrectComparisonWithNull',
		'PSPossibleIncorrectUsageOfAssignmentOperator',
		'PSPossibleIncorrectUsageOfRedirectionOperator',
		'PSProvideCommentHelp',
		'PSReservedCmdletChar',
		'PSReservedParams',
		'PSReviewUnusedParameter',
		'PSShouldProcess',
		'PSUseApprovedVerbs',
		'PSUseBOMForUnicodeEncodedFile',
		'PSUseCmdletCorrectly',
		'PSUseCompatibleCmdlets',
		'PSUseCompatibleSyntax',
		'PSUseDeclaredVarsMoreThanAssignments',
		'PSUseLiteralInitializerForHashtable',
		'PSUseOutputTypeCorrectly',
		'PSUseProcessBlockForPipelineCommand',
		'PSUsePSCredentialType',
		'PSUseShouldProcessForStateChangingFunctions'
	)
	Rules = @{
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
		PSUseCompatibleSyntax = @{
			Enable = $true
			TargetVersions = @(
				'5.1',
				'6.0',
				'7.0'
			)
		}
	}
}