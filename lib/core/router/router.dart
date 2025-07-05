import 'package:go_router/go_router.dart';
import 'package:mobile_app_pocketpartners/core/router/guards/route_guard.dart';
import 'package:mobile_app_pocketpartners/features/auth/screens/login_screen.dart';
import 'package:mobile_app_pocketpartners/features/auth/screens/register_screen.dart';
import 'package:mobile_app_pocketpartners/features/home/screens/home_screen.dart';
import 'package:mobile_app_pocketpartners/shared/widgets/scaffold_base.dart';
import 'package:mobile_app_pocketpartners/features/groups/screens/group_list_screen.dart';
/*import 'package:mobile_app_pocketpartners/features/groups/screens/group_create_screen.dart';
import 'package:mobile_app_pocketpartners/features/groups/screens/group_detail_screen.dart';
import 'package:mobile_app_pocketpartners/features/groups/screens/group_config_screen.dart';
import 'package:mobile_app_pocketpartners/features/groups/screens/group_expenses_details_screen.dart';
*/
final router = GoRouter(
  initialLocation: "/login",
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          path: "/register",
          redirect: (context, state) => RouteGuard.publicGuard(),
          builder: (context, state) => RegisterScreen(),
        ),
        GoRoute(
          path: "/login",
          redirect: (context, state) => RouteGuard.publicGuard(),
          builder: (context, state) => LoginScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldBase(body: child),
      routes: [
        GoRoute(
          path: "/home",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/profile",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),

        // GRUPOS
        GoRoute(
          path: "/my-groups",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => GroupListScreen(),
        ),
        /*GoRoute(
          path: "/groups/create",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => GroupCreateScreen(),
        ),
        GoRoute(
          path: "/groups/:id",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return GroupDetailScreen(groupId: id);
          },
        ),
        GoRoute(
          path: "/groups/:id/config",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return GroupConfigScreen(groupId: id);
          },
        ),
        GoRoute(
          path: "/groups/:id/expenses-details",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return GroupExpensesDetailsScreen(groupId: id);
          },
        ),*/

        // Otros módulos (si los necesitas)
        GoRoute(
          path: "/expenses",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/incoming-payments",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/outgoing-payments",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
      ],
    ),
  ],
);
