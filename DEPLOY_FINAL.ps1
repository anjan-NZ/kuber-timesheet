$env:PATH = "C:\Program Files\nodejs;$env:PATH"

Write-Host "Deploying Frontend..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\frontend"
# Use echo to pipe 'yes' responses to vercel
echo "yes" | & "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod

Write-Host ""
Write-Host "Deploying Python Service..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\services\nepali-date-service"
echo "yes" | & "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod

Write-Host ""
Write-Host "Deployment Complete!"
