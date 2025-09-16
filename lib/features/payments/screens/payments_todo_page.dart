import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class PaymentsTodoPage extends StatefulWidget {
  const PaymentsTodoPage({Key? key}) : super(key: key);

  @override
  State<PaymentsTodoPage> createState() => _PaymentsTodoPageState();
}

class _PaymentsTodoPageState extends State<PaymentsTodoPage> {
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
    setState(() => loading = true);
    try {
      final user = await authController.getCurrentUser();
      if (user != null) {
        final paymentsData = await paymentService.getPaymentByUserIdAndStatus(user.id, 'PENDING');

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
        });
      }
    } catch (e) {
      print("Error fetching payments: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando pagos pendientes")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> makePayment(int paymentId) async {
    try {
      debugPrint("OOOOOOOOO/////////////&6&&&&&&&&&&&&6:$paymentId");
      await paymentService.makePayment(paymentId); // PUT /completed
      fetchPayments(); // refresca tras pagar
    } catch (e) {
      print("Error making payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al realizar el pago")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (payments.isEmpty) {
      return const Center(child: Text("No tienes pagos pendientes"));
    }

    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final item = payments[index];
        final payment = item['payment'] as PaymentModel;
        final expense = item['expense'] as ExpensesEntity;
        final group = item['groupdata'] as GroupEntity;

        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre pago: ${expense.name}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Monto: ${payment.amount}"),
                Text("Estado: ${payment.status}"),
                Text("Expense: ${expense.name}"),
                Text("Grupo: ${group.name}"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => makePayment(payment.id),
                  child: const Text("MAKE PAYMENT"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
