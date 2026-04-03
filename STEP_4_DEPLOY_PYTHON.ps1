# Step 4: Deploy Python Service to Vercel

Write-Host "=== STEP 4: Deploy Python Service to Vercel ===" -ForegroundColor Cyan
Write-Host ""

# Check if Vercel CLI is installed
$vercelVersion = vercel --version 2>$null
if (-not $vercelVersion) {
    Write-Host "❌ Vercel CLI not found!" -ForegroundColor Red
    Write-Host "Installing Vercel CLI globally..." -ForegroundColor Yellow
    npm install -g vercel
    $vercelVersion = vercel --version 2>$null
}

Write-Host "✅ Vercel CLI: $vercelVersion"
Write-Host ""

# Navigate to Python service
$pythonServicePath = "services\nepali-date-service"
if (-not (Test-Path $pythonServicePath)) {
    Write-Host "❌ Python service not found at $pythonServicePath" -ForegroundColor Red
    Write-Host "Make sure you're in the correct directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Python service found at $pythonServicePath"
Write-Host ""

Write-Host "INSTRUCTIONS:" -ForegroundColor Green
Write-Host "1. Run this command:"
Write-Host "   cd services\nepali-date-service"
Write-Host "   vercel --prod"
Write-Host ""
Write-Host "2. When prompted:"
Write-Host "   - 'Set up and deploy?' → answer 'y'"
Write-Host "   - 'Project name?' → enter 'kuber-nepali-service'"
Write-Host "   - 'Do you want to deploy?' → answer 'y'"
Write-Host ""
Write-Host "3. Wait 2-3 minutes for deployment"
Write-Host ""
Write-Host "Your Python Service URL will appear in Vercel:"
Write-Host "Example: https://kuber-nepali-service.vercel.app"
Write-Host ""
Write-Host "AUTOMATED DEPLOYMENT (if you prefer):"
Write-Host "Uncomment and run this:"
Write-Host ""
Write-Host "# Set-Location services\nepali-date-service"
Write-Host "# vercel --prod"
Write-Host "# Set-Location ..\.."
