import 'package:flutter/material.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/payment_model.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/expense_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/models/group_entity.dart';
import 'package:mobile_app_pocketpartners/features/payments/screens/payment_details_page.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final ExpensesEntity expense;
  final GroupEntity groupdata;


  const PaymentCard({
    Key? key,
    required this.payment,
    required this.expense,
    required this.groupdata,


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
            Text("Due Date: ${expense.dueDate}"),
            Text("Expense: ${expense.name}"),
            Text("Group Name: ${groupdata.name}"),

          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentDetailsPage(
                  payment: payment,
                  expense: expense,
                  groupdata: groupdata,
                ),
              ),
            );
          },
          child: const Text("See Receipts"),
        ),
      ),
    );
  }
}