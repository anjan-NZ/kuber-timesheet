# Step 1: Supabase Credentials Setup
# Run this after you create your Supabase project and collect credentials

# INSTRUCTIONS:
# 1. Go to https://app.supabase.com
# 2. Create new project named "Kuber_Timesheet"
# 3. Go to Settings → API
# 4. Copy the 3 values below

# Fill in these values from Supabase Settings → API
$SUPABASE_URL = "YOUR_PROJECT_URL"  # e.g., https://xxxxx.supabase.co
$SUPABASE_ANON_KEY = "YOUR_ANON_KEY"
$SUPABASE_SERVICE_ROLE = "YOUR_SERVICE_ROLE_KEY"

# Display for verification
Write-Host "=== Supabase Credentials ===" -ForegroundColor Cyan
Write-Host "Project URL: $SUPABASE_URL"
Write-Host "Anon Key: $($SUPABASE_ANON_KEY.Substring(0,20))..."
Write-Host "Service Role Key: $($SUPABASE_SERVICE_ROLE.Substring(0,20))..."
Write-Host ""
Write-Host "✅ When ready, save these to a secure location" -ForegroundColor Green
Write-Host "⚠️  NEVER commit these to GitHub!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next: Go to STEP 2 - Execute database_schema.sql in Supabase SQL Editor"
