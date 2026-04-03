import { NextRequest, NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase';
import { roundTimeToNearestFiveMinutes, calculateHoursWorked, validateTimeEntry } from '@/lib/time-utils';
import { getCurrentUser } from '@/lib/auth';

/**
 * POST /api/attendance/clock-in
 * Record a clock-in entry for the current user
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { entry_date, client_name } = body;

    if (!entry_date) {
      return NextResponse.json(
        { error: 'entry_date is required (Nepali date: YYYY-MM-DD)' },
        { status: 400 }
      );
    }

    // Get current user
    const supabase = createServerSupabaseClient();
    const { data: { user: authUser }, error: authError } = await supabase.auth.getUser();

    if (authError || !authUser) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Round current time to nearest 5 minutes
    const timeIn = roundTimeToNearestFiveMinutes(new Date());

    // Check if user already has a clock-in for this date
    const { data: existingEntry, error: checkError } = await supabase
      .from('attendance_records')
      .select('*')
      .eq('user_id', authUser.id)
      .eq('entry_date', entry_date)
      .single();

    if (existingEntry && !existingEntry.time_in) {
      // Update existing entry with time_in
      const { data, error } = await supabase
        .from('attendance_records')
        .update({
          time_in: timeIn.toISOString(),
          client_name: client_name || null,
          edited_at: new Date().toISOString(),
        })
        .eq('id', existingEntry.id)
        .select()
        .single();

      if (error) {
        console.error('Clock-in update error:', error);
        return NextResponse.json(
          { error: 'Failed to record clock-in' },
          { status: 500 }
        );
      }

      // Log audit event
      await supabase.from('audit_logs').insert({
        user_id: authUser.id,
        action: 'clock_in',
        table_name: 'attendance_records',
        record_id: existingEntry.id,
        new_values: { time_in: timeIn.toISOString(), client_name },
      });

      return NextResponse.json({
        success: true,
        message: 'Clocked in successfully',
        data: data,
      });
    } else if (!existingEntry) {
      // Create new attendance record
      const { data, error } = await supabase
        .from('attendance_records')
        .insert({
          user_id: authUser.id,
          entry_date,
          time_in: timeIn.toISOString(),
          client_name: client_name || null,
          is_locked: false,
          created_by_admin: false,
        })
        .select()
        .single();

      if (error) {
        console.error('Clock-in insert error:', error);
        return NextResponse.json(
          { error: 'Failed to record clock-in' },
          { status: 500 }
        );
      }

      // Log audit event
      await supabase.from('audit_logs').insert({
        user_id: authUser.id,
        action: 'clock_in',
        table_name: 'attendance_records',
        record_id: data.id,
        new_values: { time_in: timeIn.toISOString(), client_name },
      });

      return NextResponse.json({
        success: true,
        message: 'Clocked in successfully',
        data: data,
      });
    } else {
      return NextResponse.json(
        { error: 'Already clocked in for this date' },
        { status: 400 }
      );
    }
  } catch (error) {
    console.error('Clock-in error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

/**
 * PUT /api/attendance/clock-out
 * Record a clock-out entry for the current user
 */
export async function PUT(request: NextRequest) {
  try {
    const body = await request.json();
    const { attendance_id, client_name } = body;

    if (!attendance_id) {
      return NextResponse.json(
        { error: 'attendance_id is required' },
        { status: 400 }
      );
    }

    // Get current user
    const supabase = createServerSupabaseClient();
    const { data: { user: authUser }, error: authError } = await supabase.auth.getUser();

    if (authError || !authUser) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Get the attendance record
    const { data: record, error: fetchError } = await supabase
      .from('attendance_records')
      .select('*')
      .eq('id', attendance_id)
      .single();

    if (fetchError || !record) {
      return NextResponse.json(
        { error: 'Attendance record not found' },
        { status: 404 }
      );
    }

    // Verify it belongs to the user
    if (record.user_id !== authUser.id) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 403 }
      );
    }

    // Check if already clocked out
    if (record.time_out) {
      return NextResponse.json(
        { error: 'Already clocked out for this entry' },
        { status: 400 }
      );
    }

    // Round current time to nearest 5 minutes
    const timeOut = roundTimeToNearestFiveMinutes(new Date());

    // Validate times
    if (record.time_in) {
      const validation = validateTimeEntry(new Date(record.time_in), timeOut);
      if (!validation.valid) {
        return NextResponse.json(
          { error: validation.error },
          { status: 400 }
        );
      }
    }

    // Calculate hours worked
    const hoursWorked = record.time_in ? calculateHoursWorked(new Date(record.time_in), timeOut) : null;

    // Update record with clock-out
    const { data, error } = await supabase
      .from('attendance_records')
      .update({
        time_out: timeOut.toISOString(),
        hours_worked: hoursWorked,
        client_name: client_name || record.client_name,
        edited_at: new Date().toISOString(),
        is_locked: true, // Lock entry after clock-out
      })
      .eq('id', attendance_id)
      .select()
      .single();

    if (error) {
      console.error('Clock-out update error:', error);
      return NextResponse.json(
        { error: 'Failed to record clock-out' },
        { status: 500 }
      );
    }

    // Log audit event
    await supabase.from('audit_logs').insert({
      user_id: authUser.id,
      action: 'clock_out',
      table_name: 'attendance_records',
      record_id: attendance_id,
      new_values: { 
        time_out: timeOut.toISOString(),
        hours_worked: hoursWorked,
        client_name,
      },
    });

    return NextResponse.json({
      success: true,
      message: 'Clocked out successfully',
      data: data,
    });
  } catch (error) {
    console.error('Clock-out error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
