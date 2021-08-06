
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
Properties {
    # The name of your module should match the basename of the PSD1 file.
    $ModuleName = (Get-item -path $PSScriptRoot\*.psd1 | Foreach-Object {$null = Test-ModuleManifest -Path $_ ; if ($?) {$_}})[0].BaseName
    # Path to the release notes file.  Set to $null if the release notes reside in the manifest file.
    $ReleaseNotesPath = $null

    # The directory used to publish the module from.  If you are using Git, the
    # $PublishRootDir should be ignored if it is under the workspace directory.
    $PublishRootDir = "$PSScriptRoot\Release"
    $PublishDir     = "$PublishRootDir\$ModuleName"
    # The following items will not be copied to the $PublishDir.
    # Add items that should not be published with the module.
    $Exclude = @(
        (Split-Path $PSCommandPath -Leaf),
        'Release',
        'Tests',
        '.git*',
        '.vscode',
        '*.psproj',
        '*.psbuild',
        '*.psprojs',
        # These files are unique to this examples dir.
        'Test-Module.ps1',
        'PSScriptAnalyzerSettings.psd1',
        'Readme.md',
        'Stop*.ps1'
    )
    # Name of the repository you wish to publish to. Default repo is the PSGallery.
    $PublishRepository = "$PublishRepoName"

    # Your NuGet API key for the PSGallery.  Leave it as $null and the first time
    # you publish you will be prompted to enter your API key.  The build will
    # store the key encrypted in a file, so that on subsequent publishes you
    # will no longer be prompted for the API key.
    $NuGetApiKey = $null
    $EncryptedApiKeyPath = "$env:LOCALAPPDATA\vscode-powershell\NuGetApiKey.clixml"
}
Write-Output 'Running AppVeyor build script' -ForegroundColor Yellow
Write-Output "ModuleName    : $env:ModuleName"
Write-Output "Build version : $env:APPVEYOR_BUILD_VERSION"
Write-Output "Author        : $env:APPVEYOR_REPO_COMMIT_AUTHOR"
Write-Output "Branch        : $env:APPVEYOR_REPO_BRANCH"
Write-Output "Repo          : $env:APPVEYOR_REPO_NAME"
Write-Output "Current working directory: $pwd"

#---------------------------------#
# BuildScript                     #
#---------------------------------#
Task Build -depends Clean, Init -requiredVariables PublishDir, Exclude, ModuleName {
    Copy-Item -Path $PSScriptRoot\* -Destination $PublishDir -Recurse -Exclude $Exclude

    # Get contents of the ReleaseNotes file and update the copied module manifest file
    # with the release notes.
    # DO NOT USE UNTIL UPDATE-MODULEMANIFEST IS FIXED - DOES NOT HANDLE SINGLE QUOTES CORRECTLY.
    # if ($ReleaseNotesPath) {
    #     $releaseNotes = @(Get-Content $ReleaseNotesPath)
    #     Update-ModuleManifest -Path $PublishDir\${ModuleName}.psd1 -ReleaseNotes $releaseNotes
    # }
}

Task Clean -requiredVariables PublishRootDir {
    # Sanity check the dir we are about to "clean".  If $PublishRootDir were to
    # inadvertently get set to $null, the Remove-Item commmand removes the
    # contents of \*.  That's a bad day.  Ask me how I know?  :-(
    if ((Test-Path $PublishRootDir) -and $PublishRootDir.Contains($PSScriptRoot)) {
        Remove-Item $PublishRootDir\* -Recurse -Force
    }
}

Task Init -requiredVariables PublishDir {
    if (!(Test-Path $PublishDir)) {
        $null = New-Item $PublishDir -ItemType Directory
    }
}