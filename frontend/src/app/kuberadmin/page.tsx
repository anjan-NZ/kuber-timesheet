import { redirect } from 'next/navigation';

export default function AdminRoot() {
  // Redirect to login page directly
  redirect('/kuberadmin/login');
}
