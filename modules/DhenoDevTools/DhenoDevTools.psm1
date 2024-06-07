################
################

##### DOTNET
$Env:DOTNET_CLI_TELEMETRY_OPTOUT = 1

##### PYTHON
# VIRTUALENV
$Env:VIRTUAL_ENV_DISABLE_PROMPT = 1
# PIPENV
$Env:PIPENV_VENV_IN_PROJECT = 1

##### FLUTTER
# FIX FOR EDGE FOR FLUTTER
$Env:CHROME_EXECUTABLE = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

##### NODE PACKAGE MANAGERS
$Env:NODE_DEFAULT_PM = "npm"  # Possible options 'pnpm', 'npm'

###############
###############

# PYTHON
function New-PythonVenv {
    python3 -m venv $args
}

# RUST
function Invoke-CargoWithWatch {
    ###
    # needs 'cargo install cargo-watch'
    ###
    
    param(
        [Parameter(Position = 0)][string]$cliArgs = "",
        [string]$CmdOverwrite = "run -q"
    )
    $runCmd = $CmdOverwrite
  
    if ($cliArgs -ne "") {
        $runCmd += " -- "
        $runCmd += $cliArgs
    }
  
    cargo watch -q -c -x "$runCmd"
}

# GOLANG
function create-golang-app {
    param(
        [Parameter(Mandatory = $true)][string]$name
    )
  
    $name = $name.Trim()
    $name = $name -replace " ", "_"
  
    New-Item -ItemType Directory -Name $name
    Set-Location ./$name
    go mod init github.com/stefanjarina/$name
}

####### NPM/PNPM ALIASES
function create-astro-app {
    param(
        [string]$name
    )
    
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create astro@latest $name
    }
    else {
        npm create astro@latest $name
    }
}
  
function create-sveltekit-app {
    param(
        [string]$name
    )
  
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create svelte@latest $name
    }
    else {
        npm create svelte@latest $name
    }
}
  
function create-nuxt-app {
    param(
        [Parameter(Mandatory = $true)][string]$name
    )
    
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm dlx nuxi init $name
    }
    else {
        npx nuxi init $name
    }
}
  
function create-remix-app {
    param(
        [string]$name
    )
    
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create remix@latest $name
    }
    else {
        npm create remix@latest $name
    }
}
  
function create-solid-app {
    param(
        [string]$name
    )
    
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create solid@latest $name
    }
    else {
        npm create solid@latest $name
    }
}
  
function create-skeleton-app {
    param(
        [string]$name
    )
    
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create skeleton-app@latest $name
    }
    else {
        npm create skeleton-app@latest $name
    }
}
  
function create-tauri-app {
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm create tauri-app@latest
    }
    else {
        npm create tauri-app@latest
    }
}
  
function nodemon {
    param(
        [string]$cliArgs = ""
    )
    $arguments = $cliArgs.Split(" ")
  
    if ($null -ne $Env:NODE_DEFAULT_PM -and $Env:NODE_DEFAULT_PM -eq "pnpm") {
        pnpm --silent dlx nodemon $arguments
    }
    else {
        npx nodemon $arguments
    }
}

####### UTILS

function add-prettierrc {
    $remoteFileUri = "https://gist.githubusercontent.com/stefanjarina/d058a53958b3b695fd02fb809206b81f/raw/a45d23b50115e08620e2b3a245e01fa9a33fd72d/.prettierrc"
  
    if ( Test-Path ".prettierrc" ) {
        $confirmation = Read-Host ".prettierrc file already exists. Do you want me to overwrite it? (Y/n)"
  
        switch -Regex ($confirmation) {
            '[Nn]' {}
            Default { Invoke-WebRequest -Uri $remoteFileUri -OutFile ".prettierrc" }
        }
    }
    else {
        Invoke-WebRequest -Uri $remoteFileUri -OutFile ".prettierrc"
    }
}


# CARGO
New-Alias -Force -Name ca -Value "cargo"
# Elixir IEX
New-Alias -Force -Name ie -Value "C:\Users\stefa\scoop\apps\elixir\current\bin\iex.bat"
# PNPM
New-Alias -Force -Name pn -Value pnpm
# Rust
New-Alias -Force cw Invoke-CargoWithWatch
# Python
New-Alias -Force venv New-PythonVenv
