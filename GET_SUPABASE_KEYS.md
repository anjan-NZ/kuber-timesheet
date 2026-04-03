# How to Find Your Supabase Keys

## Your Supabase URL (Already Have):
https://zhrsneyyczjhyastjvbq.supabase.co

## Where to Find Anon Key & Service Role Key

### Quick Path:
1. Open: https://app.supabase.com
2. Click your project name in the left sidebar
3. Bottom left: Click **Settings** (gear icon)
4. Click **API** tab
5. Look for "Project API keys" section

### What You'll See:

```
Project API keys
├── Project URL: https://zhrsneyyczjhyastjvbq.supabase.co
├── anon (public): [COPY THIS - THIS IS YOUR ANON KEY]
└── service_role (secret): [COPY THIS - THIS IS YOUR SERVICE ROLE KEY]
```

### Important Notes:
- **anon key**: Safe to use in frontend code (public)
- **service_role key**: KEEP SECRET - never commit to GitHub
- Both keys start with: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

---

## Steps to Copy Keys:

**Step 1:** Find the "anon" row
- Click the copy icon (📋) on the right side
- Paste the full key value

**Step 2:** Find the "service_role" row  
- Click the copy icon (📋) on the right side
- Paste the full key value

**Step 3:** Share both keys here**

---

## Once You Have Both Keys:

Return with this format:

```
SUPABASE_URL: https://zhrsneyyczjhyastjvbq.supabase.co
ANON_KEY: [paste entire anon key here]
SERVICE_ROLE_KEY: [paste entire service role key here]
```

Then I will:
1. ✅ Store credentials securely
2. ✅ Create environment file
3. ✅ Proceed to STEP 2 (Database Schema)

---

**Ready to go?** Find those keys now and paste them here!
