'use client';

import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

export default function AdminRoot() {
  const router = useRouter();

  useEffect(() => {
    // Check if admin is logged in
    const token = localStorage.getItem('adminToken');
    
    if (token) {
      // Already logged in, go to dashboard
      router.push('/kuberadmin/dashboard');
    } else {
      // Not logged in, go to login
      router.push('/kuberadmin/login');
    }
  }, [router]);

  return (
    <div style={{ 
      display: 'flex', 
      justifyContent: 'center', 
      alignItems: 'center', 
      minHeight: '100vh',
      fontSize: '18px',
      color: '#667eea'
    }}>
      Loading...
    </div>
  );
}
