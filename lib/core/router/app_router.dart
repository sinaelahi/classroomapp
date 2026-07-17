import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/students/presentation/pages/student_list_page.dart';
import '../../features/payments/presentation/pages/payments_overview_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
      GoRoute(
        path: '/students',
        builder: (context, state) => const StudentListPage(),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsOverviewPage(),
      ),
    ],
  );
}
