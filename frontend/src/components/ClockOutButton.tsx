'use client';

import { useState } from 'react';

interface ClockOutButtonProps {
  attendanceId: string;
  currentDate: string;
  onSuccess?: () => void;
  onError?: (error: string) => void;
  disabled?: boolean;
}

export function ClockOutButton({ 
  attendanceId,
  currentDate,
  onSuccess, 
  onError,
  disabled = false 
}: ClockOutButtonProps) {
  const [loading, setLoading] = useState(false);
  const [clientName, setClientName] = useState('');

  const handleClockOut = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/attendance', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          attendance_id: attendanceId,
          client_name: clientName || null,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to clock out');
      }

      setClientName('');
      onSuccess?.();
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Error clocking out';
      onError?.(message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-3">
      <input
        type="text"
        placeholder="Client Name (optional)"
        value={clientName}
        onChange={(e) => setClientName(e.target.value)}
        className="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-red-500"
        disabled={loading || disabled}
      />
      <button
        onClick={handleClockOut}
        disabled={loading || disabled}
        className="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {loading ? 'Clocking Out...' : 'Clock Out'}
      </button>
    </div>
  );
}
