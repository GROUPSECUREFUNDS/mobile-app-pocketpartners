import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/features/payments/screens/payment_card.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';


class PaymentsMadePage extends StatefulWidget {
  const PaymentsMadePage({Key? key}) : super(key: key);

  @override
  State<PaymentsMadePage> createState() => _PaymentsMadePageState();
}

class _PaymentsMadePageState extends State<PaymentsMadePage> {
  final PaymentService paymentService = PaymentService();
  final AuthController authController = AuthController();

  List<Map<String, dynamic>> payments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
   fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      final user = await authController.getCurrentUser();
      if (user != null) {
        final paymentsData = await paymentService.getPaymentByUserIdAndStatus(user.id, "COMPLETED");

        List<Map<String, dynamic>> enrichedPayments = [];

        for (var payment in paymentsData) {

          final expense = await paymentService.getExpenseById(payment.expenseId);
          final groupdata = await paymentService.getGroupById(expense.groupId);
          ///final groupmembers = await paymentService.getGroupMembers(expense.groupId);
         /// final member = await paymentService.getContactById(groupdata.adminId);

          enrichedPayments.add({
            'payment': payment,
            'expense': expense,
            'groupdata':groupdata,


          });
        }

        setState(() {
          payments = enrichedPayments;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching payments: $e");
      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (payments.isEmpty) {
      return const Center(child: Text("No payments made"));
    }

    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final item = payments[index];
        return PaymentCard(
          payment: item['payment'] as PaymentModel,
          expense: item['expense'] as ExpensesEntity,
          groupdata: item['groupdata'] as GroupEntity,

         /// contact: item['contact'] as ContactEntity,
        );
      },
    );
  }
}
