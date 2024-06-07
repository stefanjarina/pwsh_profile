### DOCKER GENERIC ###

function Remove-DockerImages {
    param(
        [switch]$Dangling,
        [string]$Ids = ""
    )
  
    if ((-not $Dangling) -and [string]::IsNullOrEmpty($Ids)) {
        Write-Error "You must specify at least one image id or call this function with -Dangling to remove only dangling images."
    }
    elseif ($Dangling) {
        docker rmi -f $(docker images -f "dangling=true" -q)
    }
    else {
        if ($Ids -contains ",") {
            $imageIds = $Ids -split ","
        }
        $imageIds = @($Ids)
        foreach ($id in $imageIds) {
            docker rmi $id
        }
    }
}
  
function Remove-DockerDanglingImages {
    Remove-DockerImages -Dangling
}

# DOCKER SWARM
function Start-SwarmCluster {
    docker-machine start node1 node2 node3
    Set-SwarmClusterVariables
}
  
function New-SwarmCluster {
    docker-machine create -d hyperv node1
    docker-machine create -d hyperv node2
    docker-machine create -d hyperv node3
    Set-SwarmClusterVariables
}
  
function Set-SwarmClusterVariables {
    docker-machine env node1 | Invoke-Expression
}
  
function Reset-SwarmClusterVariables {
    Remove-Item Env:\DOCKER_TLS_VERIFY
    Remove-Item Env:\DOCKER_HOST
    Remove-Item Env:\DOCKER_CERT_PATH
    Remove-Item Env:\DOCKER_MACHINE_NAME
}
  
function Stop-SwarmCluster {
    docker-machine stop node1 node2 node3
    Reset-SwarmClusterVariables
}
  
function Remove-SwarmCluster {
    docker-machine rm node1 node2 node3
    Reset-SwarmClusterVariables
}

##### KUBERNETES
# general
function Get-Kube {
    $ctx = kubectl config current-context
  
    if ($ctx -like "rancher*") {
        Write-Output "Kubernetes context is: 'RANCHER DESKTOP'"
    }
    elseif ($ctx -like "microk8s*") {
        Write-Output "Kubernetes context is: 'MICROK8S CLUSTER (via multipass)'"
    }
    else {
        Write-Output "Kubernetes context is: 'DOCKER DESKTOP'"
    }
}
  
function Set-KubeToDefault {
    if ($Env:LOCAL_K8S_PROVIDER -eq "rancher") {
        Set-KubeToRancher
    }
    elseif ($Env:LOCAL_K8S_PROVIDER -eq "microk8s") {
        Set-KubeToMicro
    }
    else {
        Set-KubeToDocker
    }
}
  
function Set-KubeToMicro {
    kubectl config use-context microk8s
  
    Write-Output "Kubernetes context set to: 'MICROK8S CLUSTER (via multipass)'"
}
  
function Set-KubeToRancher {
    kubectl config use-context rancher-desktop
  
    Write-Output "Kubernetes context set to: 'RANCHER DESKTOP'"
}
  
function Set-KubeToDocker {
    kubectl config use-context docker-desktop
  
    Write-Output "Kubernetes context set to: 'DOCKER DESKTOP'"
}

# minikube
function Start-Minikube {
    ## BELOW COMMENTED CODE IS REQUIRED IF CURRENT USER IS NOT IN HYPER-V ADMINISTRATORS GROUP
    #$command = "minikube start --vm-driver='hyperv' --memory=4096 --cpus=4 --hyperv-virtual-switch='ExternalSwitch' --v=7 --alsologtostderr"
    #$sh = new-object -com 'Shell.Application'
    #$sh.ShellExecute('powershell', "-NoExit -Command $command", '', 'runas')
    minikube start --vm-driver='hyperv' --memory=4096 --cpus=4 --hyperv-virtual-switch='ExternalSwitch' --v=7 --alsologtostderr
    Set-MinikubeVariables
}
  
function Stop-Minikube {
    minikube stop
    Reset-MinikubeVariables
}
  
function Set-MinikubeVariables {
    minikube docker-env | Invoke-Expression
}
  
function Reset-MinikubeVariables {
    Remove-Item Env:\DOCKER_TLS_VERIFY
    Remove-Item Env:\DOCKER_HOST
    Remove-Item Env:\DOCKER_CERT_PATH
}

