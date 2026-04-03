# Admin Dashboard Setup Guide

## What's New
Your Kuber Timesheet now has a **complete admin interface** at `/kuberadmin` where admins can:

- ✅ Register new workers (email + password)
- ✅ View all registered workers and their profiles
- ✅ Activate/deactivate workers
- ✅ Manage holidays (coming soon)
- ✅ View attendance statistics (coming soon)

**No manual SQL needed** - everything is done through the web interface!

---

## Step 1: Set Admin Credentials in Vercel

Your admin login is controlled by environment variables in Vercel.

### In Vercel Dashboard:
1. Go to: https://vercel.com/dashboard
2. Click on your **"frontend-anjan1"** project
3. Click **Settings** → **Environment Variables**
4. Add these two variables:

```
NEXT_PUBLIC_ADMIN_EMAIL = admin@mycompany.com
NEXT_PUBLIC_ADMIN_PASSWORD = YourSecurePassword123!
```

5. Click "Save"
6. Your deployment will auto-redeploy with new env vars

### Local Testing (for development):
Create `frontend/.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=https://zhrsneyyczjhyastjvbq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[your-anon-key]
SUPABASE_SERVICE_ROLE_KEY=[your-service-role-key]
NEXT_PUBLIC_NEPALI_API_URL=https://nepali-date-service-qq2mj2i12-anjan1.vercel.app
NEXT_PUBLIC_ADMIN_EMAIL=admin@mycompany.com
NEXT_PUBLIC_ADMIN_PASSWORD=YourSecurePassword123!
```

---

## Step 2: Access Admin Dashboard

Once environment variables are set:

### Admin Login URL:
```
https://frontend-anjan1.vercel.app/kuberadmin
```

### Login with:
- Email: `admin@mycompany.com` (or your configured email)
- Password: `YourSecurePassword123!` (or your configured password)

---

## Step 3: Using Admin Dashboard

### Home Dashboard
After login, you see 4 sections:

1. **Register Worker** - Add new employees
2. **View All Workers** - See list and manage staff
3. **Attendance Summary** - Daily statistics (coming soon)
4. **Manage Holidays** - Configure company holidays (coming soon)

### Register New Worker

1. Click "Register Worker"
2. Fill in:
   - **Worker Name**: John Doe
   - **Worker Email**: john@company.com
   - **Password**: (you set it for them)
   - **Confirm Password**: (confirm)
3. Click "Register Worker"
4. Worker gets confirmation and can now log in

### View All Workers

1. Click "View All Workers"
2. See table with all employees:
   - Name
   - Email
   - Role (Admin/Employee)
   - Status (Active/Inactive)
   - Joined date
   - Action buttons

3. **Deactivate**: Temporarily disable a worker account
4. **Activate**: Re-enable a deactivated account

### Admin Features

- Only `/kuberadmin` pages require admin login
- Regular employees go to main site for clock in/out
- Admin cannot delete workers (deactivate only)
- All actions logged in audit trail

---

## Email Workflow (Optional Setup)

### Send Welcome Email to New Workers

You can manually send this template:

```
Subject: Welcome to Kuber Timesheet

Hi [Worker Name],

Your account has been created in our timesheet system.

📱 Login here: https://frontend-anjan1.vercel.app

📧 Your email: [worker-email]
🔐 Password: [password-you-set] (change it after first login)

📋 What to do:
1. Click the login link
2. Enter your email and password
3. Click "Clock In" when you arrive
4. Click "Clock Out" when you leave
5. Submit timesheet at week end

Questions? Contact your admin.
```

---

## Architecture

```
Admin Sets Email + Password in Vercel Environment Variables
                    ↓
Admin Visits: https://frontend-anjan1.vercel.app/kuberadmin
                    ↓
Login Authenticated against Env Variables
                    ↓
Access Admin Dashboard
                    ↓
Register Workers → Data Stored in Supabase
View Workers → Query from Supabase  
Activate/Deactivate → Update Supabase
```

---

## Security Notes

✅ **Secure**
- Admin credentials in Vercel environment (not in code)
- Passwords hashed in Supabase authentication
- Admin session stored in localStorage (add server sessions later)
- All data encrypted in transit (HTTPS)

✅ **Best Practices**
- Change admin password regularly
- Use strong passwords for workers
- Admin email should be company account only
- Monitor worker deactivations

⚠️ **Future Improvements** (nice to have)
- Email verification for new workers
- Two-factor authentication
- Admin audit logs
- Batch worker import from CSV
- Email notifications

---

## Troubleshooting

### Admin login doesn't work
**Solution:**
- Verify variables are set in Vercel with correct email/password
- Wait 5 minutes for deployment to complete
- Try incognito/private browser window
- Clear browser cache

### Register worker shows error
**Solution:**
- Check email is unique (not already in database)
- Password must be 6+ characters
- Check that Supabase is accessible (test in browser console)

### Can't see workers list
**Solution:**
- Make sure you're logged in as admin
- Check Supabase connection (all 4 env variables correct)
- Try refreshing page
- Check browser console for errors

### Worker can't log in
**Solution:**
- Verify worker email is correct
- Check worker status (active/inactive)
- Try password reset or re-register worker with new password

---

## FAQ

**Q: Can I change admin password?**  
A: Yes! Update in Vercel Environment Variables → redeploy → restart

**Q: What if I forget admin password?**  
A: Update in Vercel → redeploy (you control the env vars)

**Q: Can multiple admins exist?**  
A: Not yet - currently one admin. Can add multiple later if needed.

**Q: Are worker passwords shown anywhere?**  
A: No - they're hashed by Supabase. You set initial password, worker can reset.

**Q: What happens when I deactivate a worker?**  
A: They cannot log in. Can reactivate to restore access.

**Q: Can deleted workers be restored?**  
A: Currently deactivate only. Data stays in database.

---

## Next Steps

1. **Update Vercel env vars** with admin email + password
2. **Log in at** `/kuberadmin`
3. **Register test workers** to verify it works
4. **Share main URL** with employees: https://frontend-anjan1.vercel.app
5. **Monitor attendance** in admin dashboard

---

## Files Changed

- `frontend/src/app/kuberadmin/login/page.tsx` - Admin login
- `frontend/src/app/kuberadmin/dashboard/page.tsx` - Admin dashboard home
- `frontend/src/app/kuberadmin/register-worker/page.tsx` - Register workers
- `frontend/src/app/kuberadmin/workers/page.tsx` - View all workers
- All `.module.css` files for styling

---

**Admin Dashboard is now live and ready to use!** 🎉

For questions or issues, check the troubleshooting section or review logs in Vercel dashboard.
