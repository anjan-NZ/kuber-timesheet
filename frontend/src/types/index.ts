// User & Authentication Types
export type UserRole = 'admin' | 'employee';

export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  is_active: boolean;
  created_at: string;
}

export interface AuthUser {
  id: string;
  email?: string; // Optional because Supabase auth allows undefined
  user_metadata?: {
    name?: string;
  };
}

// Attendance Record Types
export interface AttendanceRecord {
  id: string;
  user_id: string;
  entry_date: string; // Nepali date format: YYYY-MM-DD
  time_in: string | null; // ISO timestamp
  time_out: string | null; // ISO timestamp
  hours_worked: number | null; // Auto-calculated
  client_name: string | null;
  notes: string | null;
  is_locked: boolean;
  created_at: string;
  edited_at: string | null;
  edited_by_admin: boolean;
}

export interface ClockInRequest {
  entry_date: string; // Nepali date
  time_in: string; // ISO timestamp (after rounding)
  client_name?: string;
}

export interface ClockOutRequest {
  attendance_id: string;
  time_out: string; // ISO timestamp (after rounding)
  client_name?: string;
}

// Holiday Types
export interface Holiday {
  id: string;
  holiday_date: string; // Nepali date: YYYY-MM-DD
  description: string;
  created_at: string;
}

// Nepali Calendar Types
export interface NepaliDate {
  year: number;
  month: number;
  day: number;
  formatted: string;
}

export interface EnglishDate {
  year: number;
  month: number;
  day: number;
  formatted: string;
}

export interface DateConversionResponse {
  english_date: EnglishDate;
  nepali_date: NepaliDate;
  iso_string: string;
}

export interface CurrentDateResponse {
  english_date: EnglishDate & { timestamp: string };
  nepali_date: NepaliDate;
  timezone: string;
}

// Monthly Summary Types
export interface MonthlySummary {
  user_id: string;
  nepali_year: number;
  nepali_month: number;
  total_days_present: number;
  total_leave_days: number;
  total_hours_worked: number;
  total_holidays: number;
}

// Audit Log Types
export type AuditAction = 'clock_in' | 'clock_out' | 'edit' | 'delete';

export interface AuditLog {
  id: string;
  user_id: string;
  action: AuditAction;
  table_name: string;
  record_id: string;
  old_values: Record<string, any> | null;
  new_values: Record<string, any> | null;
  created_at: string;
}

// Time Rounding Types
export interface TimeRoundingResult {
  original_time: string; // ISO timestamp
  rounded_time: string; // ISO timestamp
  rounded_minutes: number;
}

// API Response Types
export interface ApiResponse<T> {
  data?: T;
  error?: string;
  message?: string;
  status: number;
}

export interface PaginationParams {
  page: number;
  limit: number;
  offset: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  total_pages: number;
}

// Excel Export Types
export interface ExportRequest {
  employee_id?: string;
  start_date?: string; // Nepali date
  end_date?: string; // Nepali date
  include_summaries: boolean;
  include_holidays: boolean;
  include_audit_logs: boolean;
}

// Filter Types
export interface RecordsFilter {
  employee_id?: string;
  nepali_year?: number;
  nepali_month?: number;
  start_date?: string;
  end_date?: string;
  page: number;
  limit: number;
}
