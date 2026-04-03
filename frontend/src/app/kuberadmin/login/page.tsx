'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import styles from './login.module.css';

export default function AdminLogin() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      // Check against environment admin credentials (with defaults for testing)
      const adminEmail = process.env.NEXT_PUBLIC_ADMIN_EMAIL || 'admin@company.com';
      const adminPassword = process.env.NEXT_PUBLIC_ADMIN_PASSWORD || 'admin123';

      if (email === adminEmail && password === adminPassword) {
        // Store admin session (in real app, use secure sessions)
        localStorage.setItem('adminToken', JSON.stringify({ 
          email, 
          loginTime: new Date().toISOString() 
        }));
        router.push('/kuberadmin/dashboard');
      } else {
        setError('Invalid admin credentials');
      }
    } catch (err) {
      setError('Login failed. Please try again.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <h1>🔐 Admin Login</h1>
        <p>Kuber Timesheet Administration</p>

        <form onSubmit={handleLogin}>
          <div className={styles.formGroup}>
            <label htmlFor="email">Admin Email</label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@company.com"
              required
            />
          </div>

          <div className={styles.formGroup}>
            <label htmlFor="password">Admin Password</label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              required
            />
          </div>

          {error && <p className={styles.error}>{error}</p>}

          <button type="submit" disabled={loading} className={styles.button}>
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>

        <div className={styles.info}>
          <p>📝 Test Credentials:</p>
          <p><strong>Email:</strong> admin@company.com</p>
          <p><strong>Password:</strong> admin123</p>
          <p style={{marginTop: '10px', fontSize: '12px'}}>Change these in Vercel Environment Variables for production</p>
        </div>
      </div>
    </div>
  );
}
