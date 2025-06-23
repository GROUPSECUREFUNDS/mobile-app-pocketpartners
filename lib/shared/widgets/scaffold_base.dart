import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:mobile_app_pocketpartners/shared/models/route_model.dart";

class ScaffoldBase extends StatelessWidget {
  Widget body;

  ScaffoldBase({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final routeModels = <RouteModel>[
      RouteModel(path: "/home", name: "Home", icon: Icons.home),
      RouteModel(path: "/profile", name: "Profile", icon: Icons.person),
      // Add more routes as needed
    ];

    final currentPath = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(title: const Text("Pocket Partners"), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text("Pocket Partners")),
            ...routeModels.map(
              (route) => ListTile(
                leading: Icon(route.icon),
                title: Text(route.name),
                selected: currentPath == route.path,
                onTap: () {
                  context.pop(context); // Close the drawer
                  // Navigate to the selected route
                  context.pushReplacement(route.path);
                },
              ),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                context.pop(context); 
                context.go("/auth/login"); // Navigate to login
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
