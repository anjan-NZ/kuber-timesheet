import { TimeRoundingResult } from '@/types';

/**
 * Round time to nearest 5 or 0 minutes
 * Logic:
 * - 00-02 minutes → 00
 * - 03-07 minutes → 05
 * - 08-12 minutes → 10
 * - ... and so on
 * Examples:
 *  - 9:02 → 9:00
 *  - 9:03 → 9:05
 *  - 9:08 → 9:10
 *  - 9:28 → 9:30
 *  - 9:56 → 10:00
 */
export function roundTimeToNearestFiveMinutes(date: Date): Date {
  const minutes = date.getMinutes();
  const remainder = minutes % 5;

  let roundedMinutes: number;

  if (remainder === 0) {
    // Already on 5-minute interval
    roundedMinutes = minutes;
  } else if (remainder < 3) {
    // Round down to previous 5-minute interval
    roundedMinutes = minutes - remainder;
  } else {
    // Round up to next 5-minute interval
    roundedMinutes = minutes + (5 - remainder);
  }

  // Handle hour overflow
  const resultDate = new Date(date);
  resultDate.setMinutes(roundedMinutes);
  resultDate.setSeconds(0);
  resultDate.setMilliseconds(0);

  return resultDate;
}

/**
 * Get the rounding result with before/after comparison
 */
export function getRoundingResult(originalTime: Date): TimeRoundingResult {
  const rounded = roundTimeToNearestFiveMinutes(originalTime);

  return {
    original_time: originalTime.toISOString(),
    rounded_time: rounded.toISOString(),
    rounded_minutes: rounded.getMinutes(),
  };
}

/**
 * Calculate hours worked (time_out - time_in)
 * Returns number of hours as decimal (e.g., 8.5 for 8 hours 30 minutes)
 */
export function calculateHoursWorked(
  timeIn: Date,
  timeOut: Date
): number | null {
  if (!timeIn || !timeOut) {
    return null;
  }

  // Validate that timeOut is after timeIn
  if (timeOut <= timeIn) {
    throw new Error('Time out must be after time in');
  }

  const diffMs = timeOut.getTime() - timeIn.getTime();
  const diffHours = diffMs / (1000 * 60 * 60); // Convert ms to hours

  // Round to 2 decimal places
  return Math.round(diffHours * 100) / 100;
}

/**
 * Format duration in seconds to human-readable format
 * Examples: "8h 30m", "2h 15m"
 */
export function formatDuration(seconds: number): string {
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);

  if (hours === 0) {
    return `${minutes}m`;
  }
  return `${hours}h ${minutes}m`;
}

/**
 * Check if a time entry is locked (12:00 PM same day)
 * An entry is locked if it's past 12:00 PM on the same day it was created
 */
export function isEntryLocked(
  createdAt: Date,
  currentTime: Date,
  userRole: 'admin' | 'employee'
): boolean {
  // Admin can always edit
  if (userRole === 'admin') {
    return false;
  }

  // Check if same day
  const createdDate = new Date(createdAt);
  const currentDate = new Date(currentTime);

  const sameDay =
    createdDate.getUTCDate() === currentDate.getUTCDate() &&
    createdDate.getUTCMonth() === currentDate.getUTCMonth() &&
    createdDate.getUTCFullYear() === currentDate.getUTCFullYear();

  if (!sameDay) {
    // Not same day, so it's locked
    return true;
  }

  // Same day: check if past 12:00 PM (noon)
  const noonTime = new Date(currentDate);
  noonTime.setUTCHours(12, 0, 0, 0);

  return currentTime >= noonTime;
}

/**
 * Validate time entry data
 */
export function validateTimeEntry(
  timeIn: Date | null,
  timeOut: Date | null | undefined
): { valid: boolean; error?: string } {
  if (!timeIn) {
    return { valid: false, error: 'Time in is required' };
  }

  if (timeOut && timeOut <= timeIn) {
    return { valid: false, error: 'Time out must be after time in' };
  }

  return { valid: true };
}

/**
 * Convert decimal hours to hours and minutes
 * Example: 8.5 → { hours: 8, minutes: 30 }
 */
export function decimalHoursToHoursMinutes(
  decimalHours: number
): { hours: number; minutes: number } {
  const hours = Math.floor(decimalHours);
  const minutes = Math.round((decimalHours - hours) * 60);

  return { hours, minutes };
}

/**
 * Get Nepal Time (NPT) offset from UTC
 * NPT is UTC+5:45
 */
export function getNPTOffset(): { hours: number; minutes: number } {
  return { hours: 5, minutes: 45 };
}

/**
 * Convert a date to NPT timezone
 */
export function toNPTDate(date: Date): Date {
  const utcDate = new Date(date);

  // NPT is UTC+5:45, so add 5 hours and 45 minutes
  utcDate.setHours(utcDate.getHours() + 5);
  utcDate.setMinutes(utcDate.getMinutes() + 45);

  return utcDate;
}

/**
 * Get current time in NPT
 */
export function getCurrentNPTTime(): Date {
  return toNPTDate(new Date());
}
