import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/data/models/auth/login_response_model.dart';
import 'package:mobile_app_pocketpartners/features/home/components/timeline.dart';
import 'package:mobile_app_pocketpartners/shared/services/partner_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/expenses_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/group_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/chart_service.dart';

import '../../../data/models/chart/chart_response_model.dart';
import '../../../data/models/expenses/expenses_response_model.dart';
import '../../../data/models/group/group_response_model.dart';
import '../../../data/models/partner/partner_response_model.dart';
import '../components/chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = AuthController();
  final partnerService = PartnerService();
  final expensesService = ExpensesService();
  final groupService = GroupService();
  final chartService = ChartService();

  LoginResponseModel? userData;
  PartnerResponseModel? partner;
  List<ExpensesResponseModel> expenses = [];
  List<GroupResponseModel> groups = [];
  List<ChartResponseModel> chartData = [];

  @override
  void initState() {
    super.initState();
    authController.getUserFromPreferences().then((user) async {
      if (user != null) {
        setState(() => userData = user);
        await fetchPartner(user.id);
        await fetchExpensesByUserId(user.id);
        await fetchGroups(user.id);
        await fetchChartData();
      }
    });
  }

  Future<void> fetchPartner(int userId) async {
    partner = await partnerService.getPartnerById(userId);
    setState(() {});
  }

  Future<void> fetchExpensesByUserId(int userId) async {
    expenses = await expensesService.getExpensesByUserId(userId);
    setState(() {});
  }

  Future<void> fetchGroups(int userId) async {
    groups = await groupService.getGroupsByUserId(userId);
    setState(() {});
  }

  Future<void> fetchChartData() async {
    chartData = await chartService.getAllChartData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final name = partner?.fullName ?? 'Invitado';
    final email = partner?.email ?? '';
    final photo = partner?.photo ?? ''; // Usamos cadena vacía si no hay URL

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Para evitar overflow
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 768;
              return isMobile
                  ? Column(
                children: [
                  _buildLeftSection(name, email, photo),
                  const SizedBox(height: 20),
                  _buildRightSection(),
                ],
              )
                  : Row(
                children: [
                  Expanded(child: _buildLeftSection(name, email, photo)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildRightSection()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSection(String name, String email, String photoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: photoUrl.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hola, $name",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(email, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text("¡Qué gusto verte de nuevo!", style: TextStyle(fontSize: 13)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const TransactionsTimeline(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRightSection() {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: const SizedBox(
            height: 350, // puedes ajustar este valor
            child: ExpensesChart(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

}
