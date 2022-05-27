oh-my-posh init pwsh --config ~/oh_my_posh/themes/bubblesextra.omp.json | Invoke-Expression

Import-Module Terminal-Icons
Import-Module posh-git

Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineOption -BellStyle None


# Env vars
$DOWNLOADS = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path


# Functions
function vactiva () {
    if ( -Not (Test-Path -Path ".venv") ) {
        virtualenv .venv
    }

    .venv/Scripts/activate.ps1

    Write-Output "Python Virtual Environment - Activated", $((get-command python.exe).Path)
}

function which($executable_name) {
    Write-Host (Get-Command $executable_name).Path
}

function pwsh_profile_upgrade() {
    $profile_path = $PROFILE
    $web_url = "https://gist.githubusercontent.com/maximilionus/c15ee5b3330f662e736888ca13b85e92/raw/bfb7d556324680009ba5ec99440a8d1a4a879fc4/Microsoft.PowerShell_profile.ps1"
    $web_content = (iwr $web_url).Content

    $web_hash = (Get-FileHash -Algorithm SHA256 -InputStream $([IO.MemoryStream]::new([byte[]][char[]]$web_content))).Hash
    $local_hash = (Get-FileHash -Algorithm SHA256 $profile_path).Hash

    if ( $web_hash -ne $local_hash ) {
        $decision = $Host.UI.PromptForChoice('New updates for powershell profile detected', 'Install them?', ('&Yes', '&No'), 1)
        if ($decision -eq 0) {
            Write-Host 'Upgrading powershell profile'
            iwr $web_url -OutFile $profile_path
        } else {
            Write-Host 'Updating process was cancelled by user'
        }
    } else {
        Write-Host "You're up-to-date 👍"
    }
}


# Alias
Set-Alias ll ls
