# STEP 4: Deploy Python Service to Vercel

**Status**: ✅ Credentials Ready | ✅ Database Ready | ✅ Frontend Deployed | ⏳ Python Service Pending

---

## Prerequisites:

1. ✅ Python FastAPI service code in `services/nepali-date-service/`
2. ✅ `requirements.txt` configured
3. ✅ Code pushed to GitHub

---

## Python Service Deployment Steps:

### Step 1: Create New Vercel Project for Python Service
1. Go to https://vercel.com
2. Click **"Add New..."** → **"Project"**
3. Select the **same repository** (Kuber Timesheet)
4. Under "Deploy from..." select **"services/nepali-date-service"** as root directory
5. Click **"Deploy"**

### Step 2: Configure Environment Variables
Add this environment variable:

```
Name: SUPABASE_URL
Value: https://zhrsneyyczjhyastjvbq.supabase.co

Name: SUPABASE_KEY  
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpocnNuZXl5Y3pqaHlhc3RqdmJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMTg4MjYsImV4cCI6MjA5MDc5NDgyNn0.1pYcicuI2C27SWmpVK8DeTAOEKC5nlHajg_oQ9mEwlE
```

### Step 3: Deploy
1. Click **"Deploy"** button
2. Wait for deployment to complete
3. You'll get a URL like: `https://kuber-nepali-service-[random].vercel.app`

### Step 4: Test the Service
Visit:
```
https://kuber-nepali-service-xyz.vercel.app/health
```

You should see:
```json
{"status": "ok"}
```

### Step 5: Note Your Python Service URL
Copy the deployed URL - you'll need it for STEP 5.

---

## Expected Python Service URL Format:

Example:
```
https://kuber-nepali-service-xyz.vercel.app
```

---

## Troubleshooting:

**If build fails:**
- Check Python version (3.9+)
- Verify requirements.txt is in root
- Check for syntax errors in app.py

**If service doesn't respond:**
- Check if API endpoint is `/api/nepali-date`
- Verify CORS is enabled in FastAPI app
- Check server logs in Vercel dashboard

---

## When Complete:

Tell me your Python Service URL like:
```
Python Service URL: https://kuber-nepali-service-xyz.vercel.app
```

Then we'll move to STEP 5 (Connect Services).
