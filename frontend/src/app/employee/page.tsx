import { redirect } from 'next/navigation';

export default function EmployeeRoot() {
  // Redirect to employee login
  redirect('/employee/login');
}
