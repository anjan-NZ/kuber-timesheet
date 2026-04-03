export const metadata = {
  title: 'Employee - Kuber Timesheet',
  description: 'Employee timesheet and attendance system',
};

export default function EmployeeLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <section>
      {children}
    </section>
  );
}
