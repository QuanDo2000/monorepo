winget install Microsoft.Powershell Git.Git JanDeDobbeleer.OhMyPosh vim.vim Microsoft.VisualStudioCode --disable-interactivity

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force

Update-Module

New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\" -Target "$PSScriptRoot\windows\Powershell\" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\" -Target "$PSScriptRoot\windows\Powershell\" -Force

# mklink /d %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\ %CD%\windows\Terminal
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" -Target "$PSScriptRoot\windows\Terminal\" -Force

# mklink %HOMEPATH%\_vimrc %CD%\vimrc.symlink
New-Item -ItemType SymbolicLink -Path "$HOME\_vimrc" -Target "$PSScriptRoot\vimrc.symlink" -Force
# mklink %HOMEPATH%\_gvimrc %CD%\windows\_gvimrc
New-Item -ItemType SymbolicLink -Path "$HOME\_gvimrc" -Target "$PSScriptRoot\windows\_gvimrc" -Force