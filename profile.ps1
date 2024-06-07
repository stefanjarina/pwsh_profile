using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# LOAD LOCAL CONFIGURATION VARS:
if (Test-Path "$Env:USERPROFILE\Documents\PowerShell\local_ps_config.ps1") {
  . "$Env:USERPROFILE\Documents\PowerShell\local_ps_config.ps1"
}

##### Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

##### IMPORTS
if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadLine
}
Import-Module Terminal-Icons
Import-Module DockerCompletion
#Import-Module Pester

## OH-MY-POSH
oh-my-posh init pwsh --config "$env:DOTFILES_LOCATION\themes\jandedobbeleer.stiwy.v3.json" | Invoke-Expression

##### DOTFILES BUNDLED MODULES
$bundledModulesPath = $env:DOTFILES_LOCATION + "\powershell\modules"
if ($env:PSModulePath -notmatch "$($bundledModulesPath -replace '\\', '\\')") {
  $env:PSModulePath = $env:PSModulePath + ";$bundledModulesPath"
}
Import-Module DhenoCore -Force -DisableNameChecking
Import-Module DhenoGit -Force -DisableNameChecking
Import-Module DhenoVirtual -Force -DisableNameChecking
Import-Module DhenoContainers -Force -DisableNameChecking
Import-Module DhenoDevTools -Force -DisableNameChecking

##### CUSTOM MODULES
if ($env:PSModulePath -notmatch "$($Env:MODULES_LOCATION -replace '\\', '\\')") {
  $env:PSModulePath = $env:PSModulePath + ";$Env:MODULES_LOCATION"
}
Import-Module SimpleDockerApps -Force

##### ENV VARIABLES
# Load Local vars
if (Test-Path "$env:CONFIGS_LOCATION\stefanjarina\local_env_vars.ps1") {
  . $env:CONFIGS_LOCATION/stefanjarina/local_env_vars.ps1
}

##### LOCAL K8S PROVIDER
$Env:LOCAL_K8S_PROVIDER = "rancher"  # Possible options 'microk8s', 'rancher', 'docker'

# FIX FUCKING POWERSHELL TAB AUTOCOMPLETION
if (! [System.Console]::IsOutputRedirected -and $host.UI.SupportsVirtualTerminal) {
  Set-PSReadLineOption -PredictionSource History
  #Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -EditMode Windows
  Set-PSReadlineKeyHandler -Key Tab -Function Complete
}

# POWERSHELL ARGUMENT COMPLETION
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# `ForwardChar` accepts the entire suggestion text when the cursor is at the end of the line.
# This custom binding makes `RightArrow` behave similarly - accepting the next word instead of the entire suggestion text.
Set-PSReadLineKeyHandler -Key RightArrow `
  -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
  -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($cursor -lt $line.Length) {
    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
  }
}

# Powershell Completions for DENO
#. $env:DOTFILES_LOCATION\powershell\completions\deno.ps1

# Powershell Completions for RUSTUP
. $env:DOTFILES_LOCATION\powershell\completions\rustup.ps1

# GOLANG 
$Env:GOPATH = "G:\libs\go"

##### FUNCTIONS

function refdot {
  Set-Location $env:DOTFILES_LOCATION
  git pull
  Set-Location -
  Get-Profile | Invoke-Expression
}

function Update-AllApps {
  python3 $env:DOTFILES_LOCATION\scripts\callable\update-all.py
}

function Get-Profile {
  Write-Output ". $($PROFILE.CurrentUserAllHosts)`n#Run: Get-Profile | Invoke-Expression"
}

function Edit-Profile {
  ci $PROFILE.CurrentUserAllHosts
}

function Edit-ProfileDir {
  ci $env:DOTFILES_LOCATION\powershell
}

function Get-Functions {
  param(
    [string]$searchString = "*"
  )
  Get-Content $PROFILE.CurrentUserAllHosts |
  Write-Output |
  findstr /R "^function" |
  ForEach-Object { $_ -replace "function ", "" } |
  ForEach-Object { $_ -replace "{", "" } | Sort-Object |
  Where-Object { $_ -like "*$searchString*" }
}

##### FIXES
# Fix bloody rust libpg.lib build errors
#$Env:PQ_LIB_DIR = "G:\libs\postgresql-11.2-1-windows-x64-binaries\pgsql\lib"

##### ALIASES
# update-all.py
New-Alias -Force -Name update-all -Value Update-AllApps
# VS Code Insider
New-Alias -Force -Name ci -Value "code-insiders"
# Edit Powershell profile
New-Alias -Force ep Edit-Profile
# Reload profile
New-Alias -Force reload Get-Profile
