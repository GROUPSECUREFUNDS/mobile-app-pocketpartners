import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/shared/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/shared/services/expenses_service.dart';
import 'package:mobile_app_pocketpartners/data/models/payment/payment_response_model.dart';
import 'package:mobile_app_pocketpartners/data/models/expenses/expenses_response_model.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';

class TransactionsTimeline extends StatefulWidget {
  const TransactionsTimeline({super.key});

  @override
  State<TransactionsTimeline> createState() => _TransactionsTimelineState();
}

class _TransactionsTimelineState extends State<TransactionsTimeline> {
  final ExpensesService expensesService = ExpensesService();
  final PaymentService paymentService = PaymentService();
  final AuthController authController = AuthController();

  List<ExpensesResponseModel> expenses = [];
  List<PaymentResponseModel> payments = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    authController.getUserFromPreferences().then((user) async {
      if (user != null) {
        userId = user.id;
        await loadExpenses(userId!);
        await loadPayments(userId!);
      }
    });
  }

  Future<void> loadExpenses(int userId) async {
    try {
      expenses = await expensesService.getExpensesByUserId(userId);
      debugPrint("🧾 Cargados ${expenses.length} gastos");
      for (var e in expenses) {
        debugPrint("➡️ Gasto: ${e.name} - \$${e.amount}");
      }
      setState(() {});
    } catch (e) {
      debugPrint("❌ Error cargando gastos: $e");
    }
  }


  Future<void> loadPayments(int userId) async {
    payments = await paymentService.getPaymentsByUserId(userId);
    print("Pagos cargados: ${payments.length}");
    setState(() {});
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Línea de Tiempo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6A1B9A)),
            ),
            const SizedBox(height: 12),
            if (payments.isEmpty && expenses.isEmpty)
              const Text("No hay transacciones disponibles", style: TextStyle(color: Colors.grey)),
            if (payments.isNotEmpty)
              ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text("Pagos", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
                ),
                ...payments.map((p) => _buildTimelineCard("Pago", p.description, p.amount, p.status)).toList(),
              ],
            if (expenses.isNotEmpty)
              ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 6),
                  child: Text("Gastos", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
                ),
                ...expenses.map((e) => _buildTimelineCard("Gasto", e.name, e.amount, null)).toList(),
              ],
          ],
        ),
      ),
    );
  }


  Widget _buildTimelineCard(String type, String title, double amount, dynamic status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            type == "Pago" ? Icons.payment_outlined : Icons.money_off_csred_outlined,
            color: const Color(0xFF7E57C2),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A148C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (status != null)
                  Text(
                    "Estado: $status",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF43A047),
            ),
          ),
        ],
      ),
    );
  }

}
