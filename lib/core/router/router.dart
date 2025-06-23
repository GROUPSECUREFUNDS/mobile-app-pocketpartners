import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:mobile_app_pocketpartners/features/auth/screens/login_screen.dart";
import "package:mobile_app_pocketpartners/features/auth/screens/register_screen.dart";
import "package:mobile_app_pocketpartners/features/home/screens/home_screen.dart";
import "package:mobile_app_pocketpartners/shared/widgets/scaffold_base.dart";


GoRouter router = GoRouter(
  initialLocation: "/auth/login",
  routes: [
    GoRoute(
      path: "/auth",
      builder: (context, state) => Scaffold(
        body: Center(
          child: Text("Welcome to Pocket Partners!"),
        ),
      ),
      routes: [
        GoRoute(
          path: "register",
          builder: (context, state) => RegisterScreen()
        ),
        GoRoute(
          path: "login",
          builder: (context, state) => LoginScreen()
        ),
      ],
    ),
    ShellRoute(
      builder: (context,state,child)=> ScaffoldBase(body: child),
      routes: [
        GoRoute(
          path: "/home",
          builder: (context, state) => HomeScreen()
        ),
      ]

    ),
  ],
);
