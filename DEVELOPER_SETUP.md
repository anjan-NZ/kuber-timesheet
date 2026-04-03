# 👨‍💻 DEVELOPER SETUP GUIDE

**Status**: Complete production system with source code ready for cloning and local development

---

## Quick Start for Developers

### Prerequisites
- Node.js 18+ and npm
- Python 3.12+
- Git
- Text editor (VS Code recommended)
- Supabase account (optional for local dev)
- Vercel account (optional for deployment)

### Step 1: Clone Repository
```bash
git clone https://github.com/anjan-NZ/kuber-timesheet.git
cd kuber-timesheet
```

### Step 2: Frontend Setup
```bash
cd frontend
npm install
cp .env.local.example .env.local  # Copy and adjust if needed
npm run dev
```
Frontend runs on: http://localhost:3000

### Step 3: Python API Setup
```bash
cd services/nepali-date-service
python -m venv .venv
# On Windows: .venv\Scripts\activate
# On Mac/Linux: source .venv/bin/activate
pip install -r requirements.txt
python -m uvicorn app:app --reload
```
API runs on: http://localhost:8000

### Step 4: Database Setup (Optional)
Use the existing Supabase project or create a local PostgreSQL instance:
```bash
# Using existing Supabase (recommended for testing):
# Set NEXT_PUBLIC_SUPABASE_URL and keys in frontend/.env.local
```

---

## Project Structure

```
kuber-timesheet/
├── frontend/                          # Next.js React application
│   ├── src/
│   │   ├── app/                      # App router pages
│   │   ├── components/               # React components
│   │   ├── lib/
│   │   │   ├── supabase.ts          # Supabase client
│   │   │   └── nepali-api.ts        # Python API client
│   │   └── styles/                   # CSS styles
│   ├── .env.local                    # Environment variables
│   ├── next.config.ts                # Next.js config
│   └── package.json                  # Dependencies
│
├── services/
│   └── nepali-date-service/         # FastAPI microservice
│       ├── app.py                    # Main FastAPI app
│       ├── requirements.txt          # Python dependencies
│       ├── vercel.json               # Vercel config
│       └── .venv/                    # Virtual environment
│
├── database_schema.sql               # Database schema
├── MASTER_README.md                  # This document
├── NEXT_STEPS_IMPLEMENTATION.md      # Implementation guide
├── TROUBLESHOOTING.md                # Issue resolution
└── .git/                             # Version control
```

---

## Frontend Development

### Technology Stack
- **Framework**: Next.js 16.2.2
- **UI Library**: React 19
- **Language**: TypeScript
- **Auth**: Supabase Auth
- **Database**: Supabase PostgreSQL
- **Styling**: CSS Modules / Tailwind
- **API Calls**: Axios

### Key Files

**src/app/page.tsx** - Home page
- Login/signup interface
- Redirect to dashboard if authenticated

**src/app/dashboard/page.tsx** - Main dashboard
- Clock in/out functionality
- Attendance display
- Timesheet submission

**src/lib/supabase.ts** - Database client
```typescript
// Initialize Supabase client
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);
```

**src/lib/nepali-api.ts** - Python API client
```typescript
// Call Python microservice
const response = await fetch(
  `${process.env.NEXT_PUBLIC_NEPALI_API_URL}/convert/english-to-nepali`,
  { method: 'POST', body: JSON.stringify({ date: '2026-04-03' }) }
);
```

### Running Locally
```bash
cd frontend
npm install
npm run dev
# Open http://localhost:3000
```

### Development Build Commands
```bash
npm run dev       # Start dev server with hot reload
npm run build     # Build for production
npm run lint      # Run ESLint
npm run type-check # Check TypeScript
```

### Environment Variables (frontend/.env.local)
```
NEXT_PUBLIC_SUPABASE_URL=https://zhrsneyyczjhyastjvbq.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[your-anon-key]
SUPABASE_SERVICE_ROLE_KEY=[your-service-role-key]
NEXT_PUBLIC_NEPALI_API_URL=https://nepali-date-service-qq2mj2i12-anjan1.vercel.app
```

---

## Python API Development

