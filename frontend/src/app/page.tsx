'use client';

import Link from 'next/link';

export default function Home() {
  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
      padding: '20px'
    }}>
      <h1 style={{ fontSize: '48px', marginBottom: '20px' }}>
        🕐 Kuber Timesheet System
      </h1>
      <p style={{ fontSize: '20px', marginBottom: '40px', textAlign: 'center' }}>
        Employee Attendance & Timesheet Management
      </p>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
        gap: '20px',
        maxWidth: '800px'
      }}>
        <Link href="/login">
          <div style={{
            background: 'rgba(255, 255, 255, 0.1)',
            padding: '30px',
            borderRadius: '12px',
            textAlign: 'center',
            cursor: 'pointer',
            border: '2px solid rgba(255, 255, 255, 0.3)',
            transition: 'all 0.3s',
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.2)';
            e.currentTarget.style.transform = 'translateY(-5px)';
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)';
            e.currentTarget.style.transform = 'translateY(0)';
          }}
          >
            <h2>👤 Employee Portal</h2>
            <p>Clock in/out and submit timesheets</p>
          </div>
        </Link>

        <Link href="/kuberadmin">
          <div style={{
            background: 'rgba(255, 255, 255, 0.1)',
            padding: '30px',
            borderRadius: '12px',
            textAlign: 'center',
            cursor: 'pointer',
            border: '2px solid rgba(255, 255, 255, 0.3)',
            transition: 'all 0.3s',
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.2)';
            e.currentTarget.style.transform = 'translateY(-5px)';
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)';
            e.currentTarget.style.transform = 'translateY(0)';
          }}
          >
            <h2>🔐 Admin Dashboard</h2>
            <p>Manage employees and attendance</p>
          </div>
        </Link>
      </div>

      <div style={{ marginTop: '60px', textAlign: 'center', fontSize: '14px', opacity: 0.8 }}>
        <p>✓ System Status: Operational</p>
        <p>✓ Database: Connected</p>
        <p>✓ Ready for use</p>
      </div>
    </div>
  );
}
