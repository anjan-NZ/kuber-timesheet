# Environment Variables Guide

## Overview

The Kuber Timesheet system needs credentials to connect frontend to backend and database. These should be kept SECURE and never committed to GitHub.

---

## Frontend Environment Variables (.env.local)

**Location:** `frontend/.env.local` (create this file locally)

**DO NOT** commit this file to GitHub (already in .gitignore)

### Required Variables

```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Python Nepali Date Service
NEXT_PUBLIC_NEPALI_API_URL=https://kuber-nepali-service.vercel.app

# Supabase Service Role (for API routes)
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Variable Descriptions

| Variable | Source | Purpose | Public? |
|----------|--------|---------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Settings → API | Supabase project URL | ✅ Yes (prefixed with NEXT_PUBLIC_) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Settings → API | Public authentication key | ✅ Yes (safe, limited permissions) |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Settings → API | Server-side admin key | ❌ **SECRET** - Never expose |
| `NEXT_PUBLIC_NEPALI_API_URL` | Vercel deployment | Python microservice URL | ✅ Yes (public service) |

---

## Vercel Environment Variables

**Location:** Vercel Dashboard → Project Settings → Environment Variables

**These are set during deployment** and persist in Vercel (they're encrypted).

### When Deploying Frontend

Set these in Vercel (they override .env.local):

```
NEXT_PUBLIC_SUPABASE_URL = https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
NEXT_PUBLIC_NEPALI_API_URL = https://kuber-nepali-service.vercel.app
```

### After Python Service Deployment

Update this in Vercel:
```
NEXT_PUBLIC_NEPALI_API_URL = [Your new Python service URL]
```

Then redeploy frontend.

---

## Local Development (.env.local)

### Setup

1. In `frontend/` folder, create file `.env.local`:
   ```bash
   touch frontend/.env.local
   ```

2. Add all variables above to this file

3. File is already in `.gitignore` - GitHub will never see it ✅

### Example .env.local

```bash
NEXT_PUBLIC_SUPABASE_URL=https://abcdefgh.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE2MzU0MzIwMDAsImV4cCI6MTk1MTA1MjAwMH0.GWqvRiqitvI8_3x1e8H8yW8O8w8l8w8l8w8l8w8l8w8
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTYzNTQzMjAwMCwiZXhwIjoxOTUxMDUyMDAwfQ.ABC123...
NEXT_PUBLIC_NEPALI_API_URL=https://kuber-nepali-service.vercel.app
```

---

## How to Find Your Credentials

### Supabase Credentials

1. Log in to [https://app.supabase.com](https://app.supabase.com)
2. Select your `Kuber_Timesheet` project
3. Click **Settings** (bottom left)
4. Click **API**
5. Copy from this page:
   - **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
   - **anon (public) key** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - **service_role (secret) key** → `SUPABASE_SERVICE_ROLE_KEY`

### Vercel Deployment URLs

1. After deploying to Vercel, you get URLs:
   - Frontend: `https://kuber-timesheet.vercel.app` or similar
   - Python: `https://kuber-nepali-service.vercel.app` or similar

2. Use Python URL for `NEXT_PUBLIC_NEPALI_API_URL`

---

## Security Rules

| Rule | Why |
|------|-----|
| ✅ **DO** commit `.gitignore` with `.env*` listed | Prevents accidental secret commits |
| ✅ **DO** set env vars in Vercel dashboard | Encrypted, managed by Vercel |
| ✅ **DO** use `NEXT_PUBLIC_` prefix for browser variables | Makes intent clear |
| ❌ **DON'T** commit `.env.local` to GitHub | Contains secrets! |
| ❌ **DON'T** commit `SERVICE_ROLE_KEY` anywhere | Admin-level access! |
| ❌ **DON'T** share credentials via chat/email | Use secure channels |
| ❌ **DON'T** use same keys across projects | Create separate Supabase projects |

---

## Debugging Environment Variable Issues

### Frontend shows "Cannot connect to Supabase"

**Check:**
```bash
# In browser console (F12):
console.log(process.env.NEXT_PUBLIC_SUPABASE_URL)
console.log(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY)
```

If `undefined`, variables not loaded. Restart dev server:
```bash
npm run dev
```

### "Cannot reach Python service"

**Check:**
```bash
# In browser console (F12):
console.log(process.env.NEXT_PUBLIC_NEPALI_API_URL)
```

If empty or wrong URL, update in Vercel Settings → Environment Variables and redeploy.

### "Invalid Supabase credentials"

**Check:**
1. Verify credentials match project in Supabase
2. Confirm keys are not expired (rare, but possible)
3. Check for extra spaces in keys

---

## Rotating Credentials (If Needed)

1. **In Supabase:**
   - Settings → API → Regenerate keys
   - Update all references immediately

2. **In Vercel:**
   - Update env variables
   - Redeploy all projects
   - Old keys stop working

3. **Note:** This causes brief downtime, plan accordingly

---

## Key Summary Table

```
┌─────────────────────────────────────┬──────────┬──────────┬─────────────┐
│ Variable                            │ Location │ Public?  │ Renew?      │
├─────────────────────────────────────┼──────────┼──────────┼─────────────┤
│ NEXT_PUBLIC_SUPABASE_URL            │ Supabase │ ✅ Yes   │ Every 2 yrs │
│ NEXT_PUBLIC_SUPABASE_ANON_KEY       │ Supabase │ ✅ Yes   │ Every 1 yr  │
│ SUPABASE_SERVICE_ROLE_KEY           │ Supabase │ ❌ Secret│ Yearly      │
│ NEXT_PUBLIC_NEPALI_API_URL          │ Vercel   │ ✅ Yes   │ When change │
└─────────────────────────────────────┴──────────┴──────────┴─────────────┘
```
