# Admin Dashboard - Troubleshooting & Verification Guide

## Step 1: Verify Deployment is Live

**Check Vercel Dashboard:**
1. Go to: https://vercel.com/dashboard
2. Click **frontend-anjan1** project
3. Check **Deployments** tab
4. Latest deployment should show ✅ **Ready** (green checkmark)
5. If it shows 🟡 **Building**, wait 2-3 minutes
6. If it shows ❌ **Failed**, click to see error logs

**Screenshot what you see and tell me if it's:**
- ✅ Ready
- 🟡 Building  
- ❌ Failed


---

## Step 2: Test Admin Login

**URL to visit:**
```
https://frontend-anjan1.vercel.app/kuberadmin/login
```

**Test credentials (defaults):**
- Email: `admin@company.com`
- Password: `admin123`

**What should happen:**
1. You see a purple login page
2. Enter email and password
3. Click "Login"
4. You see dashboard with 4 cards (Register Worker, View Workers, etc.)
5. Click "Logout" to go back to login

**If it doesn't work, tell me:**
- Is the page blank?
- Is it showing an error?
- Does the login button do nothing?
- Do you get redirected somewhere else?


---

## Step 3: Direct Testing URLs

Test each of these URLs and report what you see:

| URL | Expected Result | Status |
|-----|-----------------|--------|
| `https://frontend-anjan1.vercel.app/kuberadmin` | Redirect to login | ❓ |
| `https://frontend-anjan1.vercel.app/kuberadmin/login` | Purple login page | ❓ |
| `https://frontend-anjan1.vercel.app/kuberadmin/dashboard` | Redirect to login (unless logged in) | ❓ |
| `https://frontend-anjan1.vercel.app/kuberadmin/workers` | Redirect to login (unless logged in) | ❓ |

**Report what you see for each URL above**


---

## Step 4: Browser Console Debugging

1. Open the admin login page
2. Press **F12** (open Developer Tools)
3. Click **Console** tab
4. Tell me if you see any red errors


---

## Step 5: Check Environment Variables in Vercel

1. Go to: https://vercel.com/dashboard
2. Click **frontend-anjan1** project
3. Click **Settings** → **Environment Variables**
4. Check if you see:
   - `NEXT_PUBLIC_ADMIN_EMAIL`
   - `NEXT_PUBLIC_ADMIN_PASSWORD`

**If they're there:**
- ✅ Good, they'll override the defaults

**If they're NOT there:**
- The defaults will be used (admin@company.com / admin123)
- That's fine for testing


---

## Step 6: Verify Code is Deployed

In Vercel:
1. Click **frontend-anjan1** → **Code** tab
2. Look at the last commit message
3. It should say something like:
   - "Fix: Simplify admin root redirect..."
   - "Fix: Add default admin credentials..."
   - "Feature: Complete Admin Dashboard..."

**If you see an OLD commit** (like from yesterday), deployment hasn't caught up

**Solution: Force redeploy**
- Click **Deployments** tab
- Click the 3-dot menu on latest deployment
- Click **Redeploy**


---

## Full Troubleshooting Checklist

- [ ] Vercel deployment shows ✅ Ready status
- [ ] Latest commit includes "Fix: Simplify admin root redirect"
- [ ] Can access `https://frontend-anjan1.vercel.app/kuberadmin/login`
- [ ] Login page is visible (purple background with white card)
- [ ] Can enter email and password
- [ ] Login button works (at least shows loading state)
- [ ] No red errors in browser console (F12 → Console tab)
- [ ] Browser can access other pages (e.g., https://frontend-anjan1.vercel.app/)


---

## Common Issues & Solutions

### Issue: Blank page
**Solution:**
1. Check browser console for errors (F12)
2. Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
3. Try incognito/private browser window
4. Check Vercel logs for build errors

### Issue: Redirects to /login instead of /kuberadmin/login
**Solution:**
- This means `/kuberadmin` route handler is working correctly
- You'll be redirected to `/kuberadmin/login` automatically
- This is expected behavior

### Issue: Login button does nothing
**Solution:**
1. Check browser console for JavaScript errors
2. Verify email/password match exactly:
   - Email: `admin@company.com` (with @)
   - Password: `admin123` (no spaces)
3. Try incognito window

### Issue: "Invalid admin credentials"
**Solution:**
1. Check spelling of email and password
2. Default credentials are:
   - Email: `admin@company.com`
   - Password: `admin123`
3. If you set custom env vars in Vercel, use those instead

### Issue: Stuck on "Loading..."
**Solution:**
1. Check console for errors
2. Hard refresh browser
3. Check Vercel deployment status
4. Wait 5 more minutes for deployment to complete

---

## How to Launch / Deploy

**One-time setup:**
1. Set admin credentials in Vercel Environment Variables (optional)
2. Wait for Vercel to redeploy (~2 mins)
3. Visit `https://frontend-anjan1.vercel.app/kuberadmin`

**After code changes:**
1. Push code to GitHub: `git push origin main`
2. Vercel auto-deploys within 1-2 minutes
3. Visit the site again (may need hard refresh: Ctrl+Shift+R)

---

## What to Tell Me When Reporting Issues

To help you faster, include:
1. **Exact URL** you visited
2. **What you see** (blank page, error, login page, etc.)
3. **What you expected** to see
4. **Screenshots** if possible
5. **Browser** (Chrome, Firefox, Safari, Edge)
6. **Any error messages** from console (F12)
7. **Vercel deployment status** (Ready/Building/Failed)

---

## Success Checklist

When admin dashboard is working:
- ✅ Can visit `/kuberadmin` and see login page
- ✅ Can log in with `admin@company.com` / `admin123`
- ✅ Can see admin dashboard with 4 cards
- ✅ Can click "Register Worker" card
- ✅ Can see registration form
- ✅ Can type worker name, email, password
- ✅ Can click "Register Worker" button
- ✅ Get success message
- ✅ Are redirected to workers list
- ✅ Can click "Logout"
- ✅ Are logged out

---

## Architecture

```
Frontend Website
├── Main Employee Site
│   ├── /login → Employee login
│   ├── /dashboard → Clock in/out
│   └── /timesheet → Submit timesheet
│
└── Admin Site (/kuberadmin)
    ├── /kuberadmin → Redirects to /login
    ├── /kuberadmin/login → Admin login page
    ├── /kuberadmin/dashboard → Admin home
    ├── /kuberadmin/register-worker → Add employees
    └── /kuberadmin/workers → List all employees
```

---

**Next: Tell me what you see when you visit the admin URLs above, and I can diagnose the exact issue!**
