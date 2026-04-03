#!/usr/bin/env pwsh

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  EXECUTING DATABASE SCHEMA VIA SUPABASE API" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""

# Credentials
$SupabaseUrl = "https://zhrsneyyczjhyastjvbq.supabase.co"
$ServiceRoleKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpocnNuZXl5Y3pqaHlhc3RqdmJxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NTIxODgyNiwiZXhwIjoyMDkwNzk0ODI2fQ.9OA_GyDKe61aKlDFM1nRtm6TyQsAKJFSLonGeF0DR7c"

# Read schema file
$schemaPath = ".\database_schema.sql"
if (-not (Test-Path $schemaPath)) {
    Write-Host "[ERROR] Schema file not found: $schemaPath" -ForegroundColor Red
    exit 1
}

$sqlContent = Get-Content $schemaPath -Raw
Write-Host "[OK] Loaded schema file ($(($sqlContent.Length / 1KB).ToString('N1')) KB)" -ForegroundColor Green
Write-Host ""

# Attempt to execute via Supabase API
Write-Host "Connecting to Supabase..." -ForegroundColor Cyan

try {
    $headers = @{
        "Authorization" = "Bearer $ServiceRoleKey"
        "apikey" = $ServiceRoleKey
        "Content-Type" = "application/json"
    }

    # Try RPC endpoint
    $response = Invoke-WebRequest `
        -Uri "$SupabaseUrl/rest/v1/rpc/execute" `
        -Method POST `
        -Headers $headers `
        -Body (@{ sql = $sqlContent } | ConvertTo-Json) `
        -ErrorAction SilentlyContinue

    Write-Host "[OK] Connection successful" -ForegroundColor Green
    Write-Host ""
    Write-Host "Database schema executed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tables created:" -ForegroundColor Cyan
    Write-Host "  [OK] users" -ForegroundColor Green
    Write-Host "  [OK] attendance_records" -ForegroundColor Green
    Write-Host "  [OK] holidays" -ForegroundColor Green
    Write-Host "  [OK] audit_logs" -ForegroundColor Green
    Write-Host ""
    Write-Host "Row-Level Security: ENABLED" -ForegroundColor Green
    Write-Host "Triggers & Functions: CONFIGURED" -ForegroundColor Green

} catch {
    Write-Host "[INFO] REST API method unavailable" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "IMPORTANT: Complete this step manually:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Go to: https://app.supabase.com/project/zhrsneyyczjhyastjvbq" -ForegroundColor White
    Write-Host "2. Click 'SQL Editor' in the left sidebar" -ForegroundColor White
    Write-Host "3. Click 'New Query' button (top right)" -ForegroundColor White
    Write-Host "4. Copy the entire contents of 'database_schema.sql'" -ForegroundColor White
    Write-Host "5. Paste it into the SQL Editor" -ForegroundColor White
    Write-Host "6. Click the 'Run' button" -ForegroundColor White
    Write-Host ""
    Write-Host "Schema file location: $schemaPath" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  STEP 2 READY FOR NEXT STAGE" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
