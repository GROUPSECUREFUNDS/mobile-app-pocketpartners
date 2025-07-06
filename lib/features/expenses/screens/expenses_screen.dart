import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/user_info/userinfo_response_model.dart';
import '../../../data/services/userinformation_service.dart';
import '../models/expense_entity.dart';
import '../services/expenses_service.dart';
import 'expense_form.dart';

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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
                      );
                      if (result == true) {
                        setState(() {}); // Refresca la lista si se creó un gasto
                      }
                    },
                    child: const Text('+ New Expense'),
                  ),
                ),
              ),
              if (expenses.isEmpty)
                const Expanded(
                  child: Center(child: Text('No expenses found.')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expense: ${expense.name}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Created: ${_formatDate(expense.createdAt)}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
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
                                      return Text('Upload By: ${userSnapshot.data!.firstName} ${userSnapshot.data!.lastName}');
                                    },
                                  ),
                                  Text('Due Date: ${_formatDate(expense.dueDate)}'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            onPressed: null,
                                            icon: const Icon(Icons.credit_card, color: Colors.blue),
                                            tooltip: 'Pagar',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: null,
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Eliminar',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}