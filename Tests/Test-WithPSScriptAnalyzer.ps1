[CmdletBinding()]
param (
    # Directory where PowerShell scripts to be tested are stored. Use a relative path like '../scripts'. Script Analyzer will recurse through subdirectories as well
    [Parameter( Mandatory = $true )]
    [string]$ScriptDirectory,
    # Comma separated list of specific PSScriptAnalyzer rules to exclude
    [string]$ScriptAnalyzerExcludeRules
)

function Add-PRComment {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Body
    )
    Write-Verbose 'Posting PR Comment via Azure DevOps REST API'
    # Post the comment to the pull request
    Try {
        $uri = "$($Env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)$Env:SYSTEM_TEAMPROJECTID/_apis/git/repositories/$($Env:BUILD_REPOSITORY_NAME)/pullRequests/$($Env:SYSTEM_PULLREQUEST_PULLREQUESTID)/threads?api-version=5.1"
        Write-Verbose "Constructed URL: $uri"

        $response = Invoke-RestMethod -Uri $uri -Method POST -Headers @{Authorization = "Bearer $Env:SYSTEM_ACCESSTOKEN" } -Body $Body -ContentType application/json

        if ($null -eq $response) {
            Write-Verbose 'Rest API posted OK'
        }
    } Catch {
        Write-Error $_
        Write-Error $_.Exception.Message
    }
}


$ScriptAnalyzerResult = Invoke-ScriptAnalyzer -Path $ScriptDirectory -Recurse -Settings "$($Env:SYSTEM_DEFAULTWORKINGDIRECTORY)\PSScriptAnalyzerSettings.psd1" -ExcludeRule $ScriptAnalyzerExcludeRules

if ( $ScriptAnalyzerResult ) {
    $ScriptAnalyzerResultString = $ScriptAnalyzerResult | Out-String
    Write-Warning $ScriptAnalyzerResultString
    # loop through each result and post to the azuredevops rest api
    foreach ($result in $ScriptAnalyzerResult) {
        # build the script path for the PR comment, drop the workdir from the path
        $ScriptPath = $result.ScriptPath -replace [regex]::Escape($Env:SYSTEM_DEFAULTWORKINGDIRECTORY), ''
        Write-Verbose "ScriptPath: $ScriptPath"
        Write-Verbose "Line Number: $($result.Line)"
        Write-Verbose "Message: $($result.Message)"
        # build the markdown comments
        # cannot be tabbed over to match indentation
        $markdownComment = @"
:warning: Script Analyzer found this issue with your code:

``$($result.Message)``
"@


        $body = @"
{
    "comments": [
        {
            "parentCommentId": 0,
            "content": "$markdownComment",
            "commentType": 1
        }
    ],
    "status": "active",
    "threadContext": {
        "filePath": "$ScriptPath",
        "leftFileEnd": null,
        "leftFileStart": null,
        "rightFileEnd": {
            "line": $($result.Line),
            "offset": 100
        },
        "rightFileStart": {
            "line": $($result.Line),
            "offset": 1
        }
    }
}
"@
        # post to the PR
        Add-PRComment -Body $body
    }

    throw 'PSScriptAnalyzer found issues with your code'

} else {
    Write-Output 'All Script Analyzer tests passed'

    $markdownComment = @'
:white_check_mark: Script Analyzer found no issues with your code! High Five! :hand:
'@

    Write-Verbose 'Posting PR Comment via AzureDevOps REST API'

    $body = @"
{
    "comments": [
        {
            "parentCommentId": 0,
            "content": "$markdownComment",
            "commentType": 1
        }
    ],
    "status": "closed"
}
"@
    # post to the PR
    Add-PRComment -Body $body
}