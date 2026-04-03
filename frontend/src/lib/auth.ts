import { supabaseClient } from './supabase';
import { AuthUser, User, UserRole } from '@/types';

/**
 * Sign in user with email and password
 */
export async function signIn(email: string, password: string) {
  try {
    const { data, error } = await supabaseClient.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data;
  } catch (error) {
    console.error('Sign in error:', error);
    throw error;
  }
}

/**
 * Sign out current user
 */
export async function signOut() {
  try {
    const { error } = await supabaseClient.auth.signOut();

    if (error) {
      throw new Error(error.message);
    }
  } catch (error) {
    console.error('Sign out error:', error);
    throw error;
  }
}

/**
 * Get current authenticated user
 */
export async function getCurrentUser(): Promise<AuthUser | null> {
  try {
    const {
      data: { user },
    } = await supabaseClient.auth.getUser();

    return user || null;
  } catch (error) {
    console.error('Get current user error:', error);
    return null;
  }
}

/**
 * Get user session
 */
export async function getSession() {
  try {
    const {
      data: { session },
    } = await supabaseClient.auth.getSession();

    return session;
  } catch (error) {
    console.error('Get session error:', error);
    return null;
  }
}

/**
 * Update user password
 */
export async function updatePassword(newPassword: string) {
  try {
    const { error } = await supabaseClient.auth.updateUser({
      password: newPassword,
    });

    if (error) {
      throw new Error(error.message);
    }
  } catch (error) {
    console.error('Update password error:', error);
    throw error;
  }
}

/**
 * Send password reset email
 */
export async function sendPasswordResetEmail(email: string) {
  try {
    const { error } = await supabaseClient.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/reset-password`,
    });

    if (error) {
      throw new Error(error.message);
    }
  } catch (error) {
    console.error('Password reset email error:', error);
    throw error;
  }
}

/**
 * Get user profile from users table
 */
export async function getUserProfile(userId: string): Promise<User | null> {
  try {
    const { data, error } = await supabaseClient
      .from('users')
      .select('*')
      .eq('id', userId)
      .single();

    if (error) {
      throw new Error(error.message);
    }

    return data;
  } catch (error) {
    console.error('Get user profile error:', error);
    return null;
  }
}

/**
 * Check if user role is admin
 */
export async function isUserAdmin(): Promise<boolean> {
  try {
    const user = await getCurrentUser();
    if (!user) return false;

    const profile = await getUserProfile(user.id);
    return profile?.role === 'admin';
  } catch (error) {
    console.error('Check admin role error:', error);
    return false;
  }
}

/**
 * Check if user role is employee
 */
export async function isUserEmployee(): Promise<boolean> {
  try {
    const user = await getCurrentUser();
    if (!user) return false;

    const profile = await getUserProfile(user.id);
    return profile?.role === 'employee';
  } catch (error) {
    console.error('Check employee role error:', error);
    return false;
  }
}

/**
 * Watch for auth state changes
 */
export function onAuthStateChange(
  callback: (event: string, session: any) => void
) {
  const {
    data: { subscription },
  } = supabaseClient.auth.onAuthStateChange(callback);

  return subscription;
}
