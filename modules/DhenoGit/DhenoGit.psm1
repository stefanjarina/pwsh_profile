# GIT
function Get-CGitStatus {
    git status $args
}
function Get-CGitDiff {
    git diff --stat $args
}
function Invoke-CGitAllCommit {
    git add --all $args
}
function Invoke-CGitPush {
    git push $args
}
function Invoke-CGitPushOriginMaster {
    git push -u origin master $args
}
function Invoke-CGitCommitWithMessage {
    if ( $args.Count -lt 1 ) {
        Write-Output "Please specify message for commit"
        break
    }
    git commit -m "$args"
}

New-Alias -Force gs Get-CGitStatus
New-Alias -Force gd Get-CGitDiff
New-Alias -Force ga Invoke-CGitAllCommit
New-Alias -Force gpu Invoke-CGitPush
New-Alias -Force gpom Invoke-CGitPushOriginMaster
New-Alias -Force gmm Invoke-CGitCommitWithMessage
# Github's `hub` CLI
# New-Alias -Force -Name git -Value "lab"
