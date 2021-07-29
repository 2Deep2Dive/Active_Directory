[cmdletbinding()]
param([string[]]$Task = 'default')
$ErrorActionPreference = 'Stop'
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Force -Verbose}
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Force -Verbose}
if (!(Get-Module -Name PSDeploy -ListAvailable)) { Install-Module -Name PSDeploy -Force -Verbose}
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Force -Verbose }
Invoke-psake -buildFile ".\*\ModuleName.build.ps1" -taskList $Task -Verbose:$VerbosePreference
if ($psake.build_success -eq $false) {exit 1 } else { exit 0 }