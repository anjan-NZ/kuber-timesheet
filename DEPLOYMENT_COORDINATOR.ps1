#!/usr/bin/env pwsh
# Script: Kuber Timesheet - Automated Deployment Coordinator
# Last updated: April 3, 2026
<#
.SYNOPSIS
    Kuber Timesheet - Automated Deployment Coordinator
    Guides user through all deployment steps with checks
.DESCRIPTION
    This script walks through the 5-step deployment process
    Step 1: Supabase Setup (manual in browser)
    Step 2: Database Schema (manual SQL in Supabase)
    Step 3: Frontend Deploy (manual in Vercel)
    Step 4: Python Deploy (automated with vercel CLI)
    Step 5: Connect Services (manual in Vercel)
#>

function Write-Header {
    param([string]$text)
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  $($text.PadRight(54))" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$step)
    Write-Host "→ $step" -ForegroundColor Green
}

function Write-Alert {
    param([string]$text)
    Write-Host "⚠️  $text" -ForegroundColor Yellow
}

function Write-Done {
    param([string]$text)
    Write-Host "[OK] $text" -ForegroundColor Green
}

function Wait-For-User {
    param([string]$prompt = "Press Enter when ready...")
    Write-Host ""
    Read-Host $prompt
    Write-Host ""
}

# Main Script
Clear-Host
Write-Header "KUBER TIMESHEET DEPLOYMENT"

Write-Host "This script will guide you through 5 deployment steps (~30 minutes)" -ForegroundColor Cyan
Write-Host ""
Write-Step "Step 1: Create Supabase Project (MANUAL - 5 min)"
Write-Step "Step 2: Create Database Tables (MANUAL SQL - 3 min)"
Write-Step "Step 3: Deploy Frontend (MANUAL - Vercel - 8 min)"
Write-Step "Step 4: Deploy Python Service (AUTOMATED - 8 min)"
Write-Step "Step 5: Connect Services (MANUAL - Vercel - 5 min)"
Write-Host ""

# ============================================================================
# STEP 1
# ============================================================================
Write-Header "STEP 1: CREATE SUPABASE PROJECT"

Write-Host "Actions needed:" -ForegroundColor Green
Write-Host "1. Go to https://app.supabase.com"
Write-Host "2. Click 'New project'"
Write-Host "3. Fill in:"
Write-Host "   • Project name: Kuber_Timesheet"
Write-Host "   • Database password: [create strong one]"
Write-Host "   • Region: [closest to you]"
Write-Host "4. Wait 2-3 minutes for creation"
Write-Host "5. Go to Settings → API"
Write-Host "6. Copy these 3 values:"
Write-Host "   • SUPABASE_URL"
Write-Host "   • SUPABASE_ANON_KEY"
Write-Host "   • SUPABASE_SERVICE_ROLE_KEY"
Write-Host ""

Write-Alert "KEEP THESE CREDENTIALS SAFE - YOU'LL NEED THEM FOR NEXT STEPS"
Wait-For-User "Press Enter when you've saved all 3 Supabase credentials..."

# ============================================================================
# STEP 2
# ============================================================================
Write-Header "STEP 2: CREATE DATABASE TABLES"

Write-Host "Actions needed:" -ForegroundColor Green
Write-Host "1. In Supabase, open SQL Editor"
Write-Host "2. Click 'New Query'"
Write-Host "3. Open file: database_schema.sql"
Write-Host "   Location: " -NoNewline
Write-Host "Kuber TImesheet\database_schema.sql" -ForegroundColor Yellow
Write-Host "4. Copy entire contents"
Write-Host "5. Paste into Supabase SQL editor"
Write-Host "6. Click 'Run' button"
Write-Host "7. Wait for success message"
Write-Host ""

Write-Alert "This creates 4 tables and security policies"
Wait-For-User "Press Enter when database tables are created..."

Write-Done "Database schema deployed to Supabase"

# ============================================================================
# STEP 3
# ============================================================================
Write-Header "STEP 3: DEPLOY FRONTEND TO VERCEL"

Write-Host "Actions needed:" -ForegroundColor Green
Write-Host "1. Go to https://vercel.com"
Write-Host "2. Sign in with GitHub"
Write-Host "3. Click 'Add New' → 'Project'"
Write-Host "4. Find and click 'Kuber_Timesheet' repo"
Write-Host "5. Add Environment Variables:"
Write-Host "   • NEXT_PUBLIC_SUPABASE_URL = [from Step 1]"
Write-Host "   • NEXT_PUBLIC_SUPABASE_ANON_KEY = [from Step 1]"
Write-Host "   • SUPABASE_SERVICE_ROLE_KEY = [from Step 1]"
Write-Host "   • NEXT_PUBLIC_NEPALI_API_URL = (leave blank)"
Write-Host "6. Click 'Deploy'"
Write-Host "7. Wait 3-5 minutes"
Write-Host ""

