import { redirect } from 'next/redirect';

export default function AdminRoot() {
  // Redirect to login page directly
  redirect('/kuberadmin/login');
}
