##### VAGRANT
$Env:VAGRANT_PREFER_SYSTEM_BIN = 0 # Force vagrant to use vendored ssh executable

##### Hyper-V
function Set-ForwardingEnabled {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "You must run this function in elevated context."
    }
    else {
        Get-NetIPInterface | Where-Object { $_.InterfaceAlias -like 'vEthernet (WSL*' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)' } | Set-NetIPInterface -Forwarding Enabled
        Write-Host "Forwarding enabled."
    }
}

##### MULTIPASS

function Set-MultipassStaticIp ($name, $ip) {
    Log-Command "Configuring static IP for $name to be $ip/24"
    $cmdOutput = multipass exec $name -- ip addr show eth1
    $macAddress = ($cmdOutput | Select-String "link/ether").Line.Trim().Split()[1].Trim()
    $netPlanString = @"
network:
ethernets:
    eth1:
        dhcp4: false
        match:
            macaddress: $macAddress
        set-name: eth1
        addresses: [$ip/24]
version: 2
"@
    $tmp = New-TemporaryFile
    $netPlanString | Out-File -FilePath $tmp.FullName

    Log-Command "Creating 99-multipass.yaml and transferring it to $name"
    multipass transfer $tmp ${name}:99-multipass.yaml
    multipass exec $name -- sudo mv 99-multipass.yaml /etc/netplan/99-multipass.yaml

    Log-Command "Setting permissions for 99-multipass.yaml on $name"
    multipass exec $name -- sudo chown root:root /etc/netplan/99-multipass.yaml
    multipass exec $name -- sudo chmod 600 /etc/netplan/99-multipass.yaml

    Log-Command "Applying netplan configuration on $name"
    Write-Host "This action will hang the terminal. There is no way around it. Once it hangs, press enter and it will continue after short while." -ForegroundColor Yellow
    multipass exec $name -- sudo netplan apply

    Remove-Item $tmp.FullName -Force
    Log-Command "netplan configuration on $name successfuly applied"
}

# General
New-Alias -Force -Name sfe -Value Set-ForwardingEnabled
# Multipass
New-Alias -Force -Name mu -Value "multipass"
