# Kuber Timesheet - Complete Deployment Documentation Index

**Everything you need to deploy and run the system successfully**

---

## 📊 Quick Navigation

### 🚀 **Getting Started (START HERE)**
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - **One-page cheat sheet** (~5 min read)
- [DEPLOYMENT_STEP_BY_STEP.md](DEPLOYMENT_STEP_BY_STEP.md) - **Detailed step-by-step** (~15 min read)
- [FULL_DEPLOYMENT_CHECKLIST.md](FULL_DEPLOYMENT_CHECKLIST.md) - **Interactive checklist with boxes** (~10 min)

### 📦 **Deployment Scripts & Guides**
- [STEP_1_SUPABASE_SETUP.ps1](STEP_1_SUPABASE_SETUP.ps1) - Helper script for Step 1
- [STEP_3_DEPLOY_FRONTEND.ps1](STEP_3_DEPLOY_FRONTEND.ps1) - Helper script for Step 3
- [STEP_4_DEPLOY_PYTHON.ps1](STEP_4_DEPLOY_PYTHON.ps1) - Helper script for Step 4
- [STEP_5_CONNECT_SERVICES.ps1](STEP_5_CONNECT_SERVICES.ps1) - Helper script for Step 5
- [DEPLOYMENT_COORDINATOR.ps1](DEPLOYMENT_COORDINATOR.ps1) - **Full automated guide** (interactive walkthrough)

### 🔑 **Configuration & Secrets**
- [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) - **How to manage secrets securely** (~10 min)

### 🐛 **Troubleshooting**
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - **Detailed solutions for 20+ common issues** (~15 min)

### 💾 **Database**
- [database_schema.sql](database_schema.sql) - **Execute in Supabase SQL Editor** (Step 2)

---

## 🎯 Choose Your Path

### "I want to deploy quickly"
→ Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) (5 min)  
→ Run [DEPLOYMENT_COORDINATOR.ps1](DEPLOYMENT_COORDINATOR.ps1) (25 min setup)  
→ **Done in ~30 minutes**

### "I want detailed step-by-step"
→ Read [DEPLOYMENT_STEP_BY_STEP.md](DEPLOYMENT_STEP_BY_STEP.md) (15 min)  
→ Follow each step carefully (5-8 min per step)  
→ **Total ~45 minutes**

### "I want to verify everything"
→ Use [FULL_DEPLOYMENT_CHECKLIST.md](FULL_DEPLOYMENT_CHECKLIST.md)  
→ Check off each box as you complete it  
→ **Total ~40 minutes**

### "I'm stuck and need help"
→ Go to [TROUBLESHOOTING.md](TROUBLESHOOTING.md)  
→ Find your error/symptom  
→ Follow the solution steps  
→ If still stuck, check prerequisites section

---

## 📋 The 5 Deployment Steps (Overview)

### **Step 1: Supabase Setup** (5 min)
**What:** Create cloud database project  
**How:** Web browser at https://app.supabase.com  
**Result:** 3 credentials saved safely  
**Files:** [STEP_1_SUPABASE_SETUP.ps1](STEP_1_SUPABASE_SETUP.ps1)

### **Step 2: Database Schema** (3 min)
**What:** Create 4 tables + security + indexes  
**How:** Copy SQL from [database_schema.sql](database_schema.sql) → paste in Supabase SQL Editor  
**Result:** Database ready  
**Files:** [database_schema.sql](database_schema.sql)

### **Step 3: Deploy Frontend** (8 min)
**What:** Deploy React app to production  
**How:** Import Kuber_Timesheet repo in Vercel  
**Result:** Frontend URL + deployed code  
**Files:** [STEP_3_DEPLOY_FRONTEND.ps1](STEP_3_DEPLOY_FRONTEND.ps1)

### **Step 4: Deploy Python Service** (8 min)
**What:** Deploy Nepali date microservice  
**How:** Run `vercel --prod` in services/nepali-date-service folder  
**Result:** Python service URL  
**Files:** [STEP_4_DEPLOY_PYTHON.ps1](STEP_4_DEPLOY_PYTHON.ps1)

### **Step 5: Connect Services** (5 min)
**What:** Tell frontend where Python service is  
**How:** Update env variable in Vercel  
**Result:** All services connected and working  
**Files:** [STEP_5_CONNECT_SERVICES.ps1](STEP_5_CONNECT_SERVICES.ps1)

---

## 🔐 Security Checklist

Before going live, verify:

```
□ .gitignore contains .env* (prevents secret leaks)
□ Secrets not stored in code, only in Vercel
□ Supabase Row-Level Security policies enforced
□ Only admin can delete/edit attendance
□ Employees can only see own records
□ Audit logs tracking all changes
□ Database backups enabled (Supabase default)
□ Two-factor auth on all admin accounts
```

See [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) for security rules.

---

## 📞 Support Resources

| Resource | Purpose | URL |
|----------|---------|-----|
| Vercel Documentation | Deployment & serverless | https://vercel.com/docs |
| Supabase Documentation | Database & auth | https://supabase.com/docs |
| Next.js Documentation | Frontend framework | https://nextjs.org/docs |
| FastAPI Documentation | Python backend | https://fastapi.tiangolo.com |
| PostgreSQL Tips | SQL troubleshooting | https://www.postgresql.org/docs |

