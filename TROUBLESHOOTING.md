# Troubleshooting Guide

**Having issues? Check here first.**

---

## 🔴 Critical Issues

### Nothing loads - blank page in browser

**Symptoms:**
- Vercel URL shows blank white page
- No console errors
- Page never loads

**Solutions:**

1. **Clear browser cache:**
   - Press `Ctrl+Shift+Delete`
   - Clear all cache
   - Refresh page

2. **Check browser console:**
   - Press `F12`
   - Go to **Console** tab
   - Look for red error messages
   - Take a screenshot of any errors

3. **Check Vercel logs:**
   - Go to Vercel Dashboard
   - Click your project
   - Go to **Deployments** tab
   - Click latest deployment
   - Click **Logs** tab at bottom
   - Look for error messages

4. **Common causes:**
   - Environment variables not set
   - Supabase URL is wrong
   - Supabase project not ready yet (wait 2 more minutes)

---

### "Cannot find module @/types"

**Symptoms:**
- Red errors in VS Code
- TypeScript compiler fails
- `Cannot find module '@/...'`

**Solution (Already Fixed):**
This was fixed in your project. If you still see it:
- Open `frontend/tsconfig.json`
- Check that `"@/*": ["./src/*"]` is set correctly
- Not `"@/*": ["./*"]`

---

### "TypeError: Cannot read property 'email' of null"

**Symptoms:**
- Login page throws error
- Error mentions authentication
- Local storage might be corrupted

**Solutions:**

1. **Clear local storage:**
   ```javascript
   // In browser console (F12):
   localStorage.clear()
   sessionStorage.clear()
   location.reload()
   ```

2. **Check Supabase connection:**
   ```javascript
   // In browser console (F12):
   console.log(process.env.NEXT_PUBLIC_SUPABASE_URL)
   ```
   If undefined → env variables not loaded

3. **Restart dev server:**
   ```bash
   npm run dev
   ```
   Kill (Ctrl+C) and restart

---

## 🟠 Common Issues

### Supabase Errors

#### "Network error" when accessing Supabase

**Symptoms:**
- Can't load Supabase dashboard
- Projects list won't load
- Stuck on loading screen

**Causes & Solutions:**

| Problem | Fix |
|---------|-----|
| Internet down | Check connection |
| Supabase region unreachable | Try different browser/VPN |
| Supabase status page down | Wait 30 minutes, check https://status.supabase.com |
| Browser ad blocker blocking Supabase | Disable ad blocker for app.supabase.com |

#### "Invalid API key"

**Symptoms:**
- Login fails with "Invalid API key"
- API calls return 401 Unauthorized

**Solutions:**

1. **Verify you copied the keys correctly:**
   - No extra spaces
   - No line breaks in key
   - Full key (very long, usually 200+ characters)

2. **Check key format:**
   - Should start with `eyJ` (Base64)
   - Should contain periods

3. **Regenerate keys:**
   - Supabase → Settings → API
   - Click "Regenerate" next to keys
   - Update all env vars
   - Redeploy Vercel

#### "CORS error"

**Symptoms:**
- Browser console: `Access to XMLHttpString blocked by CORS policy`
- Network tab shows failed requests
- Python service calls fail

**Solutions:**

1. **Check Python service CORS settings:**
   - File: `services/nepali-date-service/app.py`
   - Look for `allow_origins` in CORS config
   - Should include your Vercel frontend URL

2. **Verify Python service is running:**
   ```bash
   # In browser console:
   fetch('https://your-python-service.vercel.app/docs')
   ```
   Should load (404 is fine, means service responds)

3. **Add origins to Python CORS:**
   If needed, edit `app.py`:
   ```python
   allow_origins=[
       "http://localhost:3000",
       "https://kuber-timesheet.vercel.app",  # Add your frontend URL
   ]
   ```

---

### Vercel Issues

#### Deployment stuck on "Building"

**Symptoms:**
- Vercel shows "Building..." for >10 minutes
- Deployment won't complete

**Solutions:**

1. **Cancel and redeploy:**
   - Click deployment in Vercel
   - Look for "Cancel" button
   - Click it
   - Go to "Deployments" tab
   - Click "Redeploy" on previous successful build

2. **Check build logs:**
   - Vercel → Deployments → click stuck build
   - Click "Build Logs" tab
   - Look for errors
   - See "Why is build stuck?" section below

#### Why is build stuck?

**Common causes:**

| Error | Fix |
|-------|-----|
| `Dependency installation timeout` | Increase timeout or reduce dependencies |
| `Out of disk space` | Delete unused files, rebuild |
| `npm ERR! 404` | Check package.json, typo in package name |
| `TypeScript errors` | Fix TS errors (check against tsconfig.json) |

---

### Python Service Issues

#### "ModuleNotFoundError: No module named 'nepali-datetime'"

**Symptoms:**
- Python service deployment fails
- Error in Vercel logs: `ModuleNotFoundError`

**Solutions:**

1. **Check requirements.txt:**
   - File: `services/nepali-date-service/requirements.txt`
   - Should contain: `nepali-datetime`
   - If missing, add it

2. **Check Python version:**
   - Vercel uses Python 3.9+
   - Make sure code is Python 3.9 compatible
   - Check `vercel.json` runtime

3. **Redeploy:**
   ```bash
   cd services/nepali-date-service
   vercel --prod
   ```

#### "ImportError: cannot import name..."

**Symptoms:**
- Python service fails to start
- Error in Vercel logs

