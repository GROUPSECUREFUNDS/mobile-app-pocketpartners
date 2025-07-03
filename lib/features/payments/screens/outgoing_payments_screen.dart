import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';

class OutgoingPaymentsScreen extends StatefulWidget {
  const OutgoingPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<OutgoingPaymentsScreen> createState() => _OutgoingPaymentsScreenState();
}

class _OutgoingPaymentsScreenState extends State<OutgoingPaymentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PaymentService paymentService = PaymentService();
  final AuthController authController = AuthController();

  List<PaymentModel> paymentsMade = [];
  List<PaymentModel> paymentsToDo = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOutgoingPayments();
  }

  Future<void> fetchOutgoingPayments() async {
    try {
      final user = await authController.getUserFromPreferences();
      if (user != null) {
        final made = await paymentService.getPaymentByUserIdAndStatus(user.id, "COMPLETED");
        final todo = await paymentService.getPaymentByUserIdAndStatus(user.id, "PENDING");
        setState(() {
          paymentsMade = made;
          paymentsToDo = todo;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching outgoing payments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildPaymentList(List<PaymentModel> payments) {
    return payments.isEmpty
        ? const Center(child: Text("No payments available."))
        : ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text(payment.description),
            subtitle: Text("Amount: \$${payment.amount}"),
            trailing: Text(payment.status),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Outgoing Payments"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Payments Made"),
            Tab(text: "Payments To Do"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          buildPaymentList(paymentsMade),
          buildPaymentList(paymentsToDo),
        ],
      ),
    );
  }
}
