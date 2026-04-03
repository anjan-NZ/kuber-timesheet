# QUICK DEPLOYMENT REFERENCE CARD

**Print this page or keep it open during deployment**

---

## 🚀 5-STEP DEPLOYMENT (~30 minutes)

### STEP 1: Supabase Setup (5 min)
```
1. Go to: https://app.supabase.com
2. Create project "Kuber_Timesheet"
3. Go to: Settings → API
4. Copy 3 values:
   □ SUPABASE_URL
   □ SUPABASE_ANON_KEY (public)
   □ SUPABASE_SERVICE_ROLE_KEY (secret)
5. Save these safely ✅
```

### STEP 2: Database (3 min)
```
1. Supabase → SQL Editor → New Query
2. Open: database_schema.sql
3. Copy entire file contents
4. Paste into SQL editor
5. Click Run ✅
```

### STEP 3: Frontend Deploy (8 min)
```
1. Go to: https://vercel.com
2. Sign in with GitHub
3. Click: Add New → Project
4. Select: Kuber_Timesheet repo
5. Add env vars:
   - NEXT_PUBLIC_SUPABASE_URL = [Step 1]
   - NEXT_PUBLIC_SUPABASE_ANON_KEY = [Step 1]
   - SUPABASE_SERVICE_ROLE_KEY = [Step 1]
   - NEXT_PUBLIC_NEPALI_API_URL = (empty)
6. Click Deploy ✅
```
**Save:** Frontend URL (e.g., https://kuber-timesheet.vercel.app)

### STEP 4: Python Deploy (8 min)
```
Run in PowerShell:
cd services\nepali-date-service
vercel --prod

When prompted:
- Project name? → kuber-nepali-service
- Deploy? → yes

Wait 2-3 minutes ✅
```
**Save:** Python URL (e.g., https://kuber-nepali-service.vercel.app)

### STEP 5: Connect (5 min)
```
1. Vercel Dashboard → kuber-timesheet
2. Settings → Environment Variables
3. Find: NEXT_PUBLIC_NEPALI_API_URL
4. Set to: [Python URL from Step 4]
5. Save
6. Go to: Deployments
7. Click: Redeploy
8. Wait 2-3 minutes ✅
```

---

## ✅ TEST

```
1. Open: https://kuber-timesheet.vercel.app
2. Should see: Login page
3. No errors? DONE! 🎉
```

---

## 🔧 TROUBLESHOOTING

| Issue | Fix |
|-------|-----|
| Env vars not loading | Restart `npm run dev` |
| Can't find Supabase keys | Settings → API in Supabase |
| Vercel import fails | Make sure Github repo is `Kuber_Timesheet` |
| Python URL 404 | Update env var and redeploy |
| Blank page in browser | Press F12, check console errors |

---

## 📋 CREDENTIALS CHECKLIST

During deployment, save these immediately:

```
SUPABASE_URL:
_________________________________________________

SUPABASE_ANON_KEY:
_________________________________________________

SUPABASE_SERVICE_ROLE_KEY:
_________________________________________________

FRONTEND_URL:
_________________________________________________

PYTHON_SERVICE_URL:
_________________________________________________
```

---

## ⏱️ TIME ESTIMATE

| Step | Time | Status |
|------|------|--------|
| 1. Supabase Project | 5 min | ⏳ |
| 2. Database Schema | 3 min | ⏳ |
| 3. Frontend Deploy | 8 min | ⏳ |
| 4. Python Deploy | 8 min | ⏳ |
| 5. Connect Services | 5 min | ⏳ |
| **TOTAL** | **~30 min** | 🚀 |

---

## 🎯 SUCCESS = 

✅ Supabase running
✅ Database created
✅ Frontend deployed
✅ Python deployed
✅ Services connected
✅ Login page loads
= **SYSTEM LIVE!**

---

**Next:** Admin users creation and employee testing
