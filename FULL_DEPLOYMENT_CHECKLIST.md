# Kuber Timesheet - Complete Deployment Checklist

## ✅ Pre-Deployment Requirements

- [ ] GitHub account with access to `anjan-NZ/Kuber_Timesheet` 
- [ ] Vercel account (connected to GitHub)
- [ ] Supabase account
- [ ] Project folder ready: `c:\Users\anjan\Desktop\In progress\Kuber TImesheet`

---

## 📋 STEP 1: Supabase Project Setup (5 min)

**What:** Create database in the cloud

```
☐ Go to https://app.supabase.com
☐ Create new project
  - Name: Kuber_Timesheet
  - Password: [create strong one]
  - Region: [choose closest]
☐ Wait for project to load (2-3 minutes)
☐ Go to Settings → API
☐ Copy and save these 3 values:
  ☐ SUPABASE_URL
  ☐ SUPABASE_ANON_KEY
  ☐ SUPABASE_SERVICE_ROLE_KEY
```

**Result:** You have 3 credentials saved safely ✅

---

## 📋 STEP 2: Create Database Tables (3 min)

**What:** Run SQL script to create all tables

```
☐ In Supabase, click SQL Editor
☐ Click "New Query"
☐ Open file: database_schema.sql (in project folder)
☐ Copy entire contents
☐ Paste into Supabase SQL editor
☐ Click Run button (play icon)
☐ Wait for success ✅
```

**Result:** Database created with 4 tables, security policies, indexes ✅

---

## 📋 STEP 3: Deploy Frontend to Vercel (8 min)

**What:** Deploy React/Next.js frontend

```
☐ Go to https://vercel.com
☐ Sign in with GitHub
☐ Click "Add New" → "Project"
☐ Find Kuber_Timesheet repository
☐ Click Import
☐ When "Configure Project" appears, add Environment Variables:
  ☐ NEXT_PUBLIC_SUPABASE_URL = [from Step 1]
  ☐ NEXT_PUBLIC_SUPABASE_ANON_KEY = [from Step 1]
  ☐ SUPABASE_SERVICE_ROLE_KEY = [from Step 1]
  ☐ NEXT_PUBLIC_NEPALI_API_URL = (leave empty for now)
☐ Click Deploy
☐ Wait 3-5 minutes
```

**Result:** Frontend deployed at https://kuber-timesheet.vercel.app ✅

**Save your Frontend URL:**
```
Frontend URL: ___________________________________
```

---

## 📋 STEP 4: Deploy Python Service to Vercel (8 min)

**What:** Deploy FastAPI Python microservice for Nepali dates

```
☐ Open PowerShell
☐ Navigate to project:
  cd "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"

☐ Run deployment:
  cd services\nepali-date-service
  vercel --prod

☐ When prompted:
  ☐ "Set up and deploy?" → y
  ☐ "Project name?" → kuber-nepali-service
  ☐ "Do you want to deploy?" → y

☐ Wait 2-3 minutes for deployment
```

**Result:** Python service deployed ✅

**Save your Python Service URL:**
```
Python Service URL: ___________________________________
```

---

## 📋 STEP 5: Connect Frontend to Python Service (5 min)

**What:** Tell frontend where to find Python service

```
☐ Go to https://vercel.com
☐ Select kuber-timesheet project
☐ Go to Settings → Environment Variables
☐ Find NEXT_PUBLIC_NEPALI_API_URL
☐ Update the value to:
  [Your Python Service URL from STEP 4]
    (e.g., https://kuber-nepali-service.vercel.app)
☐ Click Save
☐ Go to Deployments tab
☐ Click Redeploy on latest deployment
☐ Wait 2-3 minutes
```

**Result:** Frontend and Backend connected ✅

---

## 🧪 STEP 6: Test Deployment (2 min)

```
☐ Open browser and go to:
  https://kuber-timesheet.vercel.app

☐ You should see:
  - Login page loads
  - No error messages in console (F12)

☐ That's it! System is LIVE ✅
```

---

## 🔧 Troubleshooting

| Step | Problem | Solution |
|------|---------|----------|
| 2 | SQL error | Check syntax in Supabase error message |
| 3 | Can't find repository | Make sure you're importing from anjan-NZ/Kuber_Timesheet |
| 4 | `vercel` command not found | npm install -g vercel |
| 5 | Frontend shows error | Check Python URL in env variables |
| 6 | Blank page | Press F12 and check browser console for errors |

---

## 🎉 Success Indicators

✅ Supabase project created and database running
✅ Frontend deployed at public Vercel URL
✅ Python service deployed at public Vercel URL
✅ Login page appears in browser
✅ No TypeScript or deployment errors