Write-Alert "Save your Frontend URL when deployment completes"
Wait-For-User "Press Enter when frontend is deployed..."

$frontendUrl = Read-Host "Enter your Frontend URL (e.g., https://kuber-timesheet.vercel.app)"
Write-Done "Frontend deployed: $frontendUrl"

# ============================================================================
# STEP 4
# ============================================================================
Write-Header "STEP 4: DEPLOY PYTHON SERVICE"

Write-Host "Prerequisites:" -ForegroundColor Cyan
Write-Host "• Node.js installed (https://nodejs.org)"
Write-Host "• PowerShell with npm available"
Write-Host ""

# Check Node.js
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Alert "Node.js not found. Please install from https://nodejs.org"
    Write-Alert "Then run this script again"
    exit 1
}
Write-Done "Node.js found: $nodeVersion"

# Check Vercel CLI
$vercelVersion = vercel --version 2>$null
if (-not $vercelVersion) {
    Write-Host ""
    Write-Host "Installing Vercel CLI globally..." -ForegroundColor Yellow
    npm install -g vercel 2>&1 | Out-Null
    $vercelVersion = vercel --version 2>$null
}
Write-Done "Vercel CLI: $vercelVersion"

Write-Host ""
Write-Host "This will deploy services/nepali-date-service to Vercel" -ForegroundColor Green
Write-Host ""

Wait-For-User "Press Enter to start deployment..."

# Deploy Python service
$projectRoot = Get-Location
$pythonServicePath = Join-Path $projectRoot "services\nepali-date-service"

if (-not (Test-Path $pythonServicePath)) {
    Write-Alert "Python service not found at $pythonServicePath"
    exit 1
}

Write-Host "Deploying Python service..." -ForegroundColor Yellow
Set-Location $pythonServicePath

try {
    # Run vercel deployment with automated responses where possible
    Write-Host "Starting Vercel deployment..." -ForegroundColor Cyan
    vercel --prod
    
    $pythonServiceUrl = Read-Host "Enter your Python Service URL from Vercel (e.g., https://kuber-nepali-service.vercel.app)"
    Write-Done "Python service deployed: $pythonServiceUrl"
}
catch {
    Write-Alert "Error during deployment: $_"
}
finally {
    Set-Location $projectRoot
}

# ============================================================================
# STEP 5
# ============================================================================
Write-Header "STEP 5: CONNECT SERVICES"

Write-Host "Actions needed:" -ForegroundColor Green
Write-Host "1. Go to https://vercel.com → kuber-timesheet project"
Write-Host "2. Settings → Environment Variables"
Write-Host "3. Find: NEXT_PUBLIC_NEPALI_API_URL"
Write-Host "4. Update value to:"
Write-Host "   $pythonServiceUrl" -ForegroundColor Yellow
Write-Host "5. Click 'Save'"
Write-Host "6. Go to Deployments tab"
Write-Host "7. Click 'Redeploy' on latest"
Write-Host "8. Wait 2-3 minutes"
Write-Host ""

Wait-For-User "Press Enter when services are connected..."

# ============================================================================
# STEP 6 - TEST
# ============================================================================
Write-Header "TEST YOUR DEPLOYMENT"

Write-Host "1. Open browser:"
Write-Host "   $frontendUrl" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. You should see:"
Write-Host "   • Login page"
Write-Host "   • No error messages"
Write-Host ""
Write-Host "3. If there are errors:"
Write-Host "   • Press F12 to open browser console"
Write-Host "   • Check error details"
Write-Host "   • Verify environment variables"
Write-Host ""

Write-Done "User testing ready!"

# ============================================================================
# FINAL SUMMARY
# ============================================================================
Write-Header "DEPLOYMENT COMPLETE!"

Write-Host "Summary:" -ForegroundColor Green
Write-Host "[OK] Frontend URL: $frontendUrl"
Write-Host "[OK] Python Service: $pythonServiceUrl"
Write-Host "[OK] Database: Supabase"
Write-Host "[OK] Authentication: Supabase Auth"
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Admins create user accounts in Supabase"
Write-Host "2. Employees login and test clock in/out"
Write-Host "3. Monitor audit logs"
Write-Host ""

Write-Done "System is LIVE and ready for users!"
Write-Host ""