# microk8s multipass
function Invoke-Micro {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("ip", "run", "start", "stop", "remove", "dashboard", "shell", "new", "use", "activate", "deactivate", "a", "d", "merge")]
        [string]$Command = "ip",
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
  
    switch ($Command) {
        "ip" { Get-MicroIp }
        "run" { Invoke-MicroCommand @Remaining }
        "start" { Start-Micro }
        "stop" { Stop-Micro }
        "remove" { Remove-Micro }
        "dashboard" { Start-MicroDashboard }
        "shell" { Invoke-MicroShell }
        "new" { New-Micro }
        "use" { Set-KubeToMicro }
        "a" { Set-KubeToMicro }
        "activate" { Set-KubeToMicro }
        "d" { Set-KubeToDefault }
        "deactivate" { Set-KubeToDefault }
        "merge" { Merge-MicroKubeConfig }
        Default { Get-MicroIp }
    }
}
  
function New-Micro {
    Write-Host "CREATING MULTIPASS INSTANCES" -ForegroundColor Blue
    Write-Host "============================" -ForegroundColor Blue
    New-MicroNode microk8s-master 10.0.1.1
    New-MicroNode microk8s-worker-1 10.0.1.11
    New-MicroNode microk8s-worker-2 10.0.1.12
    
    Write-Host "INSTALLING MICROK8S" -ForegroundColor Blue
    Write-Host "===================" -ForegroundColor Blue
    Install-MicroK8s microk8s-master
    Install-MicroK8s microk8s-worker-1
    Install-MicroK8s microk8s-worker-2
    
    Write-Host "FORMING MICROK8S CLUSTER" -ForegroundColor Blue
    Write-Host "========================" -ForegroundColor Blue
    Join-MicroCluster
    
    Write-Host "MERGING KUBECTL CONFIGS" -ForegroundColor Blue
    Write-Host "=======================" -ForegroundColor Blue
    Merge-MicroKubeConfig
}
  
function New-MicroNode($name, $ip) {
    Log-Command "Creating new multipass instance: $name"
    multipass launch --name $name --memory 4G --disk 40G --network "name=multipass,mode=manual"
    
    Log-Command "Fix too open permissions for /etc/netplan/50-cloud-init.yaml"
    multipass exec $name -- sudo chmod 600 /etc/netplan/50-cloud-init.yaml
    
    Set-MultipassStaticIp $name $ip
}
  
function Install-MicroK8s ($name) {
    Log-Command "Installing microk8s on $name"
    multipass exec $name -- sudo snap install microk8s --classic
  
    Log-Command "Setting up permissions for microk8s for user ubuntu on $name"
    multipass exec $name -- sudo usermod -a -G microk8s ubuntu
    multipass exec $name -- mkdir /home/ubuntu/.kube
    multipass exec $name -- sudo chown -R ubuntu /home/ubuntu/.kube
    
    Log-Command "Restarting $name to activate new permissions"
    multipass restart $name
  
    Log-Command "Waiting for microk8s to be ready on $name"
    multipass exec $name -- microk8s status --wait-ready
    
    Log-Command "Configuring iptables on $name for use with microk8s"
    multipass exec $name -- sudo iptables -P FORWARD ACCEPT
    
    Log-Command "Enabling microk8s addons on $name"
    multipass exec $name -- microk8s enable dns
}

function Join-MicroCluster {
    $joinOutput = multipass exec microk8s-master -- microk8s add-node --format json
    $joinUrl = ($joinOutput | ConvertFrom-Json).urls | Where-Object { $_.StartsWith("10.0.1") }
    
    Log-Command "Joining microk8s-worker-1 to microk8s-master"
    multipass exec microk8s-worker-1 -- microk8s join ${joinUrl} --worker
  
    $joinOutput = multipass exec microk8s-master -- microk8s add-node --format json
    $joinUrl = ($joinOutput | ConvertFrom-Json).urls | Where-Object { $_.StartsWith("10.0.1") }
    
    Log-Command "Joining microk8s-worker-2 to microk8s-master"
    multipass exec microk8s-worker-2 -- microk8s join ${joinUrl} --worker
    
    Log-Command "Waiting for nodes to be ready"
    Start-Sleep -Seconds 20
    multipass exec microk8s-master -- microk8s kubectl get nodes
}
  
function Merge-MicroKubeConfig {
    $tmpNew = New-TemporaryFile
    $tmpMerged = New-TemporaryFile
    multipass exec microk8s-master -- microk8s config | Out-File $tmpNew.FullName
    
    $originalConfigPath = "$env:USERPROFILE\.kube\config"
    $newConfigPath = "$tmpNew"
  
    # Backup original config
    Copy-Item $originalConfigPath "$originalConfigPath.bak" -Force
  
    $env:KUBECONFIG = "$newConfigPath;$originalConfigPath"
  
    kubectl config view --flatten | Out-File $tmpMerged.FullName
  
    Move-Item $tmpMerged.FullName $originalConfigPath -Force
  
    Remove-Item Env:\KUBECONFIG
    Remove-Item $tmpNew.FullName -Force
}

