# Step 2: Deploy Frontend to Vercel
# This script helps deploy the frontend

Write-Host "=== STEP 3: Deploy Frontend to Vercel ===" -ForegroundColor Cyan
Write-Host ""

# Check if npm is installed
$npmCheck = npm --version 2>$null
if (-not $npmCheck) {
    Write-Host "❌ npm not found! Please install Node.js from https://nodejs.org" -ForegroundColor Red
    exit 1
}

Write-Host "✅ npm found: $npmCheck"
Write-Host ""

# Check if Vercel CLI is installed
$vercelCheck = vercel --version 2>$null
if (-not $vercelCheck) {
    Write-Host "Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

Write-Host "✅ Vercel CLI ready"
Write-Host ""

Write-Host "INSTRUCTIONS:" -ForegroundColor Green
Write-Host "1. Go to https://vercel.com (sign in with GitHub)"
Write-Host "2. Click 'Add New' → 'Project'"
Write-Host "3. Find and import 'Kuber_Timesheet' repository"
Write-Host "4. Add Environment Variables when prompted:"
Write-Host "   - NEXT_PUBLIC_SUPABASE_URL = [Your Supabase URL]"
Write-Host "   - NEXT_PUBLIC_SUPABASE_ANON_KEY = [Your Anon Key]"
Write-Host "   - SUPABASE_SERVICE_ROLE_KEY = [Your Service Role Key]"
Write-Host "   - NEXT_PUBLIC_NEPALI_API_URL = (leave empty, fill in Step 5)"
Write-Host "5. Click 'Deploy' and wait 3-5 minutes"
Write-Host ""
Write-Host "Your Frontend URL will appear in Vercel dashboard after deployment"
Write-Host "Example: https://kuber-timesheet.vercel.app"
Write-Host ""
Write-Host "After deployment, proceed to STEP 4"
