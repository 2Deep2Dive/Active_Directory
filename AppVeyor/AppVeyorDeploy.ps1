﻿# Copyright (c) 2017 Chocolatey Software, Inc.
# Copyright (c) 2013 - 2017 Lawrence Gripper & original authors/contributors from https://github.com/chocolatey/cChoco
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
Write-Host 'Running AppVeyor deploy script' -ForegroundColor Yellow

#---------------------------------#
# Update module manifest          #
#---------------------------------#
Write-Host 'Creating new module manifest'

$ModuleManifestPath = Join-Path -path "$pwd\Release\" -ChildPath ("$env:ModuleName"+"\"+"$env:ModuleName"+'.psd1')
Write-Host "The path to the module manifest is $ModuleManifestpath" -ForegroundColor Yellow
$ModuleManifest     = Get-Content $ModuleManifestPath -Raw

Write-Host "Updating module manifest to version: $env:APPVEYOR_BUILD_VERSION"
[regex]::replace($ModuleManifest,'(ModuleVersion = )(.*)',"`$1'$env:APPVEYOR_BUILD_VERSION'") | Out-File -LiteralPath $ModuleManifestPath

#---------------------------------#
# Publish to PS Gallery           #
#---------------------------------#

if ( ($env:APPVEYOR_REPO_NAME -notmatch 'Active_Directory') -or (!$env:APPVEYOR_REPO_TAG_NAME) )
{
    Write-Host "Finished testing of branch: $env:APPVEYOR_REPO_BRANCH - Exiting"
    exit;
}

Write-Host "Publishing module to Nuget Gallery: "
Publish-Module -Path  -NuGetApiKey $env:nugetKey -Verbose

Write-Host 'Done!' -ForegroundColor Green
