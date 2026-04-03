import {
  NepaliDate,
  EnglishDate,
  DateConversionResponse,
  CurrentDateResponse,
} from '@/types';

const API_BASE_URL = process.env.NEXT_PUBLIC_NEPALI_API_URL || 'http://localhost:8000';

// Cache for date conversions
const conversionCache = new Map<string, DateConversionResponse>();

/**
 * Generate cache key for date conversions
 */
function getCacheKey(type: 'e2n' | 'n2e', date: any): string {
  if (type === 'e2n') {
    return `e2n_${date.year}_${date.month}_${date.day}`;
  } else {
    return `n2e_${date.year}_${date.month}_${date.day}`;
  }
}

/**
 * Convert English (Gregorian) date to Nepali (Bikram Sambat)
 */
export async function englishToNepali(
  englishDate: EnglishDate
): Promise<NepaliDate> {
  const cacheKey = getCacheKey('e2n', englishDate);

  if (conversionCache.has(cacheKey)) {
    const cached = conversionCache.get(cacheKey)!;
    return cached.nepali_date;
  }

  try {
    const response = await fetch(
      `${API_BASE_URL}/convert/english-to-nepali`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          year: englishDate.year,
          month: englishDate.month,
          day: englishDate.day,
        }),
      }
    );

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`);
    }

    const data: DateConversionResponse = await response.json();
    conversionCache.set(cacheKey, data);

    return data.nepali_date;
  } catch (error) {
    console.error('Error converting English to Nepali:', error);
    throw error;
  }
}

/**
 * Convert Nepali (Bikram Sambat) date to English (Gregorian)
 */
export async function nepaliToEnglish(
  nepaliDate: NepaliDate
): Promise<EnglishDate> {
  const cacheKey = getCacheKey('n2e', nepaliDate);

  if (conversionCache.has(cacheKey)) {
    const cached = conversionCache.get(cacheKey)!;
    return cached.english_date;
  }

  try {
    const response = await fetch(
      `${API_BASE_URL}/convert/nepali-to-english`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          year: nepaliDate.year,
          month: nepaliDate.month,
          day: nepaliDate.day,
        }),
      }
    );

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`);
    }

    const data: DateConversionResponse = await response.json();
    conversionCache.set(cacheKey, data);

    return data.english_date;
  } catch (error) {
    console.error('Error converting Nepali to English:', error);
    throw error;
  }
}

/**
 * Get current date in both English and Nepali calendars (NPT timezone)
 */
export async function getCurrentDate(): Promise<CurrentDateResponse> {
  try {
    const response = await fetch(`${API_BASE_URL}/date/current`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`);
    }

    const data: CurrentDateResponse = await response.json();
    return data;
  } catch (error) {
    console.error('Error getting current date:', error);
    throw error;
  }
}

/**
 * Validate if a Nepali date is valid
 */
export async function validateNepaliDate(nepaliDate: NepaliDate): Promise<{
  valid: boolean;
  message: string;
  english_equivalent?: string;
}> {
  try {
    const response = await fetch(`${API_BASE_URL}/validate/nepali-date`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        year: nepaliDate.year,
        month: nepaliDate.month,
        day: nepaliDate.day,
      }),
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.statusText}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error validating Nepali date:', error);
    throw error;
  }
}

/**
 * Get Nepali date from English date string (YYYY-MM-DD)
 */
export async function getNepaliDateFromString(
  englishDateString: string
): Promise<NepaliDate> {
  const [year, month, day] = englishDateString.split('-').map(Number);
  return englishToNepali({ year, month, day, formatted: englishDateString });
}

/**
 * Get English date from Nepali date string (YYYY-MM-DD)
 */
export async function getEnglishDateFromString(
  nepaliDateString: string
): Promise<EnglishDate> {
  const [year, month, day] = nepaliDateString.split('-').map(Number);
  return nepaliToEnglish({ year, month, day, formatted: nepaliDateString });
}

/**
 * Format a Nepali date for display (Nepali calendar format)
 */
export function formatNepaliDate(nepaliDate: NepaliDate): string {
  return `${nepaliDate.year}-${String(nepaliDate.month).padStart(2, '0')}-${String(nepaliDate.day).padStart(2, '0')}`;
}

/**
 * Clear the date conversion cache (for testing or manual refresh)
 */
export function clearDateConversionCache(): void {
  conversionCache.clear();
}
