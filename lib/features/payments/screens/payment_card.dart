import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/contact_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final ExpensesEntity expense;

  const PaymentCard({
    Key? key,
    required this.payment,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text("${expense.name} - ${payment.description} - \$${payment.amount}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Due Date: ${expense.dueDate.toIso8601String()}"),
            Text("Expense: ${expense.name}"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // TODO: acción para ver receipts
          },
          child: const Text("See Receipts"),
        ),
      ),
    );
  }
}