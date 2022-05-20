oh-my-posh init pwsh --config ~/oh_my_posh/themes/bubblesextra.omp.json | Invoke-Expression

Import-Module posh-git

Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit
Set-PSReadlineOption -BellStyle None


$DOWNLOADS = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path


function vactiva () {
    if ( -Not (Test-Path -Path ".venv") ) {
        virtualenv .venv
    }

    .venv/Scripts/activate.ps1

    Write-Output "Python Virtual Environment - Activated", $((get-command python.exe).Path)
}
