# Kuber Timesheet Deployment - Step by Step Guide

## STEP 1: Supabase Setup
**What you need to do:**
1. Go to https://supabase.com
2. Create/access your project
3. Collect these 3 credentials:
   - Supabase Project URL (Settings > API)
   - Supabase Anon Key (Settings > API)
   - Supabase Service Role Key (Settings > API)

**What I'll need from you:**
- The 3 credentials above

---

## STEP 2: Create Database Schema
**What you need to do:**
1. In Supabase Dashboard, go to SQL Editor
2. Create a new query
3. Copy the entire contents of `database_schema.sql` from this project
4. Paste into Supabase SQL Editor
5. Click "Run"

**What I'll verify:**
- Database tables created successfully

---

## STEP 3: Deploy Frontend to Vercel
**What you need to do:**
1. Go to https://vercel.com
2. Import/connect your GitHub repository
3. Set environment variables:
   - NEXT_PUBLIC_SUPABASE_URL
   - NEXT_PUBLIC_SUPABASE_ANON_KEY
4. Deploy

**What I'll need from you:**
- Your Frontend Vercel URL (e.g., https://kuber-timesheet.vercel.app)

---

## STEP 4: Deploy Python Service to Vercel
**What you need to do:**
1. Push Python service code to GitHub
2. Create new Vercel project for Python service
3. Deploy Python service

**What I'll need from you:**
- Your Python Service Vercel URL (e.g., https://kuber-nepali-service.vercel.app)

---

## STEP 5: Connect Services
**What you need to do:**
1. In Vercel Frontend project settings
2. Add environment variable: `NEXT_PUBLIC_NEPALI_API_URL`
3. Set value to Python Service URL
4. Redeploy

**When complete:**
- System is live and ready for use

---

## Ready to start?
Reply with: **YES** when ready for STEP 1
