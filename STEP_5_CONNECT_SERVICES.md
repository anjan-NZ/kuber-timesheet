# STEP 5: Connect Services (Final Integration)

**Status**: ✅ All Components Deployed | ⏳ Service Connection Pending

---

## What This Step Does:

Connects your Frontend to your Python Service so they communicate properly.

---

## Frontend Configuration:

### Step 1: Update Frontend Environment Variable
1. Go to Vercel Dashboard (https://vercel.com)
2. Find your **Frontend project** (e.g., kuber-timesheet-xyz)
3. Click **Settings** → **Environment Variables**
4. Find or add: `NEXT_PUBLIC_NEPALI_API_URL`
5. Set the value to your **Python Service URL**:
   ```
   https://kuber-nepali-service-xyz.vercel.app
   ```

### Step 2: Redeploy Frontend
1. Go back to your Frontend project
2. Click the **Deployments** tab
3. Find the latest deployment
4. Click the **three dots (...)** → **Redeploy**
5. Confirm to redeploy
6. Wait for deployment to complete

### Step 3: Verify Connection
1. Visit your Frontend: `https://kuber-timesheet-xyz.vercel.app`
2. Navigate to a page that uses Nepali date conversion
3. Check if dates display correctly
4. Open browser Developer Tools (F12) → Console
5. Verify no API errors are showing

---

## Backend Configuration (Python Service):

### Step 1: Verify CORS is Enabled
The Python service should already have CORS enabled in `app.py`:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Step 2: Test API Endpoint
Visit your Python service health check:
```
https://kuber-nepali-service-xyz.vercel.app/health
```

Should return:
```json
{"status": "ok"}
```

---

## Testing the Complete System:

### Test 1: Database Connectivity
- Log into Frontend
- Try to access attendance records
- Verify data is saved to Supabase

### Test 2: Nepali Date Conversion
- Try any action that converts dates to Nepali
- Check if dates display correctly
- Verify no console errors

### Test 3: Authentication
- Test login/logout functionality
- Verify Supabase Auth is working
- Check user sessions

---

## Success Criteria:

✅ All of these should work:
- Frontend loads without errors
- Python Service responds to requests
- Database operations work
- Authentication is functional
- Nepali date conversion displays correctly

---

## Go-Live Checklist:

Before declaring ready:
- [ ] Frontend deployed on Vercel
- [ ] Python Service deployed on Vercel
- [ ] Services are connected
- [ ] All tests pass
- [ ] No console errors
- [ ] Data persists in Supabase
- [ ] Authentication works

---

## When Everything is Working:

**Your system is LIVE!** 🎉

The Kuber Timesheet application is now:
- ✅ Accessible online
- ✅ Connected to Supabase database
- ✅ Running Python microservices
- ✅ Ready for employees to use

---

## Next Steps (Post-Deployment):

1. Invite employees to test
2. Monitor Vercel logs for errors
3. Monitor Supabase database
4. Set up automated backups
5. Consider setting up analytics

---

## Support:

If anything doesn't work:
1. Check Vercel deployment logs
2. Check Supabase logs
3. Verify environment variables
4. Review browser console errors
5. Check Python service logs in Vercel

**Tell me if you need help troubleshooting!**
