'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import styles from './login.module.css';

export default function EmployeeLogin() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  useEffect(() => {
    // Check if already logged in
    const token = localStorage.getItem('employeeToken');
    if (token) {
      router.push('/employee/dashboard');
    }
  }, [router]);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      // For now, accept any email with password "employee123"
      // In production, this would call an API to validate against the database
      const testPassword = process.env.NEXT_PUBLIC_EMPLOYEE_PASSWORD || 'employee123';

      if (!email || !email.includes('@')) {
        setError('Please enter a valid email address');
        setLoading(false);
        return;
      }

      if (password === testPassword) {
        // Store employee session
        localStorage.setItem('employeeToken', JSON.stringify({
          email,
          loginTime: new Date().toISOString()
        }));
        console.log('Employee login successful');
        router.push('/employee/dashboard');
      } else {
        setError('Invalid credentials. Use password: employee123');
      }
    } catch (err) {
      setError('Login failed. Please try again.');
      console.error('Login error:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        <h1>⏱️ Employee Login</h1>
        <p>Kuber Timesheet System</p>

        <form onSubmit={handleLogin}>
          <div className={styles.formGroup}>
            <label htmlFor="email">Email</label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="your.email@company.com"
              required
            />
          </div>

          <div className={styles.formGroup}>
            <label htmlFor="password">Password</label>
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
          <p><strong>Email:</strong> employee@company.com (or any email)</p>
          <p><strong>Password:</strong> employee123</p>
        </div>

        <div className={styles.adminLink}>
          <p>Are you an admin? <a href="/kuberadmin">Go to Admin Panel</a></p>
        </div>
      </div>
    </div>
  );
}
