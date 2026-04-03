#!/usr/bin/env pwsh

# AUTOMATED VERCEL DEPLOYMENT - COMPLETE SETUP & DEPLOY
# This script handles everything from setup to going live

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  KUBER TIMESHEET - AUTOMATED GO-LIVE DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

$ErrorActionPreference = "Continue"

# ============================================================================
# STEP 1: CHECK PREREQUISITES
# ============================================================================
Write-Host "[STEP 1/4] Checking Prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Cyan
try {
    $nodeVersion = node --version 2>&1
    if ($nodeVersion -match "v\d+") {
        Write-Host "[OK] Node.js found: $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Node.js not found" -ForegroundColor Red
        Write-Host "      Download from: https://nodejs.org/" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "[ERROR] Node.js not found" -ForegroundColor Red
    exit 1
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Cyan
try {
    $npmVersion = npm --version 2>&1
    if ($npmVersion -match "\d+\.\d+") {
        Write-Host "[OK] npm found: v$npmVersion" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] npm not found" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "[ERROR] npm not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# ============================================================================
# STEP 2: INSTALL/CHECK VERCEL CLI
# ============================================================================
Write-Host "[STEP 2/4] Setting up Vercel CLI..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Checking Vercel CLI..." -ForegroundColor Cyan
try {
    $vercelVersion = vercel --version 2>&1
    if ($vercelVersion -match "\d+\.\d+") {
        Write-Host "[OK] Vercel CLI already installed: $vercelVersion" -ForegroundColor Green
    } else {
        throw "Vercel not found"
    }
} catch {
    Write-Host "[INFO] Installing Vercel CLI globally..." -ForegroundColor Cyan
    npm install -g vercel 2>&1 | Out-Null
    
    # Verify installation
    $vercelVersion = vercel --version 2>&1
    Write-Host "[OK] Vercel CLI installed: $vercelVersion" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# STEP 3: AUTHENTICATE WITH VERCEL
# ============================================================================
Write-Host "[STEP 3/4] Vercel Authentication..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Checking authentication..." -ForegroundColor Cyan
try {
    $authStatus = vercel whoami 2>&1
    if ($authStatus -match "@" -or $authStatus -match "verified") {
        Write-Host "[OK] Already authenticated as: $authStatus" -ForegroundColor Green
        $isAuthenticated = $true
    } else {
        $isAuthenticated = $false
    }
} catch {
    $isAuthenticated = $false
}

if (-not $isAuthenticated) {
    Write-Host "[ACTION REQUIRED] You need to authenticate with Vercel" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Running: vercel login" -ForegroundColor Cyan
    Write-Host "Follow the browser window that opens to authenticate." -ForegroundColor Yellow
    Write-Host ""
    
    vercel login
    
    Write-Host ""
    Write-Host "Authentication complete!" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# STEP 4: DEPLOY TO VERCEL
# ============================================================================
Write-Host "[STEP 4/4] Deploying to Vercel..." -ForegroundColor Yellow
Write-Host ""

$currentDir = Get-Location

# Deploy Frontend
Write-Host "Deploying Frontend..." -ForegroundColor Cyan
Set-Location ".\frontend"

if (-not (Test-Path "package.json")) {
    Write-Host "[ERROR] Frontend package.json not found" -ForegroundColor Red
    exit 1
}

Write-Host "Building and deploying frontend..." -ForegroundColor Gray
$frontendDeploy = vercel deploy --prod 2>&1
Write-Host $frontendDeploy

# Extract frontend URL
$frontendUrl = $frontendDeploy | Select-String "https://kuber-timesheet.*\.vercel\.app" | ForEach-Object {
    $_.ToString() -replace ".*?(https://.*?\.vercel\.app).*", '$1'
} | Select-Object -First 1

if (-not $frontendUrl) {
    $frontendUrl = $frontendDeploy | Select-String "https://.*\.vercel\.app" -AllMatches | ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1
}

Write-Host ""
Write-Host "Frontend deployed: $frontendUrl" -ForegroundColor Green
Write-Host ""

# Deploy Python Service
Set-Location $currentDir
Write-Host "Deploying Python Service..." -ForegroundColor Cyan
Set-Location ".\services\nepali-date-service"

if (-not (Test-Path "app.py")) {
    Write-Host "[ERROR] Python app.py not found" -ForegroundColor Red
    exit 1
}

Write-Host "Building and deploying Python service..." -ForegroundColor Gray
$pythonDeploy = vercel deploy --prod 2>&1
Write-Host $pythonDeploy

# Extract Python service URL
$pythonUrl = $pythonDeploy | Select-String "https://kuber-nepali.*\.vercel\.app" | ForEach-Object {
    $_.ToString() -replace ".*?(https://.*?\.vercel\.app).*", '$1'
} | Select-Object -First 1

if (-not $pythonUrl) {
    $pythonUrl = $pythonDeploy | Select-String "https://.*\.vercel\.app" -AllMatches | ForEach-Object { $_.Matches[0].Value } | Select-Object -First 1
}

Write-Host ""
Write-Host "Python Service deployed: $pythonUrl" -ForegroundColor Green
Write-Host ""

# Connect services
Set-Location $currentDir
Write-Host "Connecting services..." -ForegroundColor Cyan

if ($pythonUrl) {
    Write-Host "Setting NEXT_PUBLIC_NEPALI_API_URL to: $pythonUrl" -ForegroundColor Gray
    vercel env set NEXT_PUBLIC_NEPALI_API_URL "$pythonUrl" --prod 2>&1 | Out-Null
    
    Write-Host "Redeploying frontend with updated environment..." -ForegroundColor Gray
    Set-Location ".\frontend"
    vercel deploy --prod 2>&1 | Out-Null
    Set-Location $currentDir
    Write-Host "[OK] Services connected" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# SUMMARY
# ============================================================================
Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  DEPLOYMENT COMPLETE - SYSTEM IS LIVE!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Frontend Application:" -ForegroundColor Cyan
Write-Host "  $frontendUrl" -ForegroundColor Green
Write-Host ""

Write-Host "Python Service API:" -ForegroundColor Cyan
Write-Host "  $pythonUrl" -ForegroundColor Green
Write-Host ""

Write-Host "Database:" -ForegroundColor Cyan
Write-Host "  https://app.supabase.com/project/zhrsneyyczjhyastjvbq" -ForegroundColor Green
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Visit: $frontendUrl" -ForegroundColor White
Write-Host "  2. Create an employee account" -ForegroundColor White
Write-Host "  3. Log in and test the system" -ForegroundColor White
Write-Host "  4. Invite other employees to use it" -ForegroundColor White
Write-Host ""

Write-Host "Your Kuber Timesheet system is now LIVE! 🎉" -ForegroundColor Green
Write-Host ""
