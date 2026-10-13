import 'package:go_router/go_router.dart';
import 'package:jadwal_kuliah_pintar/presentation/pages/login/register_page.dart';
import 'package:jadwal_kuliah_pintar/presentation/pages/profile/academic_setup_page.dart'; // <-- 1. Import file AcademicSetupPage
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/login/login_page.dart';
import '../../presentation/pages/home/dashboard_page.dart';
import '../../presentation/pages/schedule/schedule_page.dart';
import '../../presentation/pages/tasks/tasks_page.dart';
import '../../presentation/pages/calendar/calendar_page.dart';
import '../../presentation/pages/notes/notes_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/academic-setup', // <-- 2. Tambahkan rute setup akademik di sini
        builder: (context, state) => const AcademicSetupPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const SchedulePage(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesPage(),
      ),
    ],
  );
}
