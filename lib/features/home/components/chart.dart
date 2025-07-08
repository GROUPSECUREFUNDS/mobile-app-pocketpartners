import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_pocketpartners/core/controllers/auth_controller.dart';
import 'package:mobile_app_pocketpartners/shared/services/expenses_service.dart';
import 'package:mobile_app_pocketpartners/data/models/expenses/expenses_response_model.dart';

class ExpensesChart extends StatefulWidget {
  const ExpensesChart({super.key});

  @override
  State<ExpensesChart> createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> {
  final ExpensesService expensesService = ExpensesService();
  final AuthController authController = AuthController();

  List<ExpensesResponseModel> expenses = [];
  List<FlSpot> chartSpots = [];
  List<String> xLabels = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final user = await authController.getUserFromPreferences();
    if (user != null) {
      final data = await expensesService.getExpensesByUserId(user.id);    debugPrint("📦 Gastos obtenidos: ${data.length}");

      for (var e in data) {
        debugPrint("🧾 Gasto: ${e.name} - ${e.amount} - ${e.createdAt}");
      }
    }
    if (user != null) {
      final data = await expensesService.getExpensesByUserId(user.id);
      data.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Agrupar por día y sumar
      final Map<String, double> dailySums = {};
      for (var e in data) {
        String dateKey = DateFormat('dd/MM').format(
          DateTime.fromMillisecondsSinceEpoch(int.parse(e.createdAt)),
        );
        dailySums[dateKey] = (dailySums[dateKey] ?? 0) + e.amount;
      }

      xLabels = dailySums.keys.toList();
      chartSpots = dailySums.values.toList().asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      setState(() => isLoading = false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Gastos por Fecha", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 11),
            SizedBox(
              height: 285,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return Text(xLabels[index], style: const TextStyle(fontSize: 9));
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 22,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10)),
                        reservedSize: 28,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartSpots,
                      color: Colors.deepPurple,
                      barWidth: 1,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
