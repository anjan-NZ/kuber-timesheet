-- Kuber Timesheet Database Schema
-- Supabase PostgreSQL Database
-- Created: 2026-04-03

-- Enable UUID extension
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- ============================================================================
-- USERS TABLE
-- ============================================================================
create table if not exists users (
  id uuid primary key default auth.uid(),
  email text unique not null,
  name text not null,
  role text check (role in ('admin', 'employee')) not null default 'employee',
  is_active boolean not null default true,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- ============================================================================
-- ATTENDANCE_RECORDS TABLE
-- ============================================================================
create table if not exists attendance_records (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references users(id) on delete cascade,
  entry_date date not null, -- Nepali calendar date stored as YYYY-MM-DD
  time_in timestamp with time zone,
  time_out timestamp with time zone,
  hours_worked numeric(5, 2), -- auto-calculated from time_out - time_in
  client_name text,
  notes text,
  is_locked boolean not null default false,
  created_at timestamp with time zone default now(),
  edited_at timestamp with time zone,
  created_by_admin boolean default false,
  edited_by_admin boolean default false,
  
  -- Ensure unique entry per user per day
  constraint unique_entry_per_day unique (user_id, entry_date)
);

-- ============================================================================
-- HOLIDAYS TABLE
-- ============================================================================
create table if not exists holidays (
  id uuid primary key default uuid_generate_v4(),
  holiday_date date not null unique, -- Nepali calendar date
  description text not null,
  created_at timestamp with time zone default now()
);

-- ============================================================================
-- AUDIT_LOGS TABLE
-- ============================================================================
create table if not exists audit_logs (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references users(id) on delete set null,
  action text not null check (action in ('clock_in', 'clock_out', 'edit', 'delete', 'create')),
  table_name text not null,
  record_id uuid,
  old_values jsonb,
  new_values jsonb,
  created_at timestamp with time zone default now()
);

-- ============================================================================
-- INDEXES
-- ============================================================================
create index if not exists idx_attendance_user_id on attendance_records(user_id);
create index if not exists idx_attendance_entry_date on attendance_records(entry_date);
create index if not exists idx_attendance_user_date on attendance_records(user_id, entry_date);
create index if not exists idx_attendance_created_at on attendance_records(created_at);
create index if not exists idx_holidays_holiday_date on holidays(holiday_date);
create index if not exists idx_audit_logs_user_id on audit_logs(user_id);
create index if not exists idx_audit_logs_created_at on audit_logs(created_at);
create index if not exists idx_audit_logs_record_id on audit_logs(record_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS on all tables
alter table users enable row level security;
alter table attendance_records enable row level security;
alter table holidays enable row level security;
alter table audit_logs enable row level security;

-- Users: Employees can only see their own record, Admins can see all
create policy "Users can read own record" on users
  for select using (auth.uid() = id OR auth.jwt()->>'role' = 'admin');

create policy "Admins can read all users" on users
  for select using (auth.jwt()->>'role' = 'admin');

-- Attendance Records: Employees can only see own, Admins can see all
create policy "Employees can view own attendance" on attendance_records
  for select using (user_id = auth.uid() OR auth.jwt()->>'role' = 'admin');

create policy "Employees can create own attendance" on attendance_records
  for insert with check (user_id = auth.uid());

create policy "Employees can update own attendance same-day" on attendance_records
  for update using (
    user_id = auth.uid() 
    and auth.jwt()->>'role' = 'employee'
    and created_at::date = current_date
    and extract(hour from now()) < 12
  );

create policy "Admins can update any attendance" on attendance_records
  for update using (auth.jwt()->>'role' = 'admin');

create policy "Admins can delete any attendance" on attendance_records
  for delete using (auth.jwt()->>'role' = 'admin');

-- Holidays: Everyone can read, only admins can write
create policy "Everyone can view holidays" on holidays
  for select using (true);

create policy "Admins can manage holidays" on holidays
  for all using (auth.jwt()->>'role' = 'admin');

-- Audit Logs: Admins can read all, users can see own
create policy "Users can view own audit logs" on audit_logs
  for select using (user_id = auth.uid());

create policy "Admins can view all audit logs" on audit_logs
  for select using (auth.jwt()->>'role' = 'admin');

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function to automatically update updated_at timestamp
create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Trigger to update updated_at on users table
create trigger update_users_updated_at
  before update on users
  for each row
  execute function update_updated_at_column();

-- Function to auto-calculate hours_worked when time_out is set
create or replace function calculate_hours_worked()
returns trigger as $$
begin
  if new.time_out is not null and new.time_in is not null then
    new.hours_worked = extract(epoch from (new.time_out - new.time_in)) / 3600;
  else
    new.hours_worked = null;
  end if;
  return new;
end;
$$ language plpgsql;

-- Trigger to auto-calculate hours_worked
create trigger calculate_hours_on_insert_update
  before insert or update on attendance_records
  for each row
  execute function calculate_hours_worked();

-- ============================================================================
-- COMMENTS (Documentation)
-- ============================================================================
comment on table users is 'Stores employee and admin user information';

comment on table attendance_records is 'Stores daily attendance records for employees';
comment on column attendance_records.entry_date is 'Date in Nepali calendar (Bikram Sambat) format: YYYY-MM-DD';
comment on column attendance_records.hours_worked is 'Auto-calculated: (time_out - time_in) in decimal hours';
comment on column attendance_records.is_locked is 'True if entry is locked (past 12:00 PM same day for employees)';

comment on table holidays is 'Admin-defined holidays for the organization';
comment on column holidays.holiday_date is 'Date in Nepali calendar (Bikram Sambat) format: YYYY-MM-DD';

comment on table audit_logs is 'Tracks all changes to attendance records for audit compliance';
