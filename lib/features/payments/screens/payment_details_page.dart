import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/receipt_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/services/payment_service.dart';
import 'package:mobile_app_pocketpartners/features/payments/screens/add_receipt_dialog.dart';

class PaymentDetailsPage extends StatefulWidget {
  final PaymentModel payment;
  final ExpensesEntity expense;
  final GroupEntity groupdata;

  const PaymentDetailsPage({
    Key? key,
    required this.payment,
    required this.expense,
    required this.groupdata,
  }) : super(key: key);

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  final PaymentService paymentService = PaymentService();
  List<ReceiptEntity> receipts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchReceipts();
  }

  Future<void> fetchReceipts() async {
    try {
      final fetchedReceipts = await paymentService.getReceiptsByPaymentId(widget.payment.id);
      setState(() {
        receipts = fetchedReceipts;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching receipts: $e");
      setState(() => loading = false);
    }
  }

  void showAddReceiptDialog() async {
    final added = await showDialog(
      context: context,
      builder: (context) => AddReceiptDialog(payment: widget.payment),
    );

    if (added == true) {
      fetchReceipts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final expense = widget.expense;
    final group = widget.groupdata;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Details")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text("${expense.name} - \$${payment.amount}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${payment.description ?? "Sin descripción"}"),
                  Text("Expense: ${expense.name}"),
                  Text("Group: ${group.name}"),
                  Text("Due Date: ${expense.dueDate}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Comprobantes de pago",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...receipts.map((receipt) => ReceiptItem(receipt: receipt)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddReceiptDialog,
        child: const Icon(Icons.add),
        tooltip: "Agregar comprobante",
      ),
    );
  }
}




class ReceiptItem extends StatelessWidget {
  final ReceiptEntity receipt;

  const ReceiptItem({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = receipt.issueDate != null
        ? DateFormat('dd/MM/yyyy').format(receipt.issueDate!)
        : "Sin fecha";

    return ExpansionTile(
      title: Text(receipt.name ?? "Sin nombre"),
      subtitle: Text("Monto: \$${receipt.amount?.toStringAsFixed(2) ?? "0.00"}"),
      children: [
        ListTile(
          title: const Text("Nombre del comprobante"),
          subtitle: Text(receipt.name ?? "Sin nombre"),
        ),
        ListTile(
          title: const Text("Número del comprobante"),
          subtitle: Text(receipt.receiptNumber ?? "Sin número"),
        ),
        ListTile(
          title: const Text("Monto del comprobante"),
          subtitle: Text("\$${receipt.amount?.toStringAsFixed(2) ?? "0.00"}"),
        ),
        ListTile(
          title: const Text("Fecha de emisión"),
          subtitle: Text(formattedDate),
        ),
        if (receipt.imagePath != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              PaymentService().getImageUrl(receipt.imagePath!),
              errorBuilder: (context, error, stackTrace) =>
              const Text("No se pudo cargar la imagen"),
            ),
          ),

      ],
    );
  }
}
