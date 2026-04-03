'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import styles from './dashboard.module.css';

interface AttendanceRecord {
  date: string;
  clockIn: string;
  clockOut: string;
  hoursWorked: number;
  clientName?: string;
}

export default function EmployeeDashboard() {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [employeeEmail, setEmployeeEmail] = useState('');
  const [isClockedIn, setIsClockedIn] = useState(false);
  const [clockInTime, setClockInTime] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [clientName, setClientName] = useState('');
  const [todayRecords, setTodayRecords] = useState<AttendanceRecord[]>([]);

  useEffect(() => {
    // Check if employee is logged in
    const token = localStorage.getItem('employeeToken');
    if (!token) {
      router.push('/employee/login');
      return;
    }
    try {
      const parsed = JSON.parse(token);
      setEmployeeEmail(parsed.email);
      setIsAuthenticated(true);

      // Load today's records from localStorage (simulated)
      const todayData = localStorage.getItem(`attendance_${parsed.email}`);
      if (todayData) {
        const data = JSON.parse(todayData);
        setTodayRecords(data.records || []);
        setIsClockedIn(data.isClockedIn || false);
        setClockInTime(data.clockInTime || null);
      }
    } catch {
      router.push('/employee/login');
    }
  }, [router]);

  const handleClockIn = async () => {
    if (!clientName.trim()) {
      alert('Please enter a client name');
      return;
    }

    setLoading(true);
    try {
      const now = new Date();
      const timeStr = now.toLocaleTimeString();

      setClockInTime(timeStr);
      setIsClockedIn(true);

      // Save to localStorage (simulated database)
      const data = {
        isClockedIn: true,
        clockInTime: timeStr,
        records: todayRecords
      };
      localStorage.setItem(`attendance_${employeeEmail}`, JSON.stringify(data));

      console.log('Clocked in at:', timeStr, 'for client:', clientName);
    } catch (err) {
      console.error('Clock in error:', err);
      alert('Failed to clock in');
    } finally {
      setLoading(false);
    }
  };

  const handleClockOut = async () => {
    if (!clockInTime) {
      alert('Please clock in first');
      return;
    }

    setLoading(true);
    try {
      const now = new Date();
      const clockOutStr = now.toLocaleTimeString();
      const clockInDate = new Date(`2024-01-01 ${clockInTime}`);
      const clockOutDate = new Date(`2024-01-01 ${clockOutStr}`);
      const hoursWorked = (clockOutDate.getTime() - clockInDate.getTime()) / (1000 * 60 * 60);

      const newRecord: AttendanceRecord = {
        date: new Date().toLocaleDateString(),
        clockIn: clockInTime,
        clockOut: clockOutStr,
        hoursWorked: Math.round(hoursWorked * 2) / 2, // Round to nearest 0.5
        clientName: clientName
      };

      const updatedRecords = [...todayRecords, newRecord];
      const data = {
        isClockedIn: false,
        clockInTime: null,
        records: updatedRecords
      };
      localStorage.setItem(`attendance_${employeeEmail}`, JSON.stringify(data));

      setTodayRecords(updatedRecords);
      setIsClockedIn(false);
      setClockInTime(null);
      setClientName('');

      alert(`Clocked out. Hours worked: ${newRecord.hoursWorked}`);
    } catch (err) {
      console.error('Clock out error:', err);
      alert('Failed to clock out');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('employeeToken');
    router.push('/employee/login');
  };

  if (!isAuthenticated) {
    return <div className={styles.loading}>Loading...</div>;
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>⏱️ Employee Dashboard</h1>
        <button onClick={handleLogout} className={styles.logoutBtn}>Logout</button>
      </div>

      <div className={styles.welcome}>
        <p>Welcome, {employeeEmail}</p>
      </div>

      <div className={styles.clockingSection}>
        <div className={styles.clockCard}>
          <h2>⏰ Clock In/Out</h2>

          {!isClockedIn ? (
            <div className={styles.form}>
              <div className={styles.formGroup}>
                <label>Client Name</label>
                <input
                  type="text"
                  value={clientName}
                  onChange={(e) => setClientName(e.target.value)}
                  placeholder="Enter client name"
                  className={styles.input}
                />
              </div>
              <button
                onClick={handleClockIn}
                disabled={loading || !clientName.trim()}
                className={`${styles.button} ${styles.clockInBtn}`}
              >
                {loading ? 'Processing...' : '✓ Clock In'}
              </button>
            </div>
          ) : (
            <div className={styles.clockedInStatus}>
              <p className={styles.statusText}>
                ✓ Clocked In at: <strong>{clockInTime}</strong>
              </p>
              <p className={styles.clientText}>
                Client: <strong>{clientName}</strong>
              </p>
              <button
                onClick={handleClockOut}
                disabled={loading}
                className={`${styles.button} ${styles.clockOutBtn}`}
              >
                {loading ? 'Processing...' : '✕ Clock Out'}
              </button>
            </div>
          )}
        </div>
      </div>

      {todayRecords.length > 0 && (
        <div className={styles.recordsSection}>
          <h2>📋 Today\'s Records</h2>
          <div className={styles.recordsList}>
            {todayRecords.map((record, idx) => (
              <div key={idx} className={styles.record}>
                <div className={styles.recordTime}>
                  <p>
                    <strong>In:</strong> {record.clockIn} | <strong>Out:</strong> {record.clockOut}
                  </p>
                  <p>
                    <strong>Hours:</strong> {record.hoursWorked}h
                  </p>
                </div>
                <div className={styles.recordClient}>
                  <p>
                    <strong>Client:</strong> {record.clientName}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className={styles.linksSection}>
        <a href="/employee/records" className={styles.link}>
          📅 View Monthly Records →
        </a>
        <a href="/employee/login" onClick={() => handleLogout()} className={styles.link}>
          🚪 Logout →
        </a>
      </div>
    </div>
  );
}
