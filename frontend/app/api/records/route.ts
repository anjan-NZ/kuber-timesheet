import { NextRequest, NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase';

/**
 * GET /api/records
 * Get attendance records for the current user (filtered by month/date)
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const nepaliYear = searchParams.get('nepali_year');
    const nepaliMonth = searchParams.get('nepali_month');
    const page = parseInt(searchParams.get('page') || '1', 10);
    const limit = parseInt(searchParams.get('limit') || '50', 10);

    // Get current user
    const supabase = createServerSupabaseClient();
    const { data: { user: authUser }, error: authError } = await supabase.auth.getUser();

    if (authError || !authUser) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    let query = supabase
      .from('attendance_records')
      .select('*', { count: 'exact' })
      .eq('user_id', authUser.id)
      .order('entry_date', { ascending: false });

    // Filter by Nepali year and month if provided
    if (nepaliYear && nepaliMonth) {
      // Since dates are stored as YYYY-MM-DD (Nepali format),
      // we can filter by pattern matching
      const pattern = `${nepaliYear}-${String(nepaliMonth).padStart(2, '0')}-`;
      query = query.like('entry_date', `${pattern}%`);
    }

    // Pagination
    const offset = (page - 1) * limit;
    query = query.range(offset, offset + limit - 1);

    const { data, error, count } = await query;

    if (error) {
      console.error('Records fetch error:', error);
      return NextResponse.json(
        { error: 'Failed to fetch records' },
        { status: 500 }
      );
    }

    const totalPages = count ? Math.ceil(count / limit) : 0;

    return NextResponse.json({
      success: true,
      data: data || [],
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: totalPages,
      },
    });
  } catch (error) {
    console.error('Records error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
