'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import styles from './dashboard.module.css';

export default function AdminDashboard() {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [adminEmail, setAdminEmail] = useState('');

  useEffect(() => {
    // Check if admin is logged in
    const token = localStorage.getItem('adminToken');
    if (!token) {
      router.push('/kuberadmin/login');
      return;
    }
    try {
      const parsed = JSON.parse(token);
      setAdminEmail(parsed.email);
      setIsAuthenticated(true);
    } catch {
      router.push('/kuberadmin/login');
    }
  }, [router]);

  const handleLogout = () => {
    localStorage.removeItem('adminToken');
    router.push('/kuberadmin/login');
  };

  if (!isAuthenticated) {
    return <div className={styles.loading}>Loading...</div>;
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>👨‍💼 Admin Dashboard</h1>
        <button onClick={handleLogout} className={styles.logoutBtn}>Logout</button>
      </div>

      <div className={styles.welcome}>
        <p>Welcome, {adminEmail}</p>
      </div>

      <div className={styles.grid}>
        <div className={styles.card}>
          <h2>👥 Register Worker</h2>
          <p>Add a new employee to the system</p>
          <button onClick={() => router.push('/kuberadmin/register-worker')} className={styles.actionBtn}>
            Add Worker →
          </button>
        </div>

        <div className={styles.card}>
          <h2>📋 View All Workers</h2>
          <p>See all registered employees and their details</p>
          <button onClick={() => router.push('/kuberadmin/workers')} className={styles.actionBtn}>
            View Workers →
          </button>
        </div>

        <div className={styles.card}>
          <h2>🏆 Attendance Summary</h2>
          <p>View today's attendance and statistics</p>
          <button onClick={() => router.push('/kuberadmin/attendance')} className={styles.actionBtn}>
            View Attendance →
          </button>
        </div>

        <div className={styles.card}>
          <h2>📅 Manage Holidays</h2>
          <p>Add and edit company holidays</p>
          <button onClick={() => router.push('/kuberadmin/holidays')} className={styles.actionBtn}>
            Manage Holidays →
          </button>
        </div>
      </div>

      <div className={styles.stats}>
        <div className={styles.stat}>
          <h3>Quick Stats</h3>
          <ul>
            <li>✓ System Status: Operational</li>
            <li>✓ Database: Connected</li>
            <li>✓ API: Running</li>
          </ul>
        </div>
      </div>
    </div>
  );
}
