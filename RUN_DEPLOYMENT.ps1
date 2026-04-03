#!/usr/bin/env pwsh
<#
.SYNOPSIS
    DO-IT-ALL Deployment Runner
    Executes complete deployment when you provide credentials
.USAGE
    .\RUN_DEPLOYMENT.ps1
    Then provide credentials when prompted
#>

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  KUBER TIMESHEET - COMPLETE DEPLOYMENT EXECUTION           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# COLLECT CREDENTIALS
# ============================================================================
Write-Host "📋 STEP 1: COLLECT YOUR SUPABASE CREDENTIALS" -ForegroundColor Yellow
Write-Host ""
Write-Host "Go to https://app.supabase.com → Your Project → Settings → API" -ForegroundColor Cyan
Write-Host ""
Write-Host "Then paste the values below:" -ForegroundColor Green
Write-Host ""

$url = Read-Host "SUPABASE_URL (e.g., https://xxxxx.supabase.co)"
$anonKey = Read-Host "SUPABASE_ANON_KEY"
$serviceRoleKey = Read-Host "SUPABASE_SERVICE_ROLE_KEY"

# Validate credentials
if ([string]::IsNullOrEmpty($url) -or 
    [string]::IsNullOrEmpty($anonKey) -or 
    [string]::IsNullOrEmpty($serviceRoleKey)) {
    
    Write-Host "❌ Missing credentials!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Credentials received!" -ForegroundColor Green
Write-Host ""

# ============================================================================
# VERIFY PREREQUISITES
# ============================================================================
Write-Host "🔍 STEP 2: VERIFY PREREQUISITES" -ForegroundColor Yellow
Write-Host ""

# Check Node.js
$nodeVersion = node --version 2>$null
if (!$nodeVersion) {
    Write-Host "❌ Node.js not found!" -ForegroundColor Red
    Write-Host "Install from: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green

# Check npm
$npmVersion = npm --version 2>$null
if (!$npmVersion) {
    Write-Host "❌ npm not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ npm: $npmVersion" -ForegroundColor Green

# Check Vercel CLI
$vercelVersion = vercel --version 2>$null
if (!$vercelVersion) {
    Write-Host "⚙️  Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel 2>&1 | Out-Null
    $vercelVersion = vercel --version 2>$null
}
Write-Host "✅ Vercel CLI: $vercelVersion" -ForegroundColor Green

# Check database_schema.sql
if (!(Test-Path "database_schema.sql")) {
    Write-Host "❌ database_schema.sql not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Database schema file found" -ForegroundColor Green

# Check frontend
if (!(Test-Path "frontend")) {
    Write-Host "❌ frontend folder not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Frontend folder found" -ForegroundColor Green

# Check services
if (!(Test-Path "services/nepali-date-service")) {
    Write-Host "❌ Python service not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Python service found" -ForegroundColor Green

Write-Host ""

# ============================================================================
# SHOW ACTION PLAN
# ============================================================================
Write-Host "📋 DEPLOYMENT PLAN:" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ What I'LL do automatically:" -ForegroundColor Green
Write-Host "  1. Create environment variable files"
Write-Host "  2. Deploy Python service to Vercel"
Write-Host "  3. Provide deployment verification"
Write-Host ""
Write-Host "⏳ What YOU need to do manually:" -ForegroundColor Yellow
Write-Host "  1. Execute database_schema.sql in Supabase SQL Editor"
Write-Host "  2. Deploy frontend to Vercel (import GitHub repo)"
Write-Host "  3. Connect services (update env variables in Vercel)"
Write-Host ""

# ============================================================================
# RUN AUTOMATED DEPLOYMENT
# ============================================================================
Write-Host "🚀 STARTING AUTOMATED DEPLOYMENT..." -ForegroundColor Cyan
Write-Host ""

# Run the automated deployment script
.\AUTOMATED_DEPLOYMENT.ps1 `
    -SupabaseUrl $url `
    -SupabaseAnonKey $anonKey `
    -SupabaseServiceRoleKey $serviceRoleKey

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  DEPLOYMENT READY FOR COMPLETION                          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
