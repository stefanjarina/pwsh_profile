# LOGGING
function Log-Command ($msg, $color = "Cyan") {
    Write-Host "$msg" -ForegroundColor $color
}

function Invoke-PythonServe {
    if ( $args.Count -ge 1 ) {
        $d = $args[0]
    }
    else {
        $d = ".\"
    }
    python -c 'import sys; sys.exit(sys.version_info[0] != 3)'
    if ( $? ) {
        Set-Location $d
        python -m http.server
    }
    else {
        Set-Location $d
        python -m SimpleHTTPServer
    }
}
  
function Write-ColorizedOutput {
    if ( $args.Count -lt 1 ) {
        Write-Output "Call this function with at least one parameter."
    }
    else {
        pygmentize -g -O style=monokai, bg=dark $args
    }
}
  
# PWSH HELPER FUNCTIONS
function Get-Timestamp {
    [int][double]::Parse((Get-Date -UFormat %s))
}
  
  
function Get-OpenPortToProcessMap {
    $addresses = '127.0.0.1', '0.0.0.0', '::', '::1'
  
    foreach ( $ip in Get-NetIPAddress | Where-Object { $_.InterfaceAlias -Like '*external*' } | Select-Object -property IPAddress ) {
        $addresses += $ip.IPAddress
    }
  
    $ports = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" -and $addresses.Contains($_.LocalAddress) } | Select-Object LocalAddress, LocalPort, OwningProcess
  
    foreach ($port in $ports) {
        $processId = $port.OwningProcess
        $process = get-process -Id $processId
        $newObject = New-Object -TypeName psobject
        $newObject | Add-Member -MemberType NoteProperty -Name Address -Value $port.LocalAddress
        $newObject | Add-Member -MemberType NoteProperty -Name Port -Value $port.LocalPort
        $newObject | Add-Member -MemberType NoteProperty -Name Pid -Value $processId
        $newObject | Add-Member -MemberType NoteProperty -Name ProcessName -Value $process.ProcessName
        $newObject | Add-Member -MemberType NoteProperty -Name Product -Value $process.Product
        $newObject | Add-Member -MemberType NoteProperty -Name Path -Value $process.Path
        Write-Output $newObject
    }
}
  
function Invoke-FormattedLsof {
    Get-OpenPortToProcessMap | Sort-Object Address, Port | format-table
}
  
function Get-DirectoriesOrderedBySize {
    param(
        [Parameter(Position = 0)][string]$Path = ".",
        [ValidateSet("Asc", "Desc")][string]$Sort = "Desc",
        [switch]$MB,
        [switch]$GB,
        [int]$First = 0,
        [int]$Last = 0
    )
  
    # Check for mutual exclusivity
    if ($MB -and $GB) {
        throw "Parameters '-MB' and '-GB' cannot be used together."
    }
  
    if ($First -and $Last) {
        throw "Parameters '-First' and '-Last' cannot be used together."
    }
  
    $sortParams = @{
        Property   = "Sum"
        Descending = $true
    }
  
    if ($Sort -eq "Asc") {
        $sortParams.Descending = $false
    }
  
    $list = get-childitem $Path | 
    ForEach-Object { $f = $_ ; 
        get-childitem -r $_.FullName | 
        measure-object -property length -sum | 
        Select-Object Sum, @{Name = "Name"; Expression = { $f } } } |
    Sort-Object @sortParams
  
    if ($PSBoundParameters.ContainsKey("MB")) {
        $list = $list | Select-Object @{Name = "MegaBytes"; Expression = { $_.Sum / 1MB } }, Name  
    }
    if ($PSBoundParameters.ContainsKey("GB")) {
        $list = $list | Select-Object @{Name = "GigaBytes"; Expression = { $_.Sum / 1GB } }, Name
    }
  
    if ($First -gt 0) {
        $list | Select-Object -First $First
    }
    elseif ($Last -gt 0) {
        $list | Select-Object -Last $Last
    }
    else {
        $list
    }
}
  
function Get-ChildItem-MegaBytes {
    Get-ChildItem $args | Select-Object Name, @{Name = "MegaBytes"; Expression = { $_.Length / 1MB } }
}
  
function Find-AppsUninstallRegistryEntry {
    param(
        [Parameter(Mandatory = $true, Position = 0)][string]$SearchPattern
    )
    $regPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
  
    function Get-RegItem($path, $name) {
        if ((Get-ItemProperty $path.PsPath).PSObject.Properties.name -contains "$name") {
            return Get-ItemPropertyValue -Path $path.PsPath -Name "$name" -ErrorAction Ignore
        }
        else {
            return $null
        }
    }
  
    Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue | ForEach-Object {
        $displayName = Get-RegItem $_ 'DisplayName'
        $installSource = Get-RegItem $_ 'InstallSource'
  
        if (($null -ne $displayName -and $displayName -like $SearchPattern) -or ($null -ne $installSource -and $installSource -like $SearchProperty)) {
            "Name: '$displayName' - Key: '$($_.PSChildName)'"
        }
    }
}


New-Alias -Force timestamp Get-Timestamp
New-Alias -Force serve Invoke-PythonServe
New-Alias -Force cl Write-ColorizedOutput
New-Alias -Force lsof Invoke-FormattedLsof
New-Alias -Force megs Get-ChildItem-MegaBytes
New-Alias -Force du Get-DirectoriesOrderedBySize
# I want my bloody 'which' command
New-Alias -Force -Name which -Value "Get-Command"
