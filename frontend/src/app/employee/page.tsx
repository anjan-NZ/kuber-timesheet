import { redirect } from 'next/redirect';

export default function EmployeeRoot() {
  // Redirect to employee login
  redirect('/employee/login');
}
