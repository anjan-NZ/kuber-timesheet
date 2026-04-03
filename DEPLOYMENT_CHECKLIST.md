# Deployment Checklist

## Pre-Deployment

- [ ] All code committed to git
- [ ] Environment files configured (`.env.local` not committed)
- [ ] Database schema tested locally
- [ ] Python microservice tested locally
- [ ] Frontend tested locally (npm run dev)
- [ ] No console errors in browser
- [ ] All API endpoints tested manually

## Supabase Setup

- [ ] Create Supabase project
- [ ] Save project URL and API keys
- [ ] Execute `database_schema.sql` in SQL Editor
- [ ] Verify all tables created:
  - [ ] `users`
  - [ ] `attendance_records`
  - [ ] `holidays`
  - [ ] `audit_logs`
- [ ] Verify RLS policies are in place
- [ ] Enable Email/Password authentication
- [ ] Configure email templates (optional but recommended)
- [ ] Create first admin user (manually in SQL or Auth tab)

## Frontend Deployment (Vercel)

1. **Push to GitHub:**
   - [ ] Code pushed to main branch
   - [ ] No uncommitted changes

2. **Configure Vercel:**
   - [ ] Create Vercel account
   - [ ] Import GitHub repository (select `frontend/` as root)
   - [ ] Add environment variables:
     - [ ] `NEXT_PUBLIC_SUPABASE_URL`
     - [ ] `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - [ ] `SUPABASE_SERVICE_ROLE_KEY`
     - [ ] `NEXT_PUBLIC_NEPALI_API_URL` (update after Python service deployed)

3. **Deploy:**
   - [ ] Click "Deploy"
   - [ ] Wait for build to complete
   - [ ] Test deployment URL
   - [ ] Verify login page works
   - [ ] Test with valid credentials

## Python Microservice Deployment

1. **Prepare for Deployment:**
   - [ ] Create `api/index.py` wrapper for Vercel serverless
   - [ ] Verify all dependencies in `requirements.txt`
   - [ ] Test locally: `python app.py`

2. **Deploy to Vercel:**
   - [ ] Create separate Vercel project for Python service (or use same project)
   - [ ] Push to GitHub (in `services/nepali-date-service/`)
   - [ ] Configure `vercel.json` for Python runtime
   - [ ] Deploy

3. **Post-Deploy:**
   - [ ] Test health endpoint: `https://your-service.vercel.app/health`
   - [ ] Test date conversion: `https://your-service.vercel.app/docs`
   - [ ] Update `NEXT_PUBLIC_NEPALI_API_URL` in frontend Vercel settings
   - [ ] Redeploy frontend with updated URL

## Post-Deployment Testing

### Frontend
- [ ] Login page loads
- [ ] Can login with test credentials
- [ ] Dashboard shows user name and role
- [ ] Can see "Coming Soon" placeholders for features
- [ ] Sign out works
- [ ] Redirects to login when accessing protected routes

### API Endpoints
- [ ] `/api/records` returns records (test with curl or Postman)
- [ ] `/api/holidays` returns holidays list
- [ ] Auth redirects work correctly

### Python Microservice
- [ ] `/health` returns 200 OK
- [ ] `/convert/english-to-nepali` works (test: 2026-04-03 → 2082-11-21)
- [ ] `/date/current` returns current date in NPT
- [ ] CORS headers are correct

### Database
- [ ] Can query Supabase tables directly
- [ ] RLS policies are enforced (test: employee can't see other employee's records)
- [ ] Audit logs are being created

## Production Handoff

- [ ] Create admin user(s)
- [ ] Create test employee accounts
- [ ] Write admin guide (password reset, employee management, etc.)
- [ ] Write employee guide (how to clock in/out)
- [ ] Setup monitoring/alerts (optional)
- [ ] Backup database (Supabase auto-backups, but verify)
- [ ] Document API keys locations
- [ ] Setup CI/CD pipeline (GitHub Actions) - optional

## Monitoring & Maintenance

- [ ] Monitor Vercel deployment logs
- [ ] Monitor Supabase database usage
- [ ] Check audit logs regularly
- [ ] Backup database weekly
- [ ] Update dependencies monthly
- [ ] Monitor error rates and logs

## Rollback Plan

If deployment fails:

1. **Frontend:**
   - Revert to previous version in Vercel dashboard
   - Or redeploy from previous git commit

2. **Database:**
   - Supabase has automatic backups
   - Can restore from dashboard if needed

3. **Python Service:**
   - Revert to previous deployment
   - Or temporarily disable new features

## Security Checklist

- [ ] Service role key stored securely (not in git)
- [ ] Environment variables set in Vercel (not committed)
- [ ] `.env` files added to `.gitignore`
- [ ] No sensitive data in logs
- [ ] CORS configured properly
- [ ] Rate limiting configured (optional)
- [ ] HTTPS enforced (Vercel handles this)

## Performance Checklist

- [ ] Frontend builds successfully (check bundle size)
- [ ] No console errors in production
- [ ] Page load time < 3 seconds
- [ ] Database queries optimized
- [ ] Indexes created on frequently queried columns
- [ ] Caching configured (if needed)

---

**Deployment Date:** _________________  
**Deployed By:** _________________  
**Production URL:** _________________  
**Python Service URL:** _________________  

**Notes:**
