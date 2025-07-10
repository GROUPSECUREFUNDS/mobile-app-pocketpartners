import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';
import 'package:mobile_app_pocketpartners/data/services/userinformation_service.dart';

class IncomingPaymentsScreen extends StatefulWidget {
  const IncomingPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<IncomingPaymentsScreen> createState() => _IncomingPaymentsScreenState();
}

class _IncomingPaymentsScreenState extends State<IncomingPaymentsScreen> {
  final PaymentService paymentService = PaymentService();
  final AuthController authController = AuthController();
  final UserinformationService userInformationService = UserinformationService();

  List<Map<String, dynamic>> payments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIncomingPayments();
  }

  Future<void> fetchIncomingPayments() async {
    try {
      final user = await authController.getCurrentUser();
      if (user != null) {
        final userInfo = await userInformationService.getByUserId(user.id);
        final paymentsData = await paymentService.getIncomingPaymentsByUserInformationId(userInfo.id);

        List<Map<String, dynamic>> enrichedPayments = [];

        for (var payment in paymentsData) {
          final expense = await paymentService.getExpenseById(payment.expenseId);
          final groupdata = await paymentService.getGroupById(expense.groupId);


          enrichedPayments.add({
            'payment': payment,
            'expense': expense,
            'groupdata': groupdata,
          });
        }

        setState(() {
          payments = enrichedPayments;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching incoming payments: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Payments"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(child: Text("No incoming payments available."))
          : ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final item = payments[index];
          final payment = item['payment'] as PaymentModel;
          final expense = item['expense'] as ExpensesEntity;
          final groupdata = item['groupdata'] as GroupEntity;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${expense.name} - \$${payment.amount}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Due Date: ${expense.dueDate}"),
                  const SizedBox(height: 4),
                  Text("Description: ${payment.description}"),
                  const SizedBox(height: 4),
                  Text("Expense: ${expense.name}"),
                  const SizedBox(height: 4),
                  Text("Group: ${groupdata.name}"),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // acción si deseas
                    },
                    icon: const Icon(Icons.access_time, color: Colors.white),
                    label: const Text("Pending"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
