#
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
param([string[]]$Task = 'Publish')
$ErrorActionPreference = 'Stop'
Write-Warning 'Running AppVeyor deploy script'
#---------------------------------#
# Update module manifest          #
#---------------------------------#
Write-Warning 'Creating new module manifest'
$ModuleManifestPath = Join-Path -path ("$pwd"+"\"+"$env:ModuleName"+"\Release\") -ChildPath ("$env:ModuleName"+"\"+"$env:ModuleName"+'.psd1')
Write-Warning "The path to the module manifest is $ModuleManifestpath"
$ModuleManifest     = Get-Content $ModuleManifestPath -Raw
Write-Information "Updating module manifest to version: $env:APPVEYOR_BUILD_VERSION"
[regex]::replace($ModuleManifest,'(ModuleVersion = )(.*)',"`$1'$env:APPVEYOR_BUILD_VERSION'") | Out-File -LiteralPath $ModuleManifestPath

#---------------------------------#
# Publish to PS Gallery           #
#---------------------------------#
Write-Information $env:APPVEYOR_REPO_NAME
if ($env:APPVEYOR_REPO_NAME -notlike '2Deep2Dive/Active_Directory')
{
    Write-Output "Finished testing of branch: $env:APPVEYOR_REPO_BRANCH - Exiting"
    exit;
}


try {
    Write-Output  "Publishing module: "
    Publish-Module -Path $env:NugetServer  -NuGetApiKey $env:NugetToken -Verbose;
    Publish-Module -Path $env:GitHubServer -NuGetApiKey $env:GitBubToken -Verbose;
}
catch {
    Write-Error "Publishing module failed!!"
}
Finally{
    Write-Host 'Done!' -ForegroundColor Green
}



