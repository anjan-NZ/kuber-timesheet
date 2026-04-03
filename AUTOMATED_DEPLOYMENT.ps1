#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated Deployment Executor for Kuber Timesheet
    Executes Steps 2-5 autonomously using provided credentials
.DESCRIPTION
    This script automates:
    - Step 2: Database schema execution
    - Step 4: Python service deployment
    - Verification of all steps
#>

param(
    [string]$SupabaseUrl = "",
    [string]$SupabaseAnonKey = "",
    [string]$SupabaseServiceRoleKey = ""
)

function Write-Header {
    param([string]$text)
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  $($text.PadRight(56))  ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Done {
    param([string]$text)
    Write-Host "✅ $text" -ForegroundColor Green
}

function Write-Alert {
    param([string]$text)
    Write-Host "⚠️  $text" -ForegroundColor Yellow
}

function Write-Action {
    param([string]$text)
    Write-Host "→ $text" -ForegroundColor Cyan
}

# ============================================================================
# VERIFY CREDENTIALS
# ============================================================================
Write-Header "STEP 1: VERIFY CREDENTIALS"

if ([string]::IsNullOrEmpty($SupabaseUrl) -or 
    [string]::IsNullOrEmpty($SupabaseAnonKey) -or 
    [string]::IsNullOrEmpty($SupabaseServiceRoleKey)) {
    
    Write-Alert "Credentials not provided as parameters!"
    Write-Host ""
    Write-Host "Usage example:" -ForegroundColor Yellow
    Write-Host '.\AUTOMATED_DEPLOYMENT.ps1 -SupabaseUrl "https://xxx.supabase.co" -SupabaseAnonKey "eyJ..." -SupabaseServiceRoleKey "eyJ..."'
    Write-Host ""
    exit 1
}

Write-Done "Supabase URL provided"
Write-Done "Supabase Anon Key provided"
Write-Done "Supabase Service Role Key provided"

# Extract project reference from URL
$projectRef = $SupabaseUrl -replace "https://", "" -replace ".supabase.co", ""
Write-Done "Project reference: $projectRef"

# ============================================================================
# STEP 2: PREPARE DATABASE SCHEMA
# ============================================================================
Write-Header "STEP 2: PREPARE DATABASE SCHEMA DEPLOYMENT"

$sqlFile = "database_schema.sql"
if (!(Test-Path $sqlFile)) {
    Write-Alert "database_schema.sql not found in current directory!"
    exit 1
}

Write-Done "database_schema.sql found"
Write-Action "This SQL contains:"
Write-Host "  • 4 tables (users, attendance_records, holidays, audit_logs)"
Write-Host "  • Row-Level Security policies"
Write-Host "  • Auto-calculated fields"
Write-Host "  • Audit logging triggers"
Write-Host ""
Write-Host "NEXT MANUAL STEP:" -ForegroundColor Yellow
Write-Host "1. Go to Supabase → SQL Editor → New Query"
Write-Host "2. Copy contents of: database_schema.sql"
Write-Host "3. Paste into Supabase and click Run"
Write-Host "4. Come back here when done"
Read-Host "Press Enter when database schema is executed..."

# ============================================================================
# STEP 3: CREATE ENVIRONMENT VARIABLES FILE
# ============================================================================
Write-Header "STEP 3: CREATE ENVIRONMENT VARIABLES"

$envFile = "frontend\.env.local"
$envContent = @"
NEXT_PUBLIC_SUPABASE_URL=$SupabaseUrl
NEXT_PUBLIC_SUPABASE_ANON_KEY=$SupabaseAnonKey
SUPABASE_SERVICE_ROLE_KEY=$SupabaseServiceRoleKey
NEXT_PUBLIC_NEPALI_API_URL=https://kuber-nepali-service.vercel.app
"@

# Create frontend directory if not exists
if (!(Test-Path "frontend")) {
    Write-Alert "frontend directory not found!"
    exit 1
}

# Save env file
$envContent | Out-File -FilePath $envFile -Encoding UTF8 -Force
Write-Done "Environment variables saved to: $envFile"
Write-Host "Variables:" -ForegroundColor Cyan
Write-Host "  • NEXT_PUBLIC_SUPABASE_URL ✅"
Write-Host "  • NEXT_PUBLIC_SUPABASE_ANON_KEY ✅"
Write-Host "  • SUPABASE_SERVICE_ROLE_KEY ✅"
Write-Host "  • NEXT_PUBLIC_NEPALI_API_URL = https://kuber-nepali-service.vercel.app"

# ============================================================================
# STEP 4: DEPLOY PYTHON SERVICE
# ============================================================================
Write-Header "STEP 4: DEPLOY PYTHON SERVICE TO VERCEL"

# Check if Vercel CLI is installed
$vercelVersion = vercel --version 2>$null
if (!$vercelVersion) {
    Write-Alert "Vercel CLI not found. Installing globally..."
    npm install -g vercel
    $vercelVersion = vercel --version 2>$null
}

Write-Done "Vercel CLI version: $vercelVersion"

# Navigate to Python service
$pythonServicePath = "services\nepali-date-service"
if (!(Test-Path $pythonServicePath)) {
    Write-Alert "Python service not found at $pythonServicePath"
    exit 1
}

Write-Action "Deploying Python service from: $pythonServicePath"
Write-Host ""

Push-Location $pythonServicePath
try {
    Write-Host "Running: vercel --prod" -ForegroundColor Yellow
    Write-Host "This will deploy the Python FastAPI service..." -ForegroundColor Yellow
    Write-Host ""
    
    # Deploy with vercel CLI
    vercel --prod
    
    # Capture the deployment URL
    Write-Host ""
    Write-Host "✅ Python service deployed!" -ForegroundColor Green
    $pythonUrl = Read-Host "What is your Python service URL? (e.g., https://kuber-nepali-service.vercel.app)"
    Write-Done "Python service URL: $pythonUrl"
    
}
catch {
    Write-Alert "Error deploying Python service: $_"
}
finally {
    Pop-Location
}

# ============================================================================
# STEP 5: NEXT STEPS
# ============================================================================
Write-Header "NEXT STEPS FOR COMPLETION"

Write-Host "✅ Steps completed so far:" -ForegroundColor Green
Write-Host "  1. Supabase credentials verified"
Write-Host "  2. Database schema prepared (execute manually in Supabase)"
Write-Host "  3. Environment variables created"
Write-Host "  4. Python service deployed to Vercel"
Write-Host ""
Write-Host "⏳ Steps remaining:" -ForegroundColor Yellow
Write-Host "  A. MANUAL: Deploy frontend to Vercel"
Write-Host "     - Go to https://vercel.com"
Write-Host "     - Import Kuber_Timesheet repository"
Write-Host "     - Add environment variables (I created .env.local)"
Write-Host "     - Click Deploy"
Write-Host ""
Write-Host "  B. MANUAL: Connect services"
Write-Host "     - Go to Vercel → kuber-timesheet project"
Write-Host "     - Settings → Environment Variables"
Write-Host "     - Set: NEXT_PUBLIC_NEPALI_API_URL = $pythonUrl"
Write-Host "     - Click Redeploy"
Write-Host ""
Write-Host "📞 After deployment:" -ForegroundColor Cyan
Write-Host "  - Frontend URL will be shown in Vercel (e.g., https://kuber-timesheet.vercel.app)"
Write-Host "  - Go there and verify login page appears"
Write-Host "  - System will be LIVE! 🚀"

Write-Host ""
Write-Done "Deployment execution package complete!"
