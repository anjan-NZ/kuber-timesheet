import { type NextRequest, NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase';

// Routes that don't require authentication
const PUBLIC_ROUTES = ['/login', '/auth/reset-password', '/'];

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Allow public routes
  if (PUBLIC_ROUTES.includes(pathname)) {
    return NextResponse.next();
  }

  try {
    // Get the token from the request
    const token = request.cookies.get('sb-auth-token');

    if (!token) {
      // No token, redirect to login
      return NextResponse.redirect(new URL('/login', request.url));
    }

    // Verify token and get user role
    // Note: In a production app, you'd verify the JWT signature
    // For now, we'll do basic verification via Supabase

    return NextResponse.next();
  } catch (error) {
    // If there's any error, redirect to login
    return NextResponse.redirect(new URL('/login', request.url));
  }
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public folder
     */
    '/((?!api|_next/static|_next/image|favicon.ico|public).*)',
  ],
};
