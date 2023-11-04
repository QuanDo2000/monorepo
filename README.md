# Quan's MonoRepo

## dotfiles

Contained within `dotfiles` are my personal setup scripts for a new machine.

- To install on Linux/MacOS, run the following:

```bash
source <(curl -s https://raw.githubusercontent.com/QuanDo2000/monorepo/main/dotfiles/install)
```

- To install on Windows, run the following in PowerShell as Administrator:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
iwr -useb https://raw.githubusercontent.com/QuanDo2000/monorepo/main/dotfiles/install.ps1 | iex
```
