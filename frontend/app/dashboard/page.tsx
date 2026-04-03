'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getCurrentUser, getUserProfile, signOut, isUserAdmin } from '@/lib/auth';
import { User } from '@/types';

export default function DashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadUser = async () => {
      try {
        const authUser = await getCurrentUser();
        
        if (!authUser) {
          router.push('/login');
          return;
        }

        const profile = await getUserProfile(authUser.id);
        setUser(profile);

        const adminCheck = await isUserAdmin();
        setIsAdmin(adminCheck);
      } catch (error) {
        console.error('Error loading user:', error);
        router.push('/login');
      } finally {
        setLoading(false);
      }
    };

    loadUser();
  }, [router]);

  const handleSignOut = async () => {
    try {
      await signOut();
      router.push('/login');
    } catch (error) {
      console.error('Sign out error:', error);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <p className="text-gray-600">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <p className="text-gray-600">Redirecting to login...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Navigation Bar */}
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-xl font-bold text-gray-900">
                Kuber Timesheet
              </h1>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-700">
                {user.name} ({user.role === 'admin' ? 'Administrator' : 'Employee'})
              </span>
              <button
                onClick={handleSignOut}
                className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="border-4 border-dashed border-gray-200 rounded-lg h-96 p-4">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Welcome, {user.name}!
            </h2>
            
            {isAdmin ? (
              <div>
                <p className="text-gray-700 mb-4">
                  You are logged in as an Administrator.
                </p>
                <div className="space-y-2">
                  <p className="text-sm text-gray-600">Admin features coming soon:</p>
                  <ul className="list-disc list-inside text-sm text-gray-600">
                    <li>Employee management</li>
                    <li>Holiday management</li>
                    <li>Attendance records viewing</li>
                    <li>Data export</li>
                  </ul>
                </div>
              </div>
            ) : (
              <div>
                <p className="text-gray-700 mb-4">
                  Time tracking and attendance features coming soon.
                </p>
                <div className="space-y-2">
                  <p className="text-sm text-gray-600">Employee features:</p>
                  <ul className="list-disc list-inside text-sm text-gray-600">
                    <li>Clock In / Clock Out</li>
                    <li>View monthly records</li>
                    <li>Download attendance report</li>
                  </ul>
                </div>
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
