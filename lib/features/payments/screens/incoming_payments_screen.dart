import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/data/services/userinformation_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';

class IncomingPaymentsScreen extends StatefulWidget {
  const IncomingPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<IncomingPaymentsScreen> createState() => _IncomingPaymentsScreenState();
}

class _IncomingPaymentsScreenState extends State<IncomingPaymentsScreen> {
  final PaymentService paymentService = PaymentService();
  final UserinformationService userInformationService = UserinformationService();
  final AuthController authController = AuthController();

  List<PaymentModel> payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIncomingPayments();
  }

  Future<void> fetchIncomingPayments() async {
    try {
      final user = await authController.getUserFromPreferences();
      if (user != null) {
        final userInfo = await userInformationService.getByUserId(user.id);
        final result = await paymentService.getIncomingPaymentsByUserInformationId(userInfo.id);

        setState(() {
          payments = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching incoming payments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Incoming Payments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(child: Text("No incoming payments available."))
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
      ),
    );
  }
}