### Technology Stack
- **Framework**: FastAPI
- **Server**: Uvicorn
- **Date Library**: nepali-datetime
- **CORS**: Enabled
- **Deployment**: Vercel

### Key Files

**app.py** - Main FastAPI application
- Health check endpoint: `/health`
- Date conversion: `/convert/english-to-nepali`
- Current date: `/date/current`

### Running Locally
```bash
cd services/nepali-date-service
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python -m uvicorn app:app --reload
```

API runs at: http://localhost:8000

### API Endpoints

**Health Check**
```
GET /health
Response: {"status": "ok"}
```

**Convert English to Nepali**
```
POST /convert/english-to-nepali
Body: {"date": "2026-04-03"}
Response: {"nepali_date": "2082-12-20"}
```

**Convert Nepali to English**
```
POST /convert/nepali-to-english
Body: {"date": "2082-12-20"}
Response: {"english_date": "2026-04-03"}
```

**Current Date**
```
GET /date/current
Response: {"english_date": "2026-04-03", "nepali_date": "2082-12-20"}
```

### Development Commands
```bash
python -m uvicorn app:app --reload           # Dev server
pip install -r requirements.txt              # Install deps
pip freeze > requirements.txt                # Update deps
python app.py                                # Run directly
```

---

## Database Development

### Schema Overview

**users** table
```sql
- id (UUID, primary key)
- email (text, unique)
- name (text)
- role (text: 'admin' or 'employee')
- is_active (boolean)
- created_at (timestamp)
- updated_at (timestamp)
```

**attendance_records** table
```sql
- id (UUID)
- user_id (FK to users)
- entry_date (text, Nepali format YYYY-MM-DD)
- time_in (time, nullable)
- time_out (time, nullable)
- hours_worked (float, auto-calculated)
- notes (text, nullable)
- created_at (timestamp)
- updated_at (timestamp)
- Constraint: Unique per user per day
```

**holidays** table
```sql
- id (UUID)
- holiday_date (text, Nepali format)
- description (text)
- type (text: 'national', 'company', 'optional')
```

**audit_logs** table
```sql
- id (UUID)
- action (text)
- table_name (text)
- record_id (UUID, nullable)
- old_values (jsonb)
- new_values (jsonb)
- created_by (UUID, FK to users)
- created_at (timestamp)
```

### Deploy Local Schema Changes
```sql
-- Connect to local/test database
-- Run SQL queries from database_schema.sql
-- Or use Supabase SQL Editor in console
```

### Access Database Console
```
https://app.supabase.co
→ Select project: zhrsneyyczjhyastjvbq
→ SQL Editor tab
→ Run queries
```

---

## Local Testing

### Test Frontend Locally
```bash
cd frontend
npm run dev
# Open http://localhost:3000
# Create test account
# Test clock in/out
```

### Test API Locally
```bash
cd services/nepali-date-service
python -m uvicorn app:app --reload

# In another terminal:
curl http://localhost:8000/health
curl -X POST http://localhost:8000/convert/english-to-nepali \
  -H "Content-Type: application/json" \
  -d '{"date": "2026-04-03"}'
```

### Connect Local Frontend to Local API
```bash
# In frontend/.env.local:
NEXT_PUBLIC_NEPALI_API_URL=http://localhost:8000

# npm run dev
```

### Test with Production Services
```bash
# Leave .env.local pointing to production:
NEXT_PUBLIC_NEPALI_API_URL=https://nepali-date-service-qq2mj2i12-anjan1.vercel.app
NEXT_PUBLIC_SUPABASE_URL=https://zhrsneyyczjhyastjvbq.supabase.co

# npm run dev
```

---

## Deployment from Local

### Deploy Frontend to Vercel
```bash
cd frontend

# Option 1: Using Vercel CLI
npm i -g vercel
vercel

# Option 2: Using Git push (if linked to GitHub)
git push origin main
# Vercel auto-deploys on push
```

### Deploy Python API to Vercel
```bash
cd services/nepali-date-service

# Using Vercel CLI
npm i -g vercel
vercel
```

### Both Services Auto-Deploy
Once connected to GitHub, both services auto-deploy on push:
```bash
git add .
git commit -m "Your changes"
git push origin main
# Both Vercel projects auto-deploy
```

