$env:PATH = "C:\Program Files\nodejs;$env:PATH"

Write-Host "Deploying Frontend..."
Set-Location "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\frontend"
& "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod --yes

Write-Host ""
Write-Host "Deploying Python Service..."
Set-Location "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\services\nepali-date-service"
& "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod --yes

Write-Host ""
Write-Host "Done"
