winget install Microsoft.Powershell Git.Git JanDeDobbeleer.OhMyPosh vim.vim Microsoft.VisualStudioCode --disable-interactivity

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force

Update-Module

cmd /c mklink /d $HOME\Documents\WindowsPowerShell\ $PSScriptRoot\windows\Powershell\
cmd /c mklink /d $HOME\Documents\PowerShell\ $PSScriptRoot\windows\Powershell\

cmd /c mklink /d $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\ $PSScriptRoot\windows\Terminal

cmd /c mklink $HOME\_vimrc $PSScriptRoot\vimrc.symlink
cmd /c mklink $HOME\_gvimrc $PSScriptRoot\windows\_gvimrc