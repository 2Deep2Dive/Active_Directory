
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
[cmdletbinding()]
param([string[]]$Task = 'Build')
$ErrorActionPreference = 'Stop'
Write-Host 'Running AppVeyor build script' -ForegroundColor Yellow
Write-Host "ModuleName    : $env:ModuleName"
Write-Host "Build version : $env:APPVEYOR_BUILD_VERSION"
Write-Host "Author        : $env:APPVEYOR_REPO_COMMIT_AUTHOR"
Write-Host "Branch        : $env:APPVEYOR_REPO_BRANCH"
Write-Host "Repo          : $env:APPVEYOR_REPO_NAME"
Write-Host "Current working directory: $pwd"

#---------------------------------#
# BuildScript                     #
#---------------------------------#
Invoke-psake -buildFile ".\*\SyncADContacts.build.ps1" -taskList $Task -Verbose:$VerbosePreference
if ($psake.build_success -eq $false) {exit 1 } else { exit 0 }
