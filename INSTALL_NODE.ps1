$nodeUrl = 'https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi'
$installerPath = "$env:TEMP\node-installer.msi"

Write-Host 'Downloading Node.js...' -ForegroundColor Cyan
(New-Object System.Net.WebClient).DownloadFile($nodeUrl, $installerPath)

Write-Host 'Installing Node.js (this may take a few minutes)...' -ForegroundColor Cyan
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$installerPath`" /quiet"

Write-Host 'Cleaning up...' -ForegroundColor Cyan
Remove-Item $installerPath -Force

Write-Host 'Verifying installation...' -ForegroundColor Cyan
$nodeVersion = & node --version
$npmVersion = & npm --version

Write-Host "Node.js installed: $nodeVersion" -ForegroundColor Green
Write-Host "npm installed: $npmVersion" -ForegroundColor Green
