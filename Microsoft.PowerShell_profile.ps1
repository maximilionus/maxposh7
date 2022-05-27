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

function poshpoup() {
    # Profile upgrader
    $profile_path = $PROFILE
    $web_temp_profile_path = $env:TEMP + '\MXML_PowerShell_profile.temp.ps1'
    $web_url = "https://gist.githubusercontent.com/maximilionus/c15ee5b3330f662e736888ca13b85e92/raw/Microsoft.PowerShell_profile.ps1"

    # Save web version to temp dir
    iwr -Uri $web_url -OutFile $web_temp_profile_path

    # Calculate SHA-256 hashes for installed and downloaded profiles
    $temp_hash = (Get-FileHash -Algorithm SHA256 $web_temp_profile_path).Hash
    $installed_hash = (Get-FileHash -Algorithm SHA256 $profile_path).Hash

    # Upgrade procedure
    if ( $temp_hash -ne $installed_hash ) {
        $decision = $Host.UI.PromptForChoice('New updates for powershell profile detected', 'Install them?', ('&Yes', '&No'), 1)
        if ($decision -eq 0) {
            cpi -Force -Path $web_temp_profile_path -Destination $profile_path
            . $profile_path
            Write-Host -ForegroundColor Green '✅ Powershell profile was successfully upgraded to latest version and reloaded'
        } else {
            Write-Host -ForegroundColor Red '❌ Updating process was cancelled by user'
        }
    } else {
        Write-Host -ForegroundColor Green "❎ You're up-to-date 👍"
    }
}


# Alias
Set-Alias ll ls
