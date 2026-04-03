'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import styles from './records.module.css';

interface AttendanceRecord {
  date: string;
  clockIn: string;
  clockOut: string;
  hoursWorked: number;
  clientName?: string;
}

export default function EmployeeRecords() {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [employeeEmail, setEmployeeEmail] = useState('');
  const [records, setRecords] = useState<AttendanceRecord[]>([]);
  const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth());
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());

  useEffect(() => {
    const token = localStorage.getItem('employeeToken');
    if (!token) {
      router.push('/employee/login');
      return;
    }

    try {
      const parsed = JSON.parse(token);
      setEmployeeEmail(parsed.email);
      setIsAuthenticated(true);

      // Load all records from localStorage
      const attendanceData = localStorage.getItem(`attendance_${parsed.email}`);
      if (attendanceData) {
        const data = JSON.parse(attendanceData);
        setRecords(data.records || []);
      }
    } catch {
      router.push('/employee/login');
    }
  }, [router]);

  const handleLogout = () => {
    localStorage.removeItem('employeeToken');
    router.push('/employee/login');
  };

  const getMonthRecords = () => {
    return records.filter(record => {
      const recordDate = new Date(record.date);
      return (
        recordDate.getMonth() === selectedMonth &&
        recordDate.getFullYear() === selectedYear
      );
    });
  };

  const calculateStats = () => {
    const monthRecords = getMonthRecords();
    const totalHours = monthRecords.reduce((sum, r) => sum + r.hoursWorked, 0);
    const daysWorked = monthRecords.length;

    return { totalHours, daysWorked };
  };

  const monthRecords = getMonthRecords();
  const stats = calculateStats();

  if (!isAuthenticated) {
    return <div className={styles.loading}>Loading...</div>;
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>📅 Monthly Attendance Records</h1>
        <button onClick={handleLogout} className={styles.logoutBtn}>Logout</button>
      </div>

      <div className={styles.welcome}>
        <p>Email: {employeeEmail}</p>
      </div>

      <div className={styles.controlsSection}>
        <div className={styles.monthSelector}>
          <label>Month:</label>
          <select
            value={selectedMonth}
            onChange={(e) => setSelectedMonth(parseInt(e.target.value))}
            className={styles.select}
          >
            {Array.from({ length: 12 }).map((_, i) => (
              <option key={i} value={i}>
                {new Date(2024, i, 1).toLocaleString('default', { month: 'long' })}
              </option>
            ))}
          </select>
        </div>

        <div className={styles.yearSelector}>
          <label>Year:</label>
          <select
            value={selectedYear}
            onChange={(e) => setSelectedYear(parseInt(e.target.value))}
            className={styles.select}
          >
            {[2024, 2025, 2026].map(year => (
              <option key={year} value={year}>{year}</option>
            ))}
          </select>
        </div>
      </div>

      <div className={styles.statsSection}>
        <div className={styles.statCard}>
          <h3>Days Worked</h3>
          <p className={styles.statValue}>{stats.daysWorked}</p>
        </div>
        <div className={styles.statCard}>
          <h3>Total Hours</h3>
          <p className={styles.statValue}>{stats.totalHours.toFixed(1)}h</p>
        </div>
        <div className={styles.statCard}>
          <h3>Average Hours</h3>
          <p className={styles.statValue}>
            {stats.daysWorked > 0 ? (stats.totalHours / stats.daysWorked).toFixed(1) : 0}h
          </p>
        </div>
      </div>

      {monthRecords.length > 0 ? (
        <div className={styles.recordsSection}>
          <h2>Records for {new Date(selectedYear, selectedMonth, 1).toLocaleString('default', { month: 'long', year: 'numeric' })}</h2>
          <div className={styles.tableContainer}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Clock In</th>
                  <th>Clock Out</th>
                  <th>Hours</th>
                  <th>Client</th>
                </tr>
              </thead>
              <tbody>
                {monthRecords.map((record, idx) => (
                  <tr key={idx}>
                    <td>{record.date}</td>
                    <td>{record.clockIn}</td>
                    <td>{record.clockOut}</td>
                    <td>{record.hoursWorked}h</td>
                    <td>{record.clientName || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      ) : (
        <div className={styles.emptyState}>
          <p>📭 No records found for this month</p>
        </div>
      )}

      <div className={styles.linksSection}>
        <button
          onClick={() => router.push('/employee/dashboard')}
          className={styles.button}
        >
          ⏱️ Back to Dashboard
        </button>
      </div>
    </div>
  );
}
