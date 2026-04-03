#!/usr/bin/env pwsh
# Script to receive and store Supabase credentials

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  SUPABASE CREDENTIALS SETUP" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Input Anon Key
Write-Host "Enter your ANON KEY (starts with eyJhbGci...):" -ForegroundColor Yellow
$anonKey = Read-Host "Anon Key"

# Validate Anon Key
if ($anonKey -notmatch "^eyJhbGci") {
    Write-Host "[ERROR] Invalid Anon Key - should start with 'eyJhbGci'" -ForegroundColor Red
    exit 1
}

# Input Service Role Key
Write-Host ""
Write-Host "Enter your SERVICE_ROLE KEY (starts with eyJhbGci...):" -ForegroundColor Yellow
$serviceRoleKey = Read-Host "Service Role Key"

# Validate Service Role Key
if ($serviceRoleKey -notmatch "^eyJhbGci") {
    Write-Host "[ERROR] Invalid Service Role Key - should start with 'eyJhbGci'" -ForegroundColor Red
    exit 1
}

# Create .env.local
$supabaseUrl = "https://zhrsneyyczjhyastjvbq.supabase.co"
$envContent = @"
NEXT_PUBLIC_SUPABASE_URL=$supabaseUrl
NEXT_PUBLIC_SUPABASE_ANON_KEY=$anonKey
SUPABASE_SERVICE_ROLE_KEY=$serviceRoleKey
NEXT_PUBLIC_NEPALI_API_URL=https://kuber-nepali-service.vercel.app
"@

# Save to file
$envPath = "frontend\.env.local"
try {
    if (!(Test-Path "frontend")) {
        New-Item -ItemType Directory -Path "frontend" -Force | Out-Null
    }
    $envContent | Out-File -FilePath $envPath -Encoding UTF8 -Force
    Write-Host ""
    Write-Host "[OK] Credentials saved to: $envPath" -ForegroundColor Green
    Write-Host "[OK] Environment file created successfully" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to save credentials: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  STEP 1 COMPLETE - Ready for Step 2" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Execute database schema in Supabase" -ForegroundColor Cyan
Write-Host ""
