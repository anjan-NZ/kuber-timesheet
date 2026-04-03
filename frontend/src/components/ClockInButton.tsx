'use client';

import { useState } from 'react';

interface ClockInButtonProps {
  entryId?: string;
  currentDate: string;
  onSuccess?: () => void;
  onError?: (error: string) => void;
}

export function ClockInButton({ 
  currentDate, 
  onSuccess, 
  onError 
}: ClockInButtonProps) {
  const [loading, setLoading] = useState(false);
  const [clientName, setClientName] = useState('');

  const handleClockIn = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/attendance', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          entry_date: currentDate,
          client_name: clientName || null,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to clock in');
      }

      setClientName('');
      onSuccess?.();
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Error clocking in';
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
        className="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-green-500"
        disabled={loading}
      />
      <button
        onClick={handleClockIn}
        disabled={loading}
        className="w-full bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {loading ? 'Clocking In...' : 'Clock In'}
      </button>
    </div>
  );
}
