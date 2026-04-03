# Kuber Timesheet - Quick Start Guide

## Step 1: Clone Repository (if using Git)

```bash
git clone <your-repo-url>
cd kuber-timesheet
```

## Step 2: Start Python Microservice

```bash
cd services/nepali-date-service

# Install dependencies
uv pip install -r requirements.txt

# Run microservice
python app.py
```

Expected output:
```
INFO:     Started server process [1234]
INFO:     Waiting for application startup.
INFO:     Application startup complete [http://0.0.0.0:8000]
```

Service will be available at: `http://localhost:8000`

## Step 3: Setup Frontend

```bash
cd frontend

# Install dependencies
npm install

# Create .env.local (see .env.local.example)
cp .env.local.example .env.local

# Edit .env.local with your Supabase credentials
# NEXT_PUBLIC_SUPABASE_URL=your_url
# NEXT_PUBLIC_SUPABASE_ANON_KEY=your_key
# SUPABASE_SERVICE_ROLE_KEY=your_service_key
```

## Step 4: Create Supabase Database Schema

1. Go to **Supabase Dashboard** → **SQL Editor**
2. Create a new query
3. Copy contents of `database_schema.sql` from project root
4. Execute the query
5. Wait for completion (a few seconds)

## Step 5: Create Admin User (in Supabase)

### Method 1: Via SQL (Quick)

Go to **SQL Editor** and run:
```sql
-- 1. First, create auth user (replace with your email)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at)
values (
  gen_random_uuid(),
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'admin@company.com',
  crypt('AdminPassword123', gen_salt('bf')),
  now(),
  now(),
  now()
);

-- 2. Then add user to users table
insert into users (id, email, name, role)
select id, email, 'Admin Name', 'admin'
from auth.users
where email = 'admin@company.com';
```

### Method 2: Via Auth UI

1. Go to **Authentication** → **Users**
2. Click **Invite**
3. Enter email and send invite
4. User gets email with link
5. Then add to `users` table manually via SQL

## Step 6: Run Frontend

```bash
cd frontend
npm run dev
```

You should see:
```
▲ Next.js 14.x
  ◇ Local:        http://localhost:3000
```

## Step 7: Test the App

1. Open `http://localhost:3000`
2. You should see login page
3. Login with credentials:
   - Email: `admin@company.com`
   - Password: `AdminPassword123` (or whatever you set)
4. You should see dashboard
5. Click **Sign Out** to logout

## Step 8: Test Nepali Date Service

Open `http://localhost:8000/docs` to see interactive API documentation.

Try converting today's date:
- Endpoint: `POST /convert/english-to-nepali`
- Body: `{"year": 2026, "month": 4, "day": 3}`
- Expected result: Nepali date (e.g., 2082-11-21)

## ✅ Everything Working?

Great! Next steps:

### For Development:
1. Add more test users (both admin and employee)
2. Test time entry (clock in/out)
3. Review database schema
4. Build admin features (employee management, holidays)

### For Deployment:
1. Follow [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
2. Setup Vercel for frontend
3. Deploy Python microservice
4. Configure production Supabase (optional: separate project from dev)

## 🆘 Troubleshooting

### "Module not found" when running Python service
```bash
# Make sure dependencies are installed
uv pip install -r requirements.txt
```

### "NEXT_PUBLIC_SUPABASE_URL" not set
```bash
# Create .env.local with correct variables
cp .env.local.example .env.local
# Edit .env.local
# Restart Next.js dev server
```

### "Unauthorized" when trying to login
1. Check user exists in `auth.users` table
2. Check corresponding row exists in `users` table
3. Check role is set to 'admin' or 'employee'
4. Try resetting password via SQL

### Python service won't start
```bash
# Check Python version
python --version  # Should be 3.9+

# Reinstall dependencies
uv pip install -r requirements.txt --force

# Check port 8000 is not in use
# If in use, change PORT in .env or use different port
```

### Can't see data in tables
1. Go to Supabase SQL Editor
2. Run: `SELECT * FROM users;`
3. Check results
4. Verify RLS is not blocking (you should be admin)

## Key Files to Know

| File | Purpose |
|------|---------|
| `database_schema.sql` | Database tables and RLS policies |
| `frontend/.env.local` | Frontend configuration (Supabase creds) |
| `services/nepali-date-service/.env` | Python service config |
| `SETUP_GUIDE.md` | Detailed setup & deployment guide |
| `DEPLOYMENT_CHECKLIST.md` | Pre-deployment checklist |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│ Browser (Frontend)                                      │
│ - Login page (next.js)                                  │
│ - Dashboard (React)                                     │
│ - Clock In/Out buttons                                  │
└──────────────────┬──────────────────────────────────────┘
                   │ HTTP/REST
        ┌──────────┴──────────┐
        │                     │
┌───────▼──────────┐   ┌──────▼────────────────────┐
│ Next.js Backend  │   │ Python FastAPI Service    │
│ - API routes     │   │ - Date conversions        │
│ - Auth logic     │   │ - NPT timezone handling   │
│ - Database ops   │   │ - Nepali calendar logic   │
└───────┬──────────┘   └──────┬────────────────────┘
        │                     │
        │ SQL                 │
        └──────────┬──────────┘
                   │
        ┌──────────▼──────────┐
        │ Supabase (PostgreSQL)
        │ - Users table       │
        │ - Attendance data   │
        │ - Holidays          │
        │ - Audit logs        │
        └─────────────────────┘
```

---

**Need help?** Refer to [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed instructions.