function Remove-Micro {
    multipass delete --purge microk8s-master
    multipass delete --purge microk8s-worker-1
    multipass delete --purge microk8s-worker-2
}

function Start-Micro {
    $nodes = @("microk8s-master", "microk8s-worker-1", "microk8s-worker-2")
    foreach ($node in $nodes) {
        multipass start $node
    }
    Log-Command "Waiting for microk8s to be ready"
    multipass exec microk8s-master -- microk8s status --wait-ready
    # possibly we need to do this
    # sudo microk8s refresh-certs -e server.crt
    # sudo microk8s refresh-certs -e front-proxy-client.crt
    Merge-MicroKubeConfig
}
  
function Stop-Micro {
    $nodes = @("microk8s-master", "microk8s-worker-1", "microk8s-worker-2")
    foreach ($node in $nodes) {
        multipass stop $node
    }
}

function Get-MicroIp {
    $ipCommand = multipass info microk8s-master --format json
    $ip = ($ipCommand | ConvertFrom-Json -Depth 9).info."microk8s-master".ipv4 | Where-Object { -not $_.StartsWith("10.") }
    $ip
}
  
function Invoke-MicroCommand {
    multipass exec microk8s-master microk8s -- $args
}

function Invoke-MicroShell {
    multipass shell microk8s-master
}

function Start-MicroDashboard {
    # Execute command and retrieve token
    $tokenCommand = multipass exec microk8s-master -- microk8s kubectl get secret -n kube-system microk8s-dashboard-token -o json
    $token = ($tokenCommand | ConvertFrom-Json).data.token
    $base64Token = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($token))
  
    # Execute command and retrieve IP
    $ipCommand = multipass info microk8s-master --format json
    $ip = ($ipCommand | ConvertFrom-Json -Depth 9).info."microk8s-master".ipv4 | Where-Object { -not $_.StartsWith("10.") }
  
    Write-Host "Connect to 'https://$($ip):10443' using token:"
    Write-Host "$base64Token"
  
    multipass exec microk8s-master -- microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 --address 0.0.0.0
}

# K3S multipass
function Invoke-K3s {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("ip", "run", "start", "stop", "remove", "dashboard", "shell", "new", "use", "activate", "deactivate", "a", "d", "merge")]
        [string]$Command = "ip",
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
  
    switch ($Command) {
        "ip" { Get-K3sIp }
        "run" { Invoke-K3sCommand @Remaining }
        "start" { Start-K3s }
        "stop" { Stop-K3s }
        "remove" { Remove-K3s }
        "dashboard" { Start-K3sDashboard }
        "shell" { Invoke-K3sShell }
        "new" { New-K3s }
        "use" { Set-KubeToK3s }
        "a" { Set-KubeToK3s }
        "activate" { Set-KubeToK3s }
        "d" { Set-KubeToDefault }
        "deactivate" { Set-KubeToDefault }
        "merge" { Merge-K3sKubeConfig }
        Default { Get-K3sIp }
    }
}
  
function New-K3s {
    Write-Host "CREATING MULTIPASS INSTANCES" -ForegroundColor Blue
    Write-Host "============================" -ForegroundColor Blue
    New-K3sNode k3s-master 10.0.1.1
    New-K3sNode k3s-worker-1 10.0.1.11
    New-K3sNode k3s-worker-2 10.0.1.12
  
    Write-Host "INSTALLING K3S" -ForegroundColor Blue
    Write-Host "==============" -ForegroundColor Blue
    Install-K3sMaster k3s-master
  
    $token = multipass exec k3s-master sudo cat /var/lib/rancher/k3s/server/node-token
  
    Install-K3sWorker k3s-worker-1 10.0.1.1 $token
    Install-K3sWorker k3s-worker-2 10.0.1.1 $token
  
    Write-Host "MERGING KUBECTL CONFIGS" -ForegroundColor Blue
    Write-Host "=======================" -ForegroundColor Blue
    Merge-K3sKubeConfig
  
    Write-Host "ADDING KUBE DASHBOARD" -ForegroundColor Blue
    Write-Host "=====================" -ForegroundColor Blue
    Add-K3sDashboard
}
  
function New-K3sNode ($name, $ip) {
    Log-Command "Creating new multipass instance: $name"
    multipass launch --name $name --memory 4G --disk 40G --network "name=multipass,mode=manual"
    
    Log-Command "Fix too open permissions for /etc/netplan/50-cloud-init.yaml"
    multipass exec $name -- sudo chmod 600 /etc/netplan/50-cloud-init.yaml
    
    Set-MultipassStaticIp $name $ip
}
  
