import "package:go_router/go_router.dart";
import "package:mobile_app_pocketpartners/core/router/guards/route_guard.dart";
import "package:mobile_app_pocketpartners/features/auth/screens/login_screen.dart";
import "package:mobile_app_pocketpartners/features/auth/screens/register_screen.dart";
import "package:mobile_app_pocketpartners/features/home/screens/home_screen.dart";
import "package:mobile_app_pocketpartners/features/payments/screens/incoming_payments_screen.dart";
import "package:mobile_app_pocketpartners/features/payments/screens/outgoing_payments_screen.dart";
import "package:mobile_app_pocketpartners/shared/widgets/scaffold_base.dart";

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          path: "/register",
          redirect: (context,state)=>RouteGuard.publicGuard(),
          builder: (context, state) => RegisterScreen(),
        ),
        GoRoute(
          path: "/login",
          redirect: (context, state) => RouteGuard.publicGuard(),
          builder: (context, state) => LoginScreen()),
      ],
    ),



    
    ShellRoute(
      builder: (context, state, child) => ScaffoldBase(body: child),
      routes: [
        GoRoute(
          path: "/home", 
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen()
        ),
        GoRoute(
          path: "/profile", 
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen()
        ),
        GoRoute(
          path: "/groups",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/my-groups",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/expenses",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: "/incoming-payments",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => IncomingPaymentsScreen(),
        ),
        GoRoute(
          path: "/outgoing-payments",
          redirect: (context, state) => RouteGuard.privateGuard(),
          builder: (context, state) => OutgoingPaymentsScreen(),
        ),
      ],
    ),
  ],
);
