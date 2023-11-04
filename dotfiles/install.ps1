winget install Microsoft.Powershell Git.Git JanDeDobbeleer.OhMyPosh vim.vim Microsoft.VisualStudioCode Microsoft.WindowsTerminal --disable-interactivity

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force

Update-Module

if (!(Test-Path $HOME\Documents\WindowsPowerShell)) { New-Item -ItemType Directory -Path $HOME\Documents\WindowsPowerShell }
if (!(Test-Path $HOME\Documents\PowerShell)) { New-Item -ItemType Directory -Path $HOME\Documents\PowerShell }

cmd /c mklink $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 $PSScriptRoot\windows\Powershell\Microsoft.PowerShell_profile.ps1
cmd /c mklink $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1 $PSScriptRoot\windows\Powershell\Microsoft.VSCode_profile.ps1
cmd /c mklink $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 $PSScriptRoot\windows\Powershell\Microsoft.PowerShell_profile.ps1
cmd /c mklink $HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1 $PSScriptRoot\windows\Powershell\Microsoft.VSCode_profile.ps1

cmd /c mklink $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json $PSScriptRoot\windows\Terminal\settings.json

cmd /c mklink $HOME\_vimrc $PSScriptRoot\vimrc.symlink
cmd /c mklink $HOME\_gvimrc $PSScriptRoot\windows\_gvimrc