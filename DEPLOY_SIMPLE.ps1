$env:PATH = "C:\Program Files\nodejs;$env:PATH"

Write-Host "Installing Vercel CLI..."
& "C:\Program Files\nodejs\npm.cmd" install -g vercel 2>&1

Write-Host "Authenticating with Vercel..."
& "C:\Program Files\nodejs\npx.cmd" vercel login

Write-Host "Deploying frontend..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\frontend"
& "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod

Write-Host ""
Write-Host "Deploying Python service..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\services\nepali-date-service"
& "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod

Write-Host ""
Write-Host "Done!"
