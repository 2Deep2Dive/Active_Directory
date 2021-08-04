#---------------------------------#
# Run Psake to Analyze the code   #
#---------------------------------#
task Analyze {
Set-Location ..
$SAResults = Invoke-ScriptAnalyzer -Path ".\SyncADContacts" -Recurse -Verbose:$false
    if($SAResults){
        $SAResults | Format-Table
        Write-Error -Message 'one or more Script Analyzer errors/warnings were found. Build cannot continue! '
    }
}