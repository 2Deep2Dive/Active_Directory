
[cmdletbinding()]
param([string[]]$Task)
$ErrorActionPreference = 'Stop'

Write-Host 'Running AppVeyor Analyze script' -ForegroundColor Yellow
Write-Host "Current working directory: $pwd"

#---------------------------------#
# Run Psake to Analyze the code   #
#---------------------------------#

$SAResults = Invoke-ScriptAnalyzer -Path ".\*\SyncADContacts\" -Recurse -Verbose:$false
    if($SAResults){
        $SAResults | Format-Table
        Write-Error -Message 'one or more Script Analyzer errors/warnings were found. Build cannot continue! '
    }