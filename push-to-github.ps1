#!/usr/bin/env powershell
# Quick GitHub Push Script
# Instructions: 
#   1. Create repo on GitHub: https://github.com/new
#   2. Replace YOUR_GITHUB_URL below with your actual repo URL
#   3. Run this script in PowerShell

# Configuration
$GITHUB_URL = "https://github.com/YOUR_USERNAME/kuber-timesheet.git"  # CHANGE THIS
$PROJECT_PATH = "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"

Write-Host "🚀 Kuber Timesheet - GitHub Push Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to project
Write-Host "📁 Navigating to project..." -ForegroundColor Yellow
cd $PROJECT_PATH

# Initialize git
Write-Host "🔧 Initializing git repository..." -ForegroundColor Yellow
git init

# Add all files
Write-Host "📝 Staging all files..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Kuber Timesheet - Attendance tracking system

- Next.js 14 frontend with TypeScript & Tailwind
- Supabase authentication & PostgreSQL database
- Python FastAPI microservice for Nepali date conversions
- Complete attendance tracking (clock in/out, time rounding)
- Audit logging & Row-Level Security
- Documentation & deployment guides"

# Add remote
Write-Host "🔗 Adding GitHub remote..." -ForegroundColor Yellow
git remote add origin $GITHUB_URL

# Push to main
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "✅ Push Complete!" -ForegroundColor Green
Write-Host "📊 Your repository is now on GitHub" -ForegroundColor Green
Write-Host "🔗 URL: $GITHUB_URL" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Deploy to Vercel at https://vercel.com" -ForegroundColor Cyan
