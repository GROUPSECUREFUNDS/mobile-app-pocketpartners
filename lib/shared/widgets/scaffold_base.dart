import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:mobile_app_pocketpartners/core/controllers/auth_controller.dart";
import "package:mobile_app_pocketpartners/core/controllers/theme_controller.dart";
import "package:mobile_app_pocketpartners/data/models/user_info/userinfo_response_model.dart";
import "package:mobile_app_pocketpartners/data/services/userinformation_service.dart";
import "package:mobile_app_pocketpartners/shared/models/route_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ScaffoldBase extends ConsumerStatefulWidget {
  Widget body;

  ScaffoldBase({super.key, required this.body});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ScaffoldBase> {
  final authController = AuthController();
  final userInformationService = UserinformationService();

  UserinfoResponseModel? userInfo;

  @override
  void initState() {
    super.initState();
    debugPrint("ScaffoldBase initState called");
    authController.getUserFromPreferences().then((user) {
      userInformationService
          .getByUserId(user!.id)
          .then((userInfoResponse) {
            setState(() {
              userInfo = userInfoResponse;
            });
          })
          .catchError((error) {
            // Handle error if needed
            print("Error fetching user info: $error");
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    final routeModels = <RouteModel>[
      RouteModel(path: "/home", name: "Home", icon: Icons.home),
      RouteModel(path: "/profile", name: "Profile", icon: Icons.person),
      RouteModel(path: "/groups", name: "Groups", icon: Icons.group),
      RouteModel(path: "/my-groups", name: "My Groups", icon: Icons.group_work),
      RouteModel(path: "/expenses", name: "Expenses", icon: Icons.attach_money),
      RouteModel(
        path: "/incoming-payments",
        name: "Incoming Payments",
        icon: Icons.payment,
      ),
      RouteModel(
        path: "/outgoing-payments",
        name: "Outgoing Payments",
        icon: Icons.payment_outlined,
      ),
      // Add more routes as needed
    ];

    final currentPath = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pocket Partners"),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref
                  .read(themeProvider.notifier)
                  .state = themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  //Imagen de fondo del DrawerHeader
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/images/bg_draw.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  //Sombra para la imagen
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                    
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: userInfo?.photo != null
                              ? NetworkImage(userInfo!.photo)
                              : const AssetImage(
                                      "assets/images/default_avatar.png",
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userInfo?.firstName ?? "Guest User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ...routeModels.map(
              (route) => ListTile(
                leading: Icon(route.icon),
                title: Text(route.name),
                selected: currentPath == route.path,
                onTap: () {
                  // Navigate to the selected route
                  context.go(route.path);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                authController.logout();
                context.go("/login");
              },
            ),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