function Install-K3sMaster ($name, $ip) {
    multipass exec $name -- bash -c "curl -sfL https://get.k3s.io | sh -"
    multipass exec $name -- bash -c "echo 'node-ip: $ip' | sudo tee -a /etc/rancher/k3s/config.yaml > /dev/null"
    multipass exec $name -- sudo systemctl restart k3s
}

function Install-K3sWorker ($name, $ip, $token) {
    multipass exec $name -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=""https://${ip}:6443"" K3S_TOKEN=""$token"" sh -"
    multipass exec $name -- bash -c "echo 'node-ip: $ip' | sudo tee -a /etc/rancher/k3s/config.yaml > /dev/null"
    multipass exec $name -- sudo systemctl restart k3s
}
  
function Remove-K3s {
    multipass delete --purge k3s-master
    multipass delete --purge k3s-worker-1
    multipass delete --purge k3s-worker-2
}
  
function Start-K3s {
    $nodes = @("k3s-master", "k3s-worker-1", "k3s-worker-2")
    foreach ($node in $nodes) {
        multipass start $node
    }
    Refresh-K3sCertificates
    Merge-K3sKubeConfig
}

function Stop-K3s {
    $nodes = @("k3s-master", "k3s-worker-1", "k3s-worker-2")
    foreach ($node in $nodes) {
        multipass stop $node
    }
}
  
function Refresh-K3sCertificates {
    $ip = Get-K3sIp
    Log-Command "Adding '$ip' to secrets/k3s-serving annotations"
    multipass exec k3s-master -- sudo kubectl annotate --overwrite -n kube-system secrets/k3s-serving listener.cattle.io/cn-$($ip)="${ip}"
    Log-Command "Stopping k3s service"
    multipass exec k3s-master -- sudo systemctl stop k3s
  
    Log-Command "Rotating k3s certificates"
    multipass exec k3s-master -- sudo k3s certificate rotate
  
    Log-Command "Starting k3s service"
    multipass exec k3s-master -- sudo systemctl start k3s
}

function Merge-K3sKubeConfig {
    $tmpNew = New-TemporaryFile
    $tmpMerged = New-TemporaryFile
    $ip = Get-K3sIp
    multipass exec k3s-master -- bash -c "sudo cat /etc/rancher/k3s/k3s.yaml | sed 's/default/k3s/' | sed s/127.0.0.1/$ip/" | Out-File $tmpNew.FullName
    
    $originalConfigPath = "$env:USERPROFILE\.kube\config"
    $newConfigPath = "$tmpNew"
  
    # Backup original config
    Copy-Item $originalConfigPath "$originalConfigPath.bak" -Force
  
    $env:KUBECONFIG = "$newConfigPath;$originalConfigPath"
  
    kubectl config view --flatten | Out-File $tmpMerged.FullName
  
    Move-Item $tmpMerged.FullName $originalConfigPath -Force
  
    Remove-Item Env:\KUBECONFIG
    Remove-Item $tmpNew.FullName -Force
}

function Get-K3sIp {
    $ipCommand = multipass info k3s-master --format json
    $ip = ($ipCommand | ConvertFrom-Json -Depth 9).info."k3s-master".ipv4 | Where-Object { -not $_.StartsWith("10.") }
    $ip
}
  
function Invoke-K3sCommand {
    multipass exec k3s-master -- k3s $args
}
  
function Invoke-K3sShell {
    multipass shell k3s-master
}

function Add-K3sDashboard {
    # Below can now be run locally and not via multipass exec
    # https://www.linuxbuzz.com/install-k3s-kubernetes-cluster-on-ubuntu/#Step_6_Install_and_Access_k3s_Kubernetes_Dashboard
    Log-Command "Adding kubernetes dashboard"
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
    Log-Command "Creating admin user for dashboard"
    kubectl apply -f G:\proj\kubernetes\dashboard_login\dashboard-adminuser.yaml
}
  
function Start-K3sDashboard {
    $token = kubectl get secret admin-user -n kube-system -o jsonpath="{".data.token"}"
    $base64Token = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($token))
  
    Write-Host "Connect to 'https://localhost:10443' using token:"
    Write-Host "$base64Token"
  
    kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10443:443 --address 0.0.0.0
}
 
# Kubernetes
New-Alias -Force -Name k -Value "kubectl"
New-Alias -Force -Name n -Value "nerdctl"
# minikube
New-Alias -Force startmini Start-Minikube
New-Alias -Force stopmini Stop-Minikube
# microk8s
New-Alias -Force -Name micro -value Invoke-Micro
New-Alias -Force -Name microk8s -value Invoke-MicroCommand
# k3s
New-Alias -Force -Name k3s -value Invoke-K3s
