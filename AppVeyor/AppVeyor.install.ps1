
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#---------------------------------#
# Header                          #
#---------------------------------#
Write-Host 'Running AppVeyor install script' -ForegroundColor Yellow

#---------------------------------#
# Enable TLS 1.2                  #
#---------------------------------#
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

#---------------------------------#
# Install NuGet                   #
#---------------------------------#
Write-Host 'Installing NuGet PackageProvider'
$pkg = Install-PackageProvider -Name NuGet -Force -ErrorAction Stop
Write-Host "Installed NuGet version '$($pkg.version)'"

#---------------------------------#
# Install Modules                 #
#---------------------------------#
#To used incase a min or max version is required
#[version]$ScriptAnalyzerVersion = '1.19.1'
#[version]$PesterVersion = '5.2.2'
Write-Host 'Installing PSScriptAnalyzer' -ForegroundColor Yellow
Install-Module -Name 'PSScriptAnalyzer' -Force -ErrorAction Stop
Write-Host 'Installing Pester' -ForegroundColor Yellow
Install-Module -Name 'Pester'  -Force -ErrorAction Stop
Write-Host 'Installing Psake' -ForegroundColor Yellow
Install-Module -Name 'Psake'  -Force -ErrorAction Stop
Write-Host 'Installing PSDeploy' -ForegroundColor Yellow
Install-Module -Name 'PSDeploy'  -Force -ErrorAction Stop

#---------------------------------#
# Update PSModulePath             #
#---------------------------------#
Write-Host 'Updating PSModulePath for testing'
$env:PSModulePath = $env:PSModulePath + ";" + "C:\projects"

#---------------------------------#
# Validate                        #
#---------------------------------#
$RequiredModules  = 'PSScriptAnalyzer','Pester','psake','PSDeploy'
$InstalledModules = Get-Module -Name $RequiredModules -ListAvailable
if ( ($InstalledModules.count -lt $RequiredModules.Count) -or ($Null -eq $InstalledModules)) {
  throw "Required modules are missing."
} else {
  Write-Host 'All modules required found' -ForegroundColor Green
}
