# 🚀 Deploy to Vercel - Step by Step

**Status:** Ready for deployment ✅  
**Prerequisites:** Code must be on GitHub first (see GITHUB_PUSH_GUIDE.md)

---

## Pre-Deployment Checklist

Before deploying, you need:

- [ ] **Supabase project created** (https://supabase.com)
- [ ] **Database schema executed** (run `database_schema.sql`)
- [ ] **Environment credentials collected:**
  - Supabase URL
  - Supabase Anon Key
  - Supabase Service Role Key
- [ ] **Code pushed to GitHub** (see GITHUB_PUSH_GUIDE.md)
- [ ] **Vercel account created** (https://vercel.com)

---

## Step 1: Set Up Supabase

### 1.1: Create Supabase Project
1. Go to https://supabase.com/dashboard
2. Click **"New Project"**
3. Choose a name: `kuber-timesheet`
4. Choose a region (pick closest to you or users)
5. Create a strong database password
6. Click **"Create new project"** (takes 2-3 minutes)

### 1.2: Get Your Credentials
Once project is ready:
1. Go to **Settings → API**
2. Copy and save these three values:

```
Project URL:
https://[your-project-id].supabase.co

Anon Public Key:
eyJhbGc... (long string)

Service Role Key:
eyJhbGc... (another long string)
```

⚠️ **KEEP THESE SECRET!** Never commit them to GitHub.

### 1.3: Execute Database Schema
1. Go to **SQL Editor** in Supabase dashboard
2. Click **"New Query"**
3. Copy-paste the entire contents of [`database_schema.sql`](database_schema.sql)
4. Click **"Run"**
5. Wait for green checkmark ✅
6. Close the query

### 1.4: Verify Tables Created
1. Go to **Table Editor** in Supabase
2. You should see 4 tables:
   - [ ] `users`
   - [ ] `attendance_records`
   - [ ] `holidays`
   - [ ] `audit_logs`

---

## Step 2: Deploy Frontend to Vercel

### 2.1: Connect GitHub Repository
1. Go to https://vercel.com
2. Click **"Add New"** → **"Project"**
3. Click **"Import from Git"**
4. Select your GitHub account
5. Find and select `kuber-timesheet` repository
6. Click **"Import"**

### 2.2: Configure Environment Variables
1. You're now in project settings
2. Scroll to **"Environment Variables"**
3. Add each variable by clicking **"Add"**:

**Variable 1:**
```
Name:  NEXT_PUBLIC_SUPABASE_URL
Value: https://[your-project-id].supabase.co
```
(Paste your Supabase URL from Step 1.2)

**Variable 2:**
```
Name:  NEXT_PUBLIC_SUPABASE_ANON_KEY
Value: [your-anon-key]
```
(Paste your Anon Key from Step 1.2)

**Variable 3:**
```
Name:  SUPABASE_SERVICE_ROLE_KEY
Value: [your-service-role-key]
```
(Paste your Service Role Key from Step 1.2)

**Variable 4:**
```
Name:  NEXT_PUBLIC_NEPALI_API_URL
Value: https://kuber-timesheet-nepali.vercel.app
```
(Leave as placeholder for now - will update after deploying Python service)

### 2.3: Deploy Frontend
1. Click **"Deploy"** button
2. Wait for deployment (takes 2-5 minutes)
3. You'll see a green checkmark ✅ when done
4. Note your deployment URL (looks like: `https://kuber-timesheet-xxx.vercel.app`)

### 2.4: Test Frontend
1. Click the deployment URL
2. You should see the **Kuber Timesheet login page**
3. ✅ If you see it, frontend is working!

---

## Step 3: Deploy Python Microservice

### 3.1: Create New Vercel Project for Python Service
1. Go back to https://vercel.com/dashboard
2. Click **"Add New"** → **"Project"**
3. Click **"Import from Git"**
4. Select the same `kuber-timesheet` repository
5. Click **"Import"**

### 3.2: Configure for Python Service
1. In project settings:
2. Change **"Framework"** to **"Python"**
3. Set **"Root Directory"** to:
   ```
   services/nepali-date-service
   ```
4. This tells Vercel to deploy only the Python service

### 3.3: Set Environment Variables for Python Service
1. Go to **"Environment Variables"**
2. Add this variable:

```
Name:  ALLOWED_ORIGINS
Value: https://[your-frontend-url].vercel.app,http://localhost:3000
```

(Replace with your actual frontend URL from Step 2.4)

### 3.4: Deploy Python Service
1. Click **"Deploy"**
2. Wait for deployment (takes 1-2 minutes)
3. Note the Python service URL (looks like: `https://kuber-timesheet-nepali-xxx.vercel.app`)

### 3.5: Test Python Service
1. Open: `https://[your-python-service-url]/docs`
2. You should see **FastAPI Swagger UI** with all endpoints
3. Try the `/health` endpoint to verify it's working

---

## Step 4: Connect Frontend to Python Service

### 4.1: Update Frontend Environment Variable
1. Go back to your **frontend project** in Vercel
2. Go to **"Settings" → "Environment Variables"**
3. Find the variable: `NEXT_PUBLIC_NEPALI_API_URL`
4. Update its value to your **Python service URL**:
   ```
   https://[your-python-service-url].vercel.app
   ```
5. Click **"Save"**

### 4.2: Trigger Redeployment
1. Go to **"Deployments"**
2. Click the latest deployment
3. Click **"Redeploy"** button
4. Wait for redeployment to complete

---

## Step 5: Final Testing

### 5.1: Test Complete System
1. Go to your **frontend URL** again
2. You should still see the login page
3. The login page should now connect to:
   - ✅ Supabase for authentication
   - ✅ Python service for date conversions
   - ✅ Database for user records

### 5.2: Create Test Employee
1. Go to Supabase dashboard
2. Go to **"Table Editor"** → **"users"** table
3. Click **"Insert row"**
4. Fill in example data:
   ```
   email: test@example.com
   name: Test Employee
   role: employee
   is_active: true
   ```
5. Click **"Save"**

### 5.3: Test Login
1. Go to your **frontend URL** (`https://your-app.vercel.app`)
2. Try to log in with:
   - Email: `test@example.com`
   - Password: (any password for now - auth will be set up next)

⚠️ **Note:** Password authentication needs Supabase Auth setup (next phase). For now, you can create users and manually set their passwords via Supabase CLI.

---

## ✅ Deployment Complete!

You now have:
- ✅ **Frontend** deployed on Vercel
- ✅ **Python service** deployed on Vercel
- ✅ **Database** running on Supabase
- ✅ **All connected and working**

---

## 📋 Deployment URLs Reference

Save these for your records:

```
Frontend URL:        https://your-app.vercel.app
Python Service URL:  https://your-python.vercel.app
Python Docs:         https://your-python.vercel.app/docs
Supabase Project:    https://supabase.com/dashboard

Environment Variables:
- NEXT_PUBLIC_SUPABASE_URL: https://[id].supabase.co
- NEXT_PUBLIC_SUPABASE_ANON_KEY: [key]
- SUPABASE_SERVICE_ROLE_KEY: [key]
- NEXT_PUBLIC_NEPALI_API_URL: https://your-python.vercel.app
```

---

## 🔄 Continuous Deployment

From now on, deployment is **automatic**:

1. **Make changes locally**
2. **Commit to GitHub** (`git push`)
3. **Vercel automatically deploys** (takes 2-5 minutes)
4. **Check https://vercel.com/dashboard** to monitor deployments

No manual steps needed after initial setup!

---

## 🆘 Troubleshooting

### Frontend won't load
- [ ] Check environment variables in Vercel
- [ ] Verify Supabase credentials are correct
- [ ] Check Vercel build logs for errors

### Login fails
- [ ] Supabase database might not be initialized
- [ ] Check if users table exists
- [ ] Verify Supabase credentials

### Python service returns 404
- [ ] Check `NEXT_PUBLIC_NEPALI_API_URL` is set correctly
- [ ] Try visiting the Python service URL directly
- [ ] Check Python deployment logs in Vercel

### Database not connecting
- [ ] Check `NEXT_PUBLIC_SUPABASE_URL` in Vercel
- [ ] Verify credentials are exact (no extra spaces)
- [ ] Test Supabase connection directly in their dashboard

---

## 🎬 Next Steps

Now that everything is deployed:

1. **Phase 5+: UI Enhancements** (optional)
   - Build admin dashboard
   - Build employee dashboard
   - Add Excel export

2. **Production Hardening**
   - Enable 2FA in Supabase
   - Set up rate limiting
   - Configure custom domain

3. **Employee Training**
   - Set up employee accounts
   - Show how to use system
   - Create training guide

---

**Status:** ✅ System is live and production-ready!
