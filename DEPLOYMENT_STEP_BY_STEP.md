# Kuber Timesheet - Step-by-Step Deployment Guide

**Total Time: ~30 minutes**

---

## STEP 1: Supabase Project Setup (5 minutes)

### 1.1 Create Supabase Project

1. Go to [https://app.supabase.com](https://app.supabase.com)
2. Sign in (or create account)
3. Click **"New project"**
   - Organization: Select or create
   - **Project name:** `Kuber_Timesheet`
   - **Database Password:** Create strong password (save it!)
   - **Region:** Select closest to you (e.g., Singapore for Asia)
4. Click **"Create new project"** and wait 2-3 minutes

### 1.2 Get Your Credentials

Once project loads:

1. Go to **Settings → API** (left sidebar)
2. **Copy and save these 3 values:**
   ```
   PROJECT_URL = [Your Project URL - looks like https://xxxxx.supabase.co]
   ANON_KEY = [Your Anon Key]
   SERVICE_ROLE_KEY = [Your Service Role Key - KEEP SECRET!]
   ```
3. Keep these handy - you'll need them for next steps

---

## STEP 2: Create Database Tables & Schema (3 minutes)

### 2.1 Execute SQL in Supabase

1. In Supabase, go to **SQL Editor** (left sidebar)
2. Click **"New Query"**
3. **Copy entire contents** of `database_schema.sql` (in your project folder)
4. **Paste it** into the SQL editor
5. Click **"Run"** button (play icon at top)
6. Wait for success message ✅

**What this does:**
- Creates 4 tables: users, attendance_records, holidays, audit_logs
- Sets up security policies (Row-Level Security)
- Creates indexes for performance
- Sets up automatic timestamp updates

---

## STEP 3: Deploy Frontend to Vercel (8 minutes)

### 3.1 Connect GitHub to Vercel

1. Go to [https://vercel.com](https://vercel.com)
2. Sign in with GitHub
3. Click **"Add New..."** → **"Project"**
4. Find **`Kuber_Timesheet`** repository in the list
5. Click **"Import"**

### 3.2 Configure Environment Variables

Vercel will show: **"Configure Project"**

1. Under **Environment Variables**, add these:
   ```
   NEXT_PUBLIC_SUPABASE_URL = [Your PROJECT_URL from Step 1.2]
   NEXT_PUBLIC_SUPABASE_ANON_KEY = [Your ANON_KEY from Step 1.2]
   SUPABASE_SERVICE_ROLE_KEY = [Your SERVICE_ROLE_KEY from Step 1.2]
   NEXT_PUBLIC_NEPALI_API_URL = [Leave blank for now - will update in Step 5]
   ```

2. Click **"Deploy"**
3. Wait 3-5 minutes for deployment to complete ✅

**Your Frontend URL:** Vercel shows this after deployment (e.g., `https://kuber-timesheet.vercel.app`)

---

## STEP 4: Create Python Service Deployment (8 minutes)

### 4.1 Prepare Python Service

The Python service is in: `services/nepali-date-service/`

You need to deploy it to Vercel as a serverless function.

1. In your local folder, open terminal
2. Run commands to prepare:
   ```powershell
   cd "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"
   ```

### 4.2 Deploy Python to Vercel

**Option A: Deploy with Vercel CLI (Recommended)**

1. Install Vercel CLI:
   ```powershell
   npm install -g vercel
   ```

2. Deploy Python service:
   ```powershell
   cd services\nepali-date-service
   vercel --prod
   ```

3. When prompted:
   - Link to Vercel account? **Yes**
   - Use existing project? **No**
   - Project name: `kuber-nepali-service`
   - Deploy? **Yes**

4. Wait for deployment ✅

**Your Python Service URL:** Vercel will show this after deployment (e.g., `https://kuber-nepali-service.vercel.app`)

---

## STEP 5: Connect Services (5 minutes)

### 5.1 Update Frontend with Python Service URL

1. Go to **Vercel Dashboard**
2. Select **`kuber-timesheet`** project
3. Go to **Settings → Environment Variables**
4. Find **`NEXT_PUBLIC_NEPALI_API_URL`**
5. Update value to: `https://kuber-nepali-service.vercel.app`
6. **Deploy again** to apply changes

### 5.2 Trigger Redeployment

In Vercel dashboard:
1. Select **`kuber-timesheet`** project
2. Go to **Deployments**
3. Click **"Redeploy"** on latest deployment ✅

---

## STEP 6: Test Deployment (2 minutes)

1. Go to your Frontend URL: `https://kuber-timesheet.vercel.app`
2. You should see the login page
3. Try to login (or wait for admin to create test accounts in Supabase)

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Database tables not created | Check SQL syntax in Step 2 - look for red error messages |
| "Cannot find Supabase" error | Environment variables not set correctly - double-check in Step 3.2 |
| Frontend shows blank page | Check browser console (F12) for errors |
| Python service 404 error | Make sure URL is set correctly in Step 5 |
| Login page won't load | Supabase project may not be ready - wait 2 minutes and refresh |

---

## Next Steps After Deployment

1. **Admin Account Setup**
   - In Supabase, go to **Authentication → Users**
   - Create admin user (you'll need to manually set role to 'admin' in users table)

2. **Create Test Employees**
   - Go to **Supabase → Users table**
   - Add employees manually or via your admin dashboard

3. **Test Clock In/Out**
   - Go to `https://kuber-timesheet.vercel.app`
   - Login as employee
   - Click "Clock In"
   - Click "Clock Out"
   - Check audit logs in Supabase

---

**Questions? Check the logs:**
- Frontend errors: Browser Console (F12)
- Deployment errors: Vercel Dashboard → Deployments
- Database errors: Supabase → SQL Editor (history)
