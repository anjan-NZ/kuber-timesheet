# Automated Vercel Deployment - Setup & Execution

## What This Does

Deploys your entire system to Vercel with ONE command:
- ✅ Frontend deployed
- ✅ Python Service deployed  
- ✅ Services connected automatically
- ✅ System LIVE

---

## Prerequisites (Do Once)

### 1. Install Vercel CLI
```powershell
npm install -g vercel
```

### 2. Authenticate with Vercel
```powershell
vercel login
```

This opens your browser to authenticate. Once done, close the browser.

### 3. Verify Authentication
```powershell
vercel whoami
```

Should show your email address.

---

## Deployment (Automated)

Once prerequisites are complete, just run:

```powershell
cd "c:\Users\anjan\Desktop\In progress\Kuber TImesheet\"
powershell -ExecutionPolicy Bypass -File ".\DEPLOY_TO_VERCEL_AUTO.ps1"
```

The script will:
1. Deploy Frontend to Vercel
2. Deploy Python Service to Vercel
3. Connect them together
4. Show you the URLs

**Total time: ~10 minutes**

---

## What You'll See

```
========================================================
  AUTOMATED VERCEL DEPLOYMENT
========================================================

[CHECKING] Vercel CLI installation...
[OK] Vercel CLI found: 15.0.0

[CHECKING] Vercel authentication...
[OK] Authenticated as: your-email@example.com

[STEP 1/2] Deploying Frontend to Vercel...
Deploying frontend...
...
[OK] Frontend deployed: https://kuber-timesheet-xyz.vercel.app

[STEP 2/2] Deploying Python Service to Vercel...
Deploying Python service...
...
[OK] Python Service deployed: https://kuber-nepali-service-xyz.vercel.app

[STEP 3/2] Reconnecting Frontend to Python Service...
Frontend URL: https://kuber-timesheet-xyz.vercel.app
Python Service URL: https://kuber-nepali-service-xyz.vercel.app

Updating frontend environment variable...
...

========================================================
  DEPLOYMENT COMPLETE!
========================================================

Frontend URL:
  https://kuber-timesheet-xyz.vercel.app

Python Service URL:
  https://kuber-nepali-service-xyz.vercel.app

Your system is now LIVE! 🎉
```

---

## After Deployment

Your system is automatically configured and connected:
- ✅ Frontend is live
- ✅ Python Service is running
- ✅ They're connected
- ✅ Database is linked

### Test It:
1. Visit: `https://kuber-timesheet-xyz.vercel.app`
2. Try to log in
3. Test attendance tracking
4. Check Nepali dates display

---

## Troubleshooting

### "Vercel not found"
```powershell
npm install -g vercel
```

### "Not authenticated"
```powershell
vercel login
```

### "Deployment failed"
Check the error message. Usually means:
- Missing `vercel.json` configuration
- Invalid environment variables
- Code errors

If you get stuck, tell me the exact error message.

---

## Files Involved

- `DEPLOY_TO_VERCEL_AUTO.ps1` - The automation script
- `frontend/.env.local` - Frontend configuration (used automatically)
- `services/nepali-date-service/` - Python service code
- `package.json` files - Dependencies

---

## Go-Live Timeline

1. Install Vercel CLI: 2 minutes
2. Run `vercel login`: 1 minute
3. Run deployment script: 10 minutes
4. System fully live: ~13 minutes total

---

## Ready?

```
npm install -g vercel
vercel login
powershell -ExecutionPolicy Bypass -File ".\DEPLOY_TO_VERCEL_AUTO.ps1"
```

That's it! Your system will be LIVE! 🚀
