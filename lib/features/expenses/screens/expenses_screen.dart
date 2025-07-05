import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/user_info/userinfo_response_model.dart';
import '../../../data/services/userinformation_service.dart';
import '../models/expense_model.dart';
import '../services/expenses_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpensesService _expensesService = ExpensesService();
  final UserinformationService _userInformationService = UserinformationService();
  final Map<int, Future<UserinfoResponseModel>> _userCache = {};

  Future<List<ExpenseModel>> _fetchExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }
    final data = await _expensesService.getExpenses();
    return (data as List)
        .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
        .where((expense) => expense.userId == int.parse(userId))
        .toList();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  Future<UserinfoResponseModel> _getUserInfo(int userId) {
    return _userCache.putIfAbsent(
      userId,
          () => _userInformationService.getByUserId(userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: FutureBuilder<List<ExpenseModel>>(
        future: _fetchExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense: ${expense.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('Created: ${_formatDate(expense.createdAt)}'),
                      Text('Total Amount: \$${expense.amount.toStringAsFixed(2)}'),
                      FutureBuilder<UserinfoResponseModel>(
                        future: _getUserInfo(expense.userId),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Upload By: ...');
                          }
                          if (userSnapshot.hasError || userSnapshot.data == null) {
                            return const Text('Upload By: Unknown');
                          }
                          return Text('Upload By: ${userSnapshot.data!.fullName}');
                        },
                      ),
                      Text('Due Date: ${_formatDate(expense.dueDate)}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}