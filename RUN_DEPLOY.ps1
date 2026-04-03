$env:PATH = "C:\Program Files\nodejs;$env:PATH"

Write-Host "======================================"
Write-Host "DEPLOYING KUBER TIMESHEET"
Write-Host "======================================"
Write-Host ""

Write-Host "Deploying Frontend..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\frontend"
$args = @("deploy", "--prod", "--yes")
& "C:\Program Files\nodejs\npx.cmd" $args

Write-Host ""
Write-Host "Deploying Python Service..."
cd "C:\Users\anjan\Desktop\In progress\Kuber TImesheet\services\nepali-date-service"
& "C:\Program Files\nodejs\npx.cmd" deploy --prod --yes

Write-Host ""
Write-Host "======================================"
Write-Host "DEPLOYMENT COMPLETE ✓"
Write-Host "======================================"
Write-Host ""
Write-Host "Your system is now LIVE!"
Write-Host ""
