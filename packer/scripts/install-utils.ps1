# PowerShell Bootstrap Script for Windows AMI
Write-Output "Installing Chocolatey and basic utilities..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y git notepadplusplus googlechrome
Write-Output "Utilities installed."