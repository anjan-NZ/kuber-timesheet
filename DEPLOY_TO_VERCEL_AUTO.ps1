#!/usr/bin/env pwsh

# Automated Vercel Deployment Script
# This script deploys both Frontend and Python Service to Vercel

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  AUTOMATED VERCEL DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

# Check if Vercel CLI is installed
Write-Host "[CHECKING] Vercel CLI installation..." -ForegroundColor Cyan
$vercelCheck = vercel --version 2>$null
if (-not $vercelCheck) {
    Write-Host "[ERROR] Vercel CLI not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install it first:" -ForegroundColor Yellow
    Write-Host "  npm install -g vercel" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "[OK] Vercel CLI found: $vercelCheck" -ForegroundColor Green
Write-Host ""

# Check if user is authenticated
Write-Host "[CHECKING] Vercel authentication..." -ForegroundColor Cyan
$authCheck = vercel whoami 2>$null
if (-not $authCheck) {
    Write-Host "[REQUIRED] Vercel authentication needed" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Run this command to authenticate:" -ForegroundColor Yellow
    Write-Host "  vercel login" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again." -ForegroundColor Cyan
    exit 1
}

Write-Host "[OK] Authenticated as: $authCheck" -ForegroundColor Green
Write-Host ""

# ============================================================================
# DEPLOY FRONTEND
# ============================================================================
Write-Host "[STEP 1/2] Deploying Frontend to Vercel..." -ForegroundColor Yellow
Write-Host ""

cd ".\frontend" 2>$null
if (-not (Test-Path "package.json")) {
    Write-Host "[ERROR] Frontend package.json not found" -ForegroundColor Red
    exit 1
}

Write-Host "Deploying frontend..." -ForegroundColor Cyan
$frontendDeploy = vercel --prod --name kuber-timesheet 2>&1

Write-Host $frontendDeploy
Write-Host ""

# Extract URL from output
$frontendUrl = $frontendDeploy | Select-String "https://.*\.vercel\.app" -AllMatches | ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1

if ($frontendUrl) {
    Write-Host "[OK] Frontend deployed: $frontendUrl" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Could not extract frontend URL" -ForegroundColor Yellow
    $frontendUrl = "https://kuber-timesheet.vercel.app"
}

cd ".."
Write-Host ""

# ============================================================================
# DEPLOY PYTHON SERVICE
# ============================================================================
Write-Host "[STEP 2/2] Deploying Python Service to Vercel..." -ForegroundColor Yellow
Write-Host ""

cd ".\services\nepali-date-service" 2>$null
if (-not (Test-Path "app.py")) {
    Write-Host "[ERROR] Python app.py not found" -ForegroundColor Red
    exit 1
}

Write-Host "Deploying Python service..." -ForegroundColor Cyan
$pythonDeploy = vercel --prod --name kuber-nepali-service 2>&1

Write-Host $pythonDeploy
Write-Host ""

# Extract URL from output
$pythonUrl = $pythonDeploy | Select-String "https://.*\.vercel\.app" -AllMatches | ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1

if ($pythonUrl) {
    Write-Host "[OK] Python Service deployed: $pythonUrl" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Could not extract Python service URL" -ForegroundColor Yellow
    $pythonUrl = "https://kuber-nepali-service.vercel.app"
}

cd "..\.."
Write-Host ""

# ============================================================================
# UPDATE FRONTEND WITH PYTHON SERVICE URL
# ============================================================================
Write-Host "[STEP 3/2] Reconnecting Frontend to Python Service..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Green
Write-Host "Python Service URL: $pythonUrl" -ForegroundColor Green
Write-Host ""

# Update frontend env var
Write-Host "Updating frontend environment variable..." -ForegroundColor Cyan
$envUpdate = vercel env set NEXT_PUBLIC_NEPALI_API_URL "$pythonUrl" --prod 2>&1
Write-Host $envUpdate

# Redeploy frontend
Write-Host ""
Write-Host "Redeploying frontend with updated environment..." -ForegroundColor Cyan
cd ".\frontend"
$redeploy = vercel --prod 2>&1
Write-Host $redeploy
cd ".."

Write-Host ""

# ============================================================================
# SUMMARY
# ============================================================================
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Frontend URL:" -ForegroundColor Cyan
Write-Host "  $frontendUrl" -ForegroundColor Green
Write-Host ""

Write-Host "Python Service URL:" -ForegroundColor Cyan
Write-Host "  $pythonUrl" -ForegroundColor Green
Write-Host ""

Write-Host "Your system is now LIVE! 🎉" -ForegroundColor Green
Write-Host ""