---

## Debugging

### Frontend Debugging
```bash
# VS Code: F5 to debug
# Browser DevTools: F12
# Next.js Server: Check terminal output during npm run dev

# Check logs in production:
# https://vercel.com/dashboard → frontend-anjan1 → Deployments → Logs
```

### Python API Debugging
```bash
# Terminal output shows all requests during: python -m uvicorn app:app --reload
# Add print() statements to debug
# Use FastAPI docs: http://localhost:8000/docs (Swagger UI)

# Check logs in production:
# https://vercel.com/dashboard → nepali-date-service → Deployments → Logs
```

### Database Debugging
```
# Use Supabase console:
https://app.supabase.co → Logs
# Shows all database queries, slow queries, errors

# Run test query in SQL Editor:
SELECT * FROM attendance_records ORDER BY created_at DESC LIMIT 5;
```

---

## Common Development Tasks

### Add New Frontend Page
```typescript
// Create: frontend/src/app/newpage/page.tsx
export default function NewPage() {
  return <div>New Page</div>;
}
// Access at: http://localhost:3000/newpage
```

### Add New API Endpoint
```python
# Add to services/nepali-date-service/app.py
@app.get("/new-endpoint")
def new_endpoint():
    return {"message": "Hello"}

# Test at: http://localhost:8000/new-endpoint
```

### Add New Database Table
```sql
-- Run in Supabase SQL Editor
CREATE TABLE new_table (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Update Dependencies
```bash
# Frontend
cd frontend
npm update
npm install new-package

# Python
cd services/nepali-date-service
pip install --upgrade package-name
pip freeze > requirements.txt
```

---

## Git Workflow

### Clone & Setup
```bash
git clone https://github.com/anjan-NZ/kuber-timesheet.git
cd kuber-timesheet
```

### Create Feature Branch
```bash
git checkout -b feature/your-feature-name
# Make changes
git add .
git commit -m "Add your feature"
git push origin feature/your-feature-name
# Create Pull Request on GitHub
```

### Update from Main
```bash
git fetch origin
git rebase origin/main
git push origin your-branch --force-with-lease
```

### Merge to Main
```bash
git checkout main
git pull origin main
git merge feature/your-feature-name
git push origin main
# Auto-deploys to Vercel
```

---

## Troubleshooting Development

### Frontend won't start
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### Python API won't start
```bash
# Reinstall dependencies
rm -rf .venv
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
pip install -r requirements.txt
python -m uvicorn app:app --reload
```

### Database connection fails
```bash
# Check credentials in .env.local:
# NEXT_PUBLIC_SUPABASE_URL and keys must be correct
# Test in Supabase console: https://app.supabase.co
```

### Port 3000 or 8000 already in use
```bash
# Frontend (use different port)
npm run dev -- -p 3001

# Python API (use different port)
python -m uvicorn app:app --reload --port 8001
```

---

## Production Considerations

### Environment Variables
- Never commit `.env.local`
- Use `.env.example` for documentation
- All secrets in environment (not code)
- Rotate keys periodically

### Performance
- Frontend builds should have 0 TypeErrors
- Python API should handle 100+ concurrent requests
- Database queries should complete in <100ms
- Use caching where appropriate

### Security
- Always validate input
- Use prepared statements (already done with Supabase)
- Enable HTTPS (done by Vercel)
- Implement rate limiting if needed
- Regular security audits

### Monitoring
- Check Vercel dashboards daily
- Review database logs weekly
- Monitor error rates
- Track performance metrics

---

## Next Steps

1. Clone the repository
2. Set up frontend locally
3. Set up Python API locally
4. Make a test change
5. Push to GitHub
6. Verify auto-deployment to Vercel

---

## Support

- **Issues**: https://github.com/anjan-NZ/kuber-timesheet/issues
- **Documentation**: See MASTER_README.md and NEXT_STEPS_IMPLEMENTATION.md
- **Troubleshooting**: See TROUBLESHOOTING.md

---

*Version: 1.0*  
*Last Updated: April 3, 2026*  
*Status: Production Ready*
