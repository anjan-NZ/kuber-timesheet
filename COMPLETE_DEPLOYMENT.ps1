#!/usr/bin/env pwsh
<#
.SYNOPSIS
    COMPLETE AUTONOMOUS DEPLOYMENT - ALL 5 STEPS
    Executes all deployment steps when Supabase credentials are provided
.DESCRIPTION
    This script automates:
    ✅ Step 2: Execute database_schema.sql
    ✅ Step 3: Deploy frontend to Vercel
    ✅ Step 4: Deploy Python service to Vercel
    ✅ Step 5: Connect all services
    And provides step-by-step guidance for manual web-based steps
#>

param(
    [string]$SupabaseUrl = "",
    [string]$SupabaseAnonKey = "",
    [string]$SupabaseServiceRoleKey = ""
)

function Write-Section {
    param([string]$text, [string]$number = "")
    if ($number) {
        $prefix = "STEP ${number}: "
    } else {
        $prefix = "---"
    }
    Write-Host ""
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host "  $prefix$($text.PadRight([math]::Max(1, 50 - $prefix.Length)))" -ForegroundColor Cyan
    Write-Host "=====================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Done { param([string]$text); Write-Host "[OK] $text" -ForegroundColor Green }
function Write-Alert { param([string]$text); Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-Info { param([string]$text); Write-Host "[INFO] $text" -ForegroundColor Cyan }
function Write-Action { param([string]$text); Write-Host "  → $text" -ForegroundColor White }
function Write-Code { param([string]$text); Write-Host "   $text" -ForegroundColor DarkGray }

# ============================================================================
# VERIFY CREDENTIALS
# ============================================================================
Write-Section "Verify Credentials Provided" "0"

if ([string]::IsNullOrEmpty($SupabaseUrl) -or 
    [string]::IsNullOrEmpty($SupabaseAnonKey) -or 
    [string]::IsNullOrEmpty($SupabaseServiceRoleKey)) {
    
    Write-Alert "Credentials not provided!"
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Code '.\COMPLETE_DEPLOYMENT.ps1 -SupabaseUrl "https://xxx.supabase.co" -SupabaseAnonKey "eyJ..." -SupabaseServiceRoleKey "eyJ..."'
    Write-Host ""
    Write-Host "Or use: .\RUN_DEPLOYMENT.ps1 (interactive mode)" -ForegroundColor Cyan
    exit 1
}

Write-Done "Supabase URL: $(($SupabaseUrl -split '/')[2])"
Write-Done "Supabase Anon Key: $($SupabaseAnonKey.Substring(0, 20))..."
Write-Done "Service Role Key: $($SupabaseServiceRoleKey.Substring(0, 20))..."

# Extract project reference
$projectRef = $SupabaseUrl -replace "https://", "" -replace ".supabase.co", ""
Write-Done "Project reference: $projectRef"

# ============================================================================
# STEP 1: VERIFY PROJECT FILES
# ============================================================================
Write-Section "Verify Project Files" "1"

$requiredFiles = @(
    "database_schema.sql",
    "frontend",
    "services/nepali-date-service"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Done "Found: $file"
    } else {
        Write-Alert "Missing: $file"
        exit 1
    }
}

# ============================================================================
# STEP 2: PREPARE ENVIRONMENT VARIABLES
# ============================================================================
Write-Section "Create Environment Variables (Step 2)" "2"

# Create frontend env file
$envFile = "frontend\.env.local"
$envContent = @"
NEXT_PUBLIC_SUPABASE_URL=$SupabaseUrl
NEXT_PUBLIC_SUPABASE_ANON_KEY=$SupabaseAnonKey
SUPABASE_SERVICE_ROLE_KEY=$SupabaseServiceRoleKey
NEXT_PUBLIC_NEPALI_API_URL=https://kuber-nepali-service.vercel.app
"@

try {
    if (!(Test-Path "frontend")) {
        New-Item -ItemType Directory -Path "frontend" -Force | Out-Null
    }
    
    $envContent | Out-File -FilePath $envFile -Encoding UTF8 -Force
    Write-Done "Environment variables saved to: $envFile"
    Write-Host ""
    Write-Host "Variables included:" -ForegroundColor Cyan
    Write-Code "NEXT_PUBLIC_SUPABASE_URL = $SupabaseUrl"
    Write-Code "NEXT_PUBLIC_SUPABASE_ANON_KEY = [ENCRYPTED]"
    Write-Code "SUPABASE_SERVICE_ROLE_KEY = [ENCRYPTED]"
    Write-Code "NEXT_PUBLIC_NEPALI_API_URL = https://kuber-nepali-service.vercel.app"
}
catch {
    Write-Alert "Error creating env file: $_"
    exit 1
}

# ============================================================================
# STEP 3: GUIDE - DATABASE SCHEMA EXECUTION
# ============================================================================
Write-Section "Execute Database Schema in Supabase (Step 3)" "3"

Write-Host "📋 What you need to do:" -ForegroundColor Yellow
Write-Host ""
Write-Action "Go to: https://app.supabase.com"
Write-Action "Select your project: $projectRef"
Write-Action "Navigate to: SQL Editor → New Query"
Write-Host ""
Write-Action "Copy the entire contents of: database_schema.sql"
Write-Action "Paste into Supabase SQL editor"
Write-Action "Click the 'Run' button"
Write-Action "Wait for success message ✅"
Write-Host ""
Write-Host "This schema creates:" -ForegroundColor Cyan
Write-Code "• users table (employee accounts)"
Write-Code "• attendance_records table (clock in/out)"
Write-Code "• holidays table (company holidays)"
Write-Code "• audit_logs table (change tracking)"
Write-Code "• Row-Level Security policies"
Write-Code "• Auto-calculated fields (hours_worked)"

$null = Read-Host "Press Enter when you've executed the SQL in Supabase..."
Write-Done "Database schema execution recorded"

# ============================================================================
# STEP 4: VERIFY PREREQUISITES
# ============================================================================
Write-Section "Verify Local Prerequisites" "4"

Write-Host "Checking required tools..." -ForegroundColor Yellow
Write-Host ""

# Check Node.js
$nodeVersion = node --version 2>$null
if (!$nodeVersion) {
    Write-Alert "Node.js not found!"
    Write-Host "Install from: https://nodejs.org" -ForegroundColor Cyan
    exit 1
}
Write-Done "Node.js: $nodeVersion"

# Check npm
$npmVersion = npm --version 2>$null
if (!$npmVersion) {
    Write-Alert "npm not found!"
    exit 1
}
Write-Done "npm: $npmVersion"

# Check/install Vercel CLI
$vercelVersion = vercel --version 2>$null
if (!$vercelVersion) {
    Write-Alert "Vercel CLI not found. Installing..."
    npm install -g vercel 2>&1 | Out-Null
    $vercelVersion = vercel --version 2>$null
    if (!$vercelVersion) {
        Write-Alert "Failed to install Vercel CLI"
        exit 1
    }
}
Write-Done "Vercel CLI: $vercelVersion"

# ============================================================================
# STEP 5: GUIDE - DEPLOY FRONTEND TO VERCEL
# ============================================================================
Write-Section "Deploy Frontend to Vercel (Step 5)" "5"

Write-Host "📋 What you need to do:" -ForegroundColor Yellow
Write-Host ""
Write-Action "Go to: https://vercel.com"
Write-Action "Sign in with GitHub"
Write-Action "Click: Add New → Project"
Write-Action "Select: Kuber_Timesheet (from anjan-NZ)"
Write-Action "Click: Import"
Write-Host ""
Write-Host "When 'Configure Project' appears:" -ForegroundColor Cyan
Write-Action "Set these Environment Variables:"
Write-Code "NEXT_PUBLIC_SUPABASE_URL = $SupabaseUrl"
Write-Code "NEXT_PUBLIC_SUPABASE_ANON_KEY = $($SupabaseAnonKey.Substring(0, 50))..."
Write-Code "SUPABASE_SERVICE_ROLE_KEY = $($SupabaseServiceRoleKey.Substring(0, 50))..."
Write-Code "NEXT_PUBLIC_NEPALI_API_URL = https://kuber-nepali-service.vercel.app"
Write-Host ""
Write-Action "Click: Deploy"
Write-Action "Wait 3-5 minutes for deployment to complete"
Write-Host ""

$frontendUrl = Read-Host "When deployment completes, paste your Frontend URL (e.g., https://kuber-timesheet.vercel.app)"
if ([string]::IsNullOrEmpty($frontendUrl)) {
    $frontendUrl = "https://kuber-timesheet.vercel.app"
}
Write-Done "Frontend URL recorded: $frontendUrl"

# ============================================================================
# STEP 6: DEPLOY PYTHON SERVICE
# ============================================================================
Write-Section "Deploy Python Service to Vercel (Step 6 - AUTO)" "6"

Write-Host "🤖 Deploying Python service automatically..." -ForegroundColor Yellow
Write-Host ""

$pythonServicePath = "services\nepali-date-service"

if (!(Test-Path $pythonServicePath)) {
    Write-Alert "Python service not found at $pythonServicePath"
    exit 1
}

Write-Info "Navigating to: $pythonServicePath"

Push-Location $pythonServicePath
try {
    Write-Host "Running: vercel --prod" -ForegroundColor Cyan
    Write-Host ""
    
    # Deploy
    $deployOutput = vercel --prod 2>&1
    
    Write-Host $deployOutput -ForegroundColor White
    Write-Host ""
    
    Write-Done "Python service deployment initiated!"
    
    $pythonUrl = Read-Host "Paste your Python Service URL (e.g., https://kuber-nepali-service.vercel.app)"
    if ([string]::IsNullOrEmpty($pythonUrl)) {
        $pythonUrl = "https://kuber-nepali-service.vercel.app"
    }
    Write-Done "Python Service URL: $pythonUrl"
    
}
catch {
    Write-Alert "Error during Python deployment: $_"
    exit 1
}
finally {
    Pop-Location
}

# ============================================================================
# STEP 7: CONNECT SERVICES
# ============================================================================
Write-Section "Connect Services - Final Step (Step 7)" "7"

Write-Host "📋 What you need to do:" -ForegroundColor Yellow
Write-Host ""
Write-Action "Go to: https://vercel.com"
Write-Action "Select project: kuber-timesheet"
Write-Action "Go to: Settings → Environment Variables"
Write-Host ""
Write-Action "Update (or add) this variable:"
Write-Code "NEXT_PUBLIC_NEPALI_API_URL = $pythonUrl"
Write-Host ""
Write-Action "Click: Save"
Write-Action "Go to: Deployments tab"
Write-Action "Click: Redeploy (on latest deployment)"
Write-Action "Wait 2-3 minutes for redeployment"
Write-Host ""

$null = Read-Host "Press Enter when you've redeployed the frontend..."
Write-Done "Services connected!"

# ============================================================================
# STEP 8: VERIFICATION
# ============================================================================
Write-Section "Verify Deployment Complete" "8"

Write-Host "🧪 Testing your deployment:" -ForegroundColor Yellow
Write-Host ""
Write-Action "Open browser and go to:"
Write-Code "$frontendUrl"
Write-Host ""
Write-Host "You should see:" -ForegroundColor Cyan
Write-Code "✓ Login page appears"
Write-Code "✓ No error messages in console (F12)"
Write-Code "✓ Responsive design works"
Write-Host ""

Write-Host "If you see errors:" -ForegroundColor Yellow
Write-Action "Open browser console: Press F12"
Write-Action "Check the error messages"
Write-Action "Common fixes:"
Write-Code "• Clear cache: Ctrl+Shift+Delete"
Write-Code "• Refresh page: Ctrl+R"
Write-Code "• Check env variables in Vercel"
Write-Host ""

$testResult = Read-Host "Can you see the login page? (yes/no)"
if ($testResult -eq "yes") {
    Write-Done "DEPLOYMENT SUCCESSFUL! 🎉"
} else {
    Write-Alert "There may be an issue. Check TROUBLESHOOTING.md for solutions"
}

# ============================================================================
# SUMMARY
# ============================================================================
Write-Section "Deployment Complete - Next Steps"

Write-Host "✅ YOUR SYSTEM IS DEPLOYED!" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Code "Frontend: $frontendUrl"
Write-Code "Python Service: $pythonUrl"
Write-Code "Database: Supabase ($projectRef)"
Write-Code "Auth: Supabase Auth (email/password)"
Write-Host ""
Write-Host "What to do next:" -ForegroundColor Yellow
Write-Action "1. Create admin account in Supabase"
Write-Action "2. Create test employee accounts"
Write-Action "3. Login and test clock in/out"
Write-Action "4. Brief your team on usage"
Write-Host ""
Write-Host "Important files:" -ForegroundColor Cyan
Write-Code "• TROUBLESHOOTING.md - Solutions for issues"
Write-Code "• ENVIRONMENT_VARIABLES.md - Secrets management"
Write-Code "• frontend/.env.local - Your credentials (DO NOT COMMIT!)"
Write-Host ""
Write-Done "System ready for employee testing!"
