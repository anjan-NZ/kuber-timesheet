'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { createClient } from '@supabase/supabase-js';
import styles from './workers.module.css';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL || '',
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''
);

interface Worker {
  id: string;
  email: string;
  name: string;
  role: string;
  is_active: boolean;
  created_at: string;
}

export default function WorkersList() {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [workers, setWorkers] = useState<Worker[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const token = localStorage.getItem('adminToken');
    if (!token) {
      router.push('/kuberadmin/login');
      return;
    }
    setIsAuthenticated(true);
    fetchWorkers();
  }, [router]);

  const fetchWorkers = async () => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) {
        setError('Failed to fetch workers: ' + error.message);
        return;
      }

      setWorkers(data || []);
    } catch (err) {
      setError('Error loading workers');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDeactivate = async (userId: string) => {
    if (!confirm('Deactivate this worker?')) return;

    try {
      const { error } = await supabase
        .from('users')
        .update({ is_active: false })
        .eq('id', userId);

      if (error) {
        setError('Failed to deactivate: ' + error.message);
        return;
      }

      setWorkers(workers.map(w => 
        w.id === userId ? { ...w, is_active: false } : w
      ));
    } catch (err) {
      setError('Error deactivating worker');
      console.error(err);
    }
  };

  const handleActivate = async (userId: string) => {
    try {
      const { error } = await supabase
        .from('users')
        .update({ is_active: true })
        .eq('id', userId);

      if (error) {
        setError('Failed to activate: ' + error.message);
        return;
      }

      setWorkers(workers.map(w => 
        w.id === userId ? { ...w, is_active: true } : w
      ));
    } catch (err) {
      setError('Error activating worker');
      console.error(err);
    }
  };

  if (!isAuthenticated) {
    return <div className={styles.loading}>Loading...</div>;
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <button onClick={() => router.back()} className={styles.backBtn}>← Back</button>
        <h1>👥 All Workers</h1>
        <button onClick={() => router.push('/kuberadmin/register-worker')} className={styles.addBtn}>
          + Add Worker
        </button>
      </div>

      {error && <p className={styles.error}>{error}</p>}

      {loading ? (
        <p className={styles.loading}>Loading workers...</p>
      ) : (
        <div className={styles.tableContainer}>
          {workers.length === 0 ? (
            <p className={styles.noData}>No workers registered yet</p>
          ) : (
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Role</th>
                  <th>Status</th>
                  <th>Joined</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {workers.map((worker) => (
                  <tr key={worker.id} className={!worker.is_active ? styles.inactive : ''}>
                    <td>{worker.name}</td>
                    <td>{worker.email}</td>
                    <td>
                      <span className={styles.role}>
                        {worker.role === 'admin' ? '🔐 Admin' : '👤 Employee'}
                      </span>
                    </td>
                    <td>
                      <span className={worker.is_active ? styles.active : styles.inactive}>
                        {worker.is_active ? '✓ Active' : '✗ Inactive'}
                      </span>
                    </td>
                    <td>{new Date(worker.created_at).toLocaleDateString()}</td>
                    <td className={styles.actions}>
                      {worker.is_active ? (
                        <button
                          onClick={() => handleDeactivate(worker.id)}
                          className={styles.deactivateBtn}
                          title="Deactivate user"
                        >
                          Deactivate
                        </button>
                      ) : (
                        <button
                          onClick={() => handleActivate(worker.id)}
                          className={styles.activateBtn}
                          title="Activate user"
                        >
                          Activate
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      )}

      <div className={styles.stats}>
        <p>Total Workers: <strong>{workers.length}</strong></p>
        <p>Active: <strong>{workers.filter(w => w.is_active).length}</strong></p>
        <p>Admins: <strong>{workers.filter(w => w.role === 'admin').length}</strong></p>
      </div>
    </div>
  );
}