---

## 🎓 Learning Resources

### Understanding the Architecture
- **Frontend:** Next.js 14 + React + TypeScript + Tailwind (deployed to Vercel)
- **Backend:** FastAPI + Python (microservice on Vercel)
- **Database:** Supabase PostgreSQL with RLS policies
- **Auth:** Supabase Auth (email/password, pre-generated)

### Key Components
- **[frontend/app/api/attendance/route.ts](../frontend/app/api/attendance/route.ts)** - Clock in/out API
- **[services/nepali-date-service/app.py](../services/nepali-date-service/app.py)** - Nepali date service
- **[frontend/lib/time-utils.ts](../frontend/lib/time-utils.ts)** - Time rounding logic
- **[database_schema.sql](database_schema.sql)** - Database structure

---

## ✅ Verification Steps

After deployment, verify everything works:

```bash
# 1. Check Frontend
→ Go to https://kuber-timesheet.vercel.app
→ Should see login page (no errors)

# 2. Check Python Service
→ Go to https://kuber-nepali-service.vercel.app/docs
→ Should see Swagger documentation

# 3. Check Database
→ Supabase → Tables → see all 4 tables created
→ See indexes and security policies

# 4. Test Login (after admin creates users)
→ Enter credentials on login page
→ Should redirect to dashboard

# 5. Test Clock In/Out
→ Click "Clock In" button
→ Click "Clock Out" button
→ Check audit logs in Supabase
```

---

## 🚨 Emergency Procedures

### System Down?

1. **Check status pages:**
   - https://status.vercel.com
   - https://status.supabase.com
   - https://www.githubstatus.com

2. **Check Vercel logs:**
   - Vercel Dashboard → Project → Deployments → click failed build

3. **Check Supabase status:**
   - Supabase Dashboard → Status indicator (top right)

4. **Full rebuild:**
   - Go to Vercel → Deployments
   - Click "Redeploy" on latest build
   - Takes 3-5 minutes

---

## 📊 System Requirements

### Local Development
- Windows 10+ / macOS / Linux
- PowerShell 5.1+
- Node.js 18+
- Python 3.9+
- Git

### Cloud

| Service | Tier | Cost |
|---------|------|------|
| Vercel | Pro or Free | $20-60/month or FREE |
| Supabase | Pro or Free | $25-100/month or FREE |
| GitHub | Free | **FREE** |
| **Total** | | **Up to $150/month** |

**Free tier works for:** 50 employees, 1000s of attendance records, testing phase

---

## 🎉 Success Indicators

✅ = Your deployment is successful if:

- [x] Frontend loads at Vercel URL
- [x] Login page appears
- [x] Database tables created in Supabase
- [x] Python service accessible
- [x] No TypeScript errors
- [x] No environment variable warnings
- [x] Audit logs recording events

---

## 📞 Quick Help

**Stuck?** Check these in order:
1. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - For quick answers
2. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - For detailed solutions
3. [ENVIRONMENT_VARIABLES.md](ENVIRONMENT_VARIABLES.md) - For config issues
4. Vercel logs - Click deployment, scroll to "Build Logs"
5. Supabase SQL Editor - Check error messages

---

## 📚 File Organization

```
Kuber TImesheet/
├── 📖 DOCUMENTATION FILES (Start with these)
│   ├── QUICK_REFERENCE.md ⭐ (Start here!)
│   ├── DEPLOYMENT_STEP_BY_STEP.md
│   ├── FULL_DEPLOYMENT_CHECKLIST.md
│   ├── DEPLOYMENT_INDEX.md (this file)
│   ├── ENVIRONMENT_VARIABLES.md
│   ├── TROUBLESHOOTING.md
│   │
├── 🚀 HELPER SCRIPTS
│   ├── DEPLOYMENT_COORDINATOR.ps1
│   ├── STEP_1_SUPABASE_SETUP.ps1
│   ├── STEP_3_DEPLOY_FRONTEND.ps1
│   ├── STEP_4_DEPLOY_PYTHON.ps1
│   └── STEP_5_CONNECT_SERVICES.ps1
│
├── 💾 DATABASE
│   └── database_schema.sql
│
├── 📁 FRONTEND
│   └── frontend/src/...
│
├── 🐍 PYTHON SERVICE
│   └── services/nepali-date-service/...
│
└── 📝 CONFIG FILES
    ├── .gitignore
    ├── tsconfig.json
    ├── next.config.js
    └── ...
```

---

## ⏰ Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| **Reading this guide** | 5-15 min | 📖 Now |
| **Step 1: Supabase** | 5 min | ⏳ Next |
| **Step 2: Database** | 3 min | ⏳ |
| **Step 3: Frontend** | 8 min | ⏳ |
| **Step 4: Python** | 8 min | ⏳ |
| **Step 5: Connect** | 5 min | ⏳ |
| **Testing** | 2 min | ⏳ |
| **TOTAL** | ~36 min | 🎉 |

---

## 🎯 Next Steps

1. **Right now:** Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) (5 min)
2. **Then:** Follow deployment steps (30 min)
3. **After:** Create test users in Supabase
4. **Finally:** Brief employees on how to use system

---

**Ready to deploy? Start with [QUICK_REFERENCE.md](QUICK_REFERENCE.md)! 🚀**
