[cmdletbinding()]
param([string[]]$Task = 'default')
$ErrorActionPreference = 'Stop'
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;
if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Force} else{update-Module -Name pester -Force};
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -MinimumVersion 4.8.0 -Force} else{update-Module -Name psake -Force}
if (!(Get-Module -Name PSDeploy -ListAvailable)) { Install-Module -Name PSDeploy -Force -Verbose}        else{update-Module -Name PSDeploy -Force}
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Force} else{Update-Module -Name PSScriptAnalyzer -Force}
Invoke-psake -buildFile ".\*\SyncADContacts.build.ps1" -taskList $Task -Verbose:$VerbosePreference
if ($psake.build_success -eq $false) {exit 1 } else { exit 0 }