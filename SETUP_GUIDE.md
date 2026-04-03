# Kuber Timesheet - Setup Guide

A cloud-based attendance tracking web application for offices with secure authentication, Nepali calendar support, and audit tracking.

## Project Structure

```
kuber-timesheet/
├── frontend/              # Next.js web application (React + TypeScript)
│   ├── app/              # App router pages & layouts
│   ├── src/
│   │   ├── lib/          # Utility functions (time, auth, Supabase, etc.)
│   │   ├── types/        # TypeScript interfaces
│   │   ├── components/   # React components
│   │   └── middleware.ts # Route protection & auth
│   ├── package.json
│   ├── tsconfig.json
│   ├── next.config.js
│   └── .env.local        # Environment variables
│
├── services/
│   └── nepali-date-service/  # Python FastAPI microservice
│       ├── app.py            # FastAPI application
│       ├── requirements.txt   # Python dependencies
│       ├── pyproject.toml     # Project config (uv)
│       ├── vercel.json        # Vercel deployment config
│       └── .env               # Environment variables
│
├── database_schema.sql   # Supabase database schema
└── README.md
```

## Prerequisites

- **Node.js** v18+ (installed)
- **Python** 3.9+ (installed via uv)
- **Supabase Account** (create at: https://supabase.com)
- **Vercel Account** (create at: https://vercel.com)
- **Git** (for version control)

## Step 1: Supabase Setup

1. **Create a Supabase Project:**
   - Go to https://supabase.com
   - Create a new project with a strong password
   - Wait for project to initialize
   - Save your database credentials

2. **Create Database Schema:**
   - Open Supabase Dashboard → SQL Editor
   - Create a new query
   - Copy contents of `database_schema.sql` and execute
   - Verify tables are created: `users`, `attendance_records`, `holidays`, `audit_logs`

3. **Setup Authentication:**
   - Go to Authentication → Providers
   - Ensure Email/Password is enabled
   - Set up email templates (verify email, password reset, etc.)

4. **Get API Keys:**
   - Go to Settings → API
   - Copy `Project URL` and `anon key`
   - Copy `Service Role Secret` (keep secure!)
   - You'll need these for `.env.local`

## Step 2: Configure Frontend

1. **Install Dependencies:**
   ```bash
   cd frontend
   npm install
   ```

2. **Setup Environment Variables:**
   - Copy `.env.local` template
   - Fill in your Supabase credentials:
     ```
     NEXT_PUBLIC_SUPABASE_URL=your_project_url
     NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
     SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
     NEXT_PUBLIC_NEPALI_API_URL=http://localhost:8000
     ```

3. **Run Development Server:**
   ```bash
   npm run dev
   ```
   - Open http://localhost:3000
   - You should see the login page

## Step 3: Setup Python Microservice

1. **Install Dependencies:**
   ```bash
   cd services/nepali-date-service
   uv pip install -r requirements.txt
   ```

2. **Run Microservice Locally:**
   ```bash
   python app.py
   ```
   - Service will start on `http://localhost:8000`
   - Test health endpoint: `http://localhost:8000/docs` (Swagger UI)

3. **Test Date Conversion:**
   - Go to http://localhost:8000/docs
   - Try the POST `/convert/english-to-nepali` endpoint
   - Example input: `{"year": 2026, "month": 4, "day": 3}`

## Step 4: Create First Admin User

Since only pre-generated accounts can access the system:

1. **In Supabase Dashboard:**
   - Go to Authentication → Users
   - Click "Invite" → Invite by email
   - Create admin user (e.g., admin@company.com)
   - Set a temporary password

2. **Add to Users Table:**
   - Go to SQL Editor
   - Run this query:
     ```sql
     insert into users (id, email, name, role)
     select id, email, 'Admin Name', 'admin'
     from auth.users
     where email = 'admin@company.com';
     ```

3. **Test Login:**
   - Go to http://localhost:3000/login
   - Login with admin@company.com and password
   - You should access the admin dashboard

## Step 5: Deployment to Vercel

### Frontend Deployment:

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Deploy to Vercel:**
   - Go to https://vercel.com
   - Click "New Project"
   - Import GitHub repository
   - Set environment variables (from Supabase)
   - Deploy

### Python Microservice Deployment:

1. **Deploy to Vercel (Python):**
   - In `services/nepali-date-service/`
   - Push to a separate repo or as a separate deployment
   - Create `api/index.py` wrapper for Vercel serverless
   - Configure `vercel.json` for Python runtime
   - Deploy

2. **Update Frontend Config:**
   - After microservice is deployed, update `NEXT_PUBLIC_NEPALI_API_URL` in Vercel environment variables
   - Set to your deployed Python service URL

## Database Schema Overview

### Users Table
- `id` (UUID): Unique identifier
- `email` (text): User email
- `name` (text): User full name
- `role` (enum): 'admin' or 'employee'
- `is_active` (boolean): Account status

### Attendance Records Table
- `id` (UUID): Unique record ID
- `user_id` (FK): Reference to users
- `entry_date` (date): Date in Nepali calendar (YYYY-MM-DD)
- `time_in` (timestamp): Clock in time (rounded)
- `time_out` (timestamp): Clock out time (rounded)
- `hours_worked` (numeric): Auto-calculated hours
- `client_name` (text): Client name for tracking
- `is_locked` (boolean): True if past 12:00 PM on same day
- `is_admin` (boolean): Indicates if created by admin

### Holidays Table
- `id` (UUID): Unique holiday ID
- `holiday_date` (date): Date in Nepali calendar
- `description` (text): Holiday name/description

### Audit Logs Table
- `id` (UUID): Unique log ID
- `user_id` (FK): Which user made the change
- `action` (enum): 'clock_in', 'clock_out', 'edit', 'delete'
- `table_name` (text): Which table was modified
- `record_id` (UUID): Which record was modified
- `old_values` (JSONB): Previous values
- `new_values` (JSONB): New values
- `created_at` (timestamp): When change occurred

## Row Level Security (RLS)

All data access is protected by Supabase RLS policies:

- **Employees** can only view their own attendance records
- **Employees** can only edit entries on the same day before 12:00 PM
- **Admins** can view all employee records and edit anytime
- **Holidays** are public read, admin write only
- **Audit logs** are admin-only (with personal log access for users)

## Time Rounding Logic

Times are automatically rounded to nearest 5-minute interval:
- 9:02 → 9:00
- 9:03 → 9:05
- 9:08 → 9:10
- 9:28 → 9:30
- 9:56 → 10:00

## Nepal Time (NPT)

- Expected timezone: `UTC+5:45`
- All times stored as UTC in database
- Converted to NPT for display
- Microservice handles conversions

## Common Issues

### "API error: 409" when deploying
- Ensure Supabase project is active
- Check RLS policies are correct
- Verify service role key has permissions

### Nepali microservice returns errors
- Ensure Python dependencies are installed correctly
- Check CORS configuration in microservice
- Verify Python version is 3.9+

### "NEXT_PUBLIC_SUPABASE_URL" not defined
- Ensure `.env.local` is in `frontend/` directory
- Verify environment variables are set correctly
- Restart dev server after changing `.env`

### Can't login after creating user
- Confirm user exists in `auth.users` table
- Check `users` table has corresponding row
- Verify user role is set correctly (admin/employee)

## Next Steps

After setup:

1. **Admin Features:**
   - Add employees (admin dashboard)
   - Define holidays for the month
   - Review employee attendance

2. **Employee Features:**
   - Clock in/out daily
   - View monthly attendance records
   - Export personal records

3. **Monitoring:**
   - Check audit logs regularly
   - Monitor system performance
   - Backup database regularly

## Support & Documentation

- **Supabase Docs**: https://supabase.com/docs
- **Next.js Docs**: https://nextjs.org/docs
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **Nepali DateTime Library**: https://github.com/nepalese/nepali-datetime

## License

Private project for Kuber Consulting.

---

**Created:** April 3, 2026
**Last Updated:** April 3, 2026
