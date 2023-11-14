
function Get-NinjaOneTasks {
    <#
        .SYNOPSIS
            Gets tasks from the NinjaOne API.
        .DESCRIPTION
            Retrieves tasks from the NinjaOne v2 API.
        .FUNCTIONALITY
            Scheduled Tasks
        .EXAMPLE
            PS> Get-NinjaOneTasks
            
            Gets all tasks.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving all tasks.'
        $Resource = 'v2/tasks'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $TaskResults = New-NinjaOneGETRequest @RequestParams
        Return $TaskResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}