import { NextRequest, NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase';

/**
 * GET /api/holidays
 * Get all holidays (public endpoint for viewing)
 */
export async function GET(request: NextRequest) {
  try {
    const supabase = createServerSupabaseClient();

    const { data, error } = await supabase
      .from('holidays')
      .select('*')
      .order('holiday_date', { ascending: true });

    if (error) {
      console.error('Holidays fetch error:', error);
      return NextResponse.json(
        { error: 'Failed to fetch holidays' },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      data: data || [],
    });
  } catch (error) {
    console.error('Holidays error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

/**
 * POST /api/holidays
 * Create a new holiday (admin only)
 */
export async function POST(request: NextRequest) {
  try {
    const supabase = createServerSupabaseClient();
    
    // Check if user is admin
    const { data: { user: authUser }, error: authError } = await supabase.auth.getUser();

    if (authError || !authUser) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Get user profile to check role
    const { data: userProfile, error: profileError } = await supabase
      .from('users')
      .select('role')
      .eq('id', authUser.id)
      .single();

    if (profileError || !userProfile || userProfile.role !== 'admin') {
      return NextResponse.json(
        { error: 'Only administrators can create holidays' },
        { status: 403 }
      );
    }

    const body = await request.json();
    const { holiday_date, description } = body;

    if (!holiday_date || !description) {
      return NextResponse.json(
        { error: 'holiday_date and description are required' },
        { status: 400 }
      );
    }

    // Insert holiday
    const { data, error } = await supabase
      .from('holidays')
      .insert({
        holiday_date,
        description,
      })
      .select()
      .single();

    if (error) {
      console.error('Holiday creation error:', error);
      return NextResponse.json(
        { error: 'Failed to create holiday' },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      message: 'Holiday created successfully',
      data: data,
    });
  } catch (error) {
    console.error('Holiday error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

/**
 * DELETE /api/holidays/[id]
 * Delete a holiday (admin only) - handled in [id]/route.ts
 */