**Solutions:**

1. **Check FastAPI version:**
   ```python
   # In app.py - should be compatible
   from fastapi import FastAPI
   ```

2. **Test locally:**
   ```bash
   cd services/nepali-date-service
   pip install -r requirements.txt
   uvicorn app:app --reload
   ```
   Should run on `http://localhost:8000`

3. **Check app.py imports:**
   - All imports at top of file
   - No typos in module names
   - All dependencies in requirements.txt

---

### Database Issues

#### "permission denied for schema public"

**Symptoms:**
- SQL error when running queries
- Cannot create tables

**Solutions:**

1. **Check role permissions:**
   - Supabase → SQL Editor → run:
   ```sql
   SELECT current_role;
   ```
   - Should show your role has permissions

2. **Use postgres role:**
   - Verify you're logged in as correct user
   - Check Supabase authentication

3. **Try again from scratch:**
   - Create new Supabase project
   - Run schema script fresh

#### "duplicate key value violates unique constraint"

**Symptoms:**
- Error when trying to insert data
- Clock in/out fails
- "duplicate entry" error

**Solutions:**

1. **Check if entry exists:**
   ```sql
   SELECT * FROM attendance_records 
   WHERE user_id = 'xxx' AND entry_date = '2080-01-01';
   ```
   If EXISTS→ entry already created that day

2. **Delete duplicate (admin only):**
   ```sql
   DELETE FROM attendance_records 
   WHERE user_id = 'xxx' AND entry_date = '2080-01-01';
   ```

3. **Check unique constraint:**
   - File: `database_schema.sql` line ~45
   - Should be: `unique (user_id, entry_date)`
   - This prevents double entries per day ✅

---

### Frontend Issues

#### "Cannot find Nepali dates"

**Symptoms:**
- Date picker won't show
- "Nepali date" module not found
- Dashboard shows no date

**Solutions:**

1. **Check Nepali API is configured:**
   ```bash
   # In browser console (F12):
   console.log(process.env.NEXT_PUBLIC_NEPALI_API_URL)
   ```
   Should show Python service URL (not empty)

2. **Check Python service is reachable:**
   ```javascript
   // In browser console:
   fetch('https://your-python-url/date/current')
     .then(r => r.json())
     .then(d => console.log(d))
   ```
   Should return Nepali date object

3. **Check Vercel env variables:**
   - Go to Vercel → Settings → Environment Variables
   - Verify `NEXT_PUBLIC_NEPALI_API_URL` is set
   - Redeploy after changing

#### Login page doesn't appear

**Symptoms:**
- Blank page at frontend URL
- No login form visible
- Page appears to load but shows nothing

**Solutions:**

1. **Check JavaScript errors:**
   - Press F12 → Console tab
   - Look for red errors
   - Click error to see details

2. **Check Supabase is loaded:**
   ```javascript
   // In browser console:
   console.log(window)
   // Search for supabase object
   ```

3. **Verify correct URL:**
   - Make sure you're at: `https://kuber-timesheet.vercel.app`
   - Not localhost (unless doing local dev)

4. **Clear browser cache:**
   - Ctrl+Shift+Delete
   - Clear cache, cookies, local storage
   - Reload page

---

## 🟡 Performance Issues

#### Site is slow

**Symptoms:**
- Pages load slowly
- Clock in/out takes >5 seconds
- Database queries timeout

**Solutions:**

1. **Check bundle size:**
   ```bash
   # In frontend folder:
   npm run analyze
   ```
   Look for large dependencies

2. **Optimize database queries:**
   - Add indexes (already done in schema)
   - Reduce data fetched

3. **Check Vercel function duration:**
   - Vercel Dashboard → project → Logs
   - Look for slow API routes
   - Optimize queries

4. **Monitor Supabase:**
   - Supabase → Database → Tables
   - Check row counts
   - Archive old records if >100k rows

---

## ✅ Verification Checklist

Before declaring "deployment failed", verify:

```
□ Internet connection is stable
□ Correct Supabase project selected (not different account)
□ Correct GitHub repository (anjan-NZ/Kuber_Timesheet)
□ Correct Vercel project (verify in URL bar)
□ All 3 Supabase keys copied correctly (no spaces)
□ Environment variables set in Vercel (not just locally)
□ Browser cache cleared (Ctrl+Shift+Delete)
□ Python service deployed and reachable
□ Database SQL executed without errors
□ No TypeScript compilation errors
```

---

## 🆘 Getting Help

If you're still stuck:

1. **Screenshot everything:**
   - Supabase error message
   - Vercel logs
   - Browser console error (F12)
   - Network tab showing failed requests

2. **Check these files:**
   - `frontend/tsconfig.json` - path aliases correct?
   - `services/nepali-date-service/app.py` - correct imports?
   - `services/nepali-date-service/requirements.txt` - has all packages?
   - `database_schema.sql` - executed without errors?

3. **Escalation:**
   - Vercel status: https://status.vercel.com
   - Supabase status: https://status.supabase.com
   - GitHub status: https://www.githubstatus.com

---

## 📞 Quick Support Links

- **Vercel Docs:** https://vercel.com/docs
- **Supabase Docs:** https://supabase.com/docs
- **Next.js Docs:** https://nextjs.org/docs
- **FastAPI Docs:** https://fastapi.tiangolo.com
- **React Docs:** https://react.dev

---

**Problem not listed?** Check the detailed docs in your project folder or reach out!
