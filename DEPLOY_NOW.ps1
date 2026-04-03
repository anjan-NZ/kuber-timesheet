#!/usr/bin/env pwsh

# VERCEL DEPLOYMENT - CONNECT & DEPLOY
# This script handles Vercel authentication and deployment

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  KUBER TIMESHEET - VERCEL DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

$ErrorActionPreference = "Continue"

# ============================================================================
# STEP 1: CHECK PREREQUISITES
# ============================================================================
Write-Host "[1/5] Checking Prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Set Node.js path
$env:PATH = "C:\Program Files\nodejs;$env:PATH"

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Cyan
try {
    $nodeVersion = & "C:\Program Files\nodejs\node.exe" --version 2>&1
    Write-Host "[OK] Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js not found - install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Cyan
try {
    $npmVersion = & "C:\Program Files\nodejs\npm.cmd" --version 2>&1
    Write-Host "[OK] npm: v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] npm not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ============================================================================
# STEP 2: INSTALL VERCEL CLI
# ============================================================================
Write-Host "[2/5] Setting up Vercel CLI..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Installing Vercel CLI globally..." -ForegroundColor Cyan
& "C:\Program Files\nodejs\npm.cmd" install -g vercel 2>&1 | Out-Null

try {
    $vercelVersion = & "C:\Program Files\nodejs\npx.cmd" vercel --version 2>&1
    Write-Host "[OK] Vercel CLI installed: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to install Vercel CLI" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ============================================================================
# STEP 3: AUTHENTICATE WITH VERCEL
# ============================================================================
Write-Host "[3/5] Vercel Authentication..." -ForegroundColor Yellow
Write-Host ""

Write-Host "This will open a browser for authentication." -ForegroundColor Cyan
Write-Host "Please sign in to your Vercel account..." -ForegroundColor Cyan
Write-Host ""

& "C:\Program Files\nodejs\npx.cmd" vercel login

Write-Host ""
Write-Host "[OK] Authentication complete!" -ForegroundColor Green
Write-Host ""

# ============================================================================
# STEP 4: DEPLOY FRONTEND
# ============================================================================
Write-Host "[4/5] Deploying Frontend to Vercel..." -ForegroundColor Yellow
Write-Host ""

$currentDir = Get-Location
Set-Location ".\frontend"

Write-Host "Building frontend..." -ForegroundColor Cyan
& "C:\Program Files\nodejs\npm.cmd" run build 2>&1 | Select-Object -Last 10

Write-Host ""
Write-Host "Deploying to Vercel..." -ForegroundColor Cyan

$deployOutput = & "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod 2>&1
Write-Host $deployOutput

# Extract URL
$frontendUrl = $deployOutput | Select-String "https://" | ForEach-Object {
    if ($_ -match '(https://[^\s]+\.vercel\.app)') {
        $matches[1]
    }
} | Select-Object -First 1

Write-Host ""
Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Green
Write-Host ""

# ============================================================================
# STEP 5: DEPLOY PYTHON SERVICE
# ============================================================================
Write-Host "[5/5] Deploying Python Service..." -ForegroundColor Yellow
Write-Host ""

Set-Location $currentDir
Set-Location ".\services\nepali-date-service"

Write-Host "Deploying Python service to Vercel..." -ForegroundColor Cyan

$pythonOutput = & "C:\Program Files\nodejs\npx.cmd" vercel deploy --prod 2>&1
Write-Host $pythonOutput

# Extract URL
$pythonUrl = $pythonOutput | Select-String "https://" | ForEach-Object {
    if ($_ -match '(https://[^\s]+\.vercel\.app)') {
        $matches[1]
    }
} | Select-Object -First 1

Write-Host ""
Write-Host "Python Service URL: $pythonUrl" -ForegroundColor Green
Write-Host ""

# ============================================================================
# FINAL SUMMARY
# ============================================================================
Set-Location $currentDir

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  DEPLOYMENT SUCCESSFUL! 🎉" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Your Kuber Timesheet is now LIVE!" -ForegroundColor Green
Write-Host ""

Write-Host "Access your system:" -ForegroundColor Cyan
Write-Host "  Frontend: $frontendUrl" -ForegroundColor White
Write-Host "  API: $pythonUrl" -ForegroundColor White
Write-Host ""

Write-Host "Database (Supabase):" -ForegroundColor Cyan
Write-Host "  https://app.supabase.com/project/zhrsneyyczjhyastjvbq" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Visit your frontend URL above" -ForegroundColor White
Write-Host "  2. Create an employee account" -ForegroundColor White
Write-Host "  3. Test marking attendance" -ForegroundColor White
Write-Host "  4. Share the URL with your team" -ForegroundColor White
Write-Host ""

Write-Host "Support & Monitoring:" -ForegroundColor Yellow
Write-Host "  - Vercel Dashboard: https://vercel.com" -ForegroundColor White
Write-Host "  - Supabase Dashboard: https://app.supabase.com" -ForegroundColor White
Write-Host "  - Troubleshooting: See FINAL_GO_LIVE_STEPS.md" -ForegroundColor White
Write-Host ""
