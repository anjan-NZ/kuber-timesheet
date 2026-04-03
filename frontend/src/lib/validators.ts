import { User } from '@/types';

/**
 * Validate email format
 */
export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validate password strength (basic)
 */
export function validatePassword(password: string): {
  valid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (password.length < 6) {
    errors.push('Password must be at least 6 characters');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
}

/**
 * Validate user profile
 */
export function validateUserProfile(user: Partial<User>): {
  valid: boolean;
  errors: Record<string, string>;
} {
  const errors: Record<string, string> = {};

  if (!user.email || !validateEmail(user.email)) {
    errors.email = 'Valid email is required';
  }

  if (!user.name || user.name.trim().length < 2) {
    errors.name = 'Name must be at least 2 characters';
  }

  if (!user.role || !['admin', 'employee'].includes(user.role)) {
    errors.role = 'Valid role is required';
  }

  return {
    valid: Object.keys(errors).length === 0,
    errors,
  };
}

/**
 * Validate attendance date (Nepali format: YYYY-MM-DD)
 */
export function validateNepaliDate(dateString: string): {
  valid: boolean;
  error?: string;
} {
  const regex = /^\d{4}-\d{2}-\d{2}$/;

  if (!regex.test(dateString)) {
    return {
      valid: false,
      error: 'Date must be in YYYY-MM-DD format',
    };
  }

  const [yearStr, monthStr, dayStr] = dateString.split('-');
  const year = parseInt(yearStr, 10);
  const month = parseInt(monthStr, 10);
  const day = parseInt(dayStr, 10);

  // Basic Nepali calendar validation (Bikram Sambat)
  if (year < 1970 || year > 2100) {
    return {
      valid: false,
      error: 'Year must be between 1970 and 2100',
    };
  }

  if (month < 1 || month > 12) {
    return {
      valid: false,
      error: 'Month must be between 1 and 12',
    };
  }

  if (day < 1 || day > 32) {
    return {
      valid: false,
      error: 'Day must be between 1 and 32',
    };
  }

  return { valid: true };
}

/**
 * Validate client name
 */
export function validateClientName(name: string | null): boolean {
  if (!name) return true; // Optional field
  return name.trim().length >= 2;
}
