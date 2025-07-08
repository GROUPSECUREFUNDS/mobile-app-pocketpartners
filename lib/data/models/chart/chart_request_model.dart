class ChartRequestModel {
  final String month;
  final double amount;
  final String color;

  ChartRequestModel({
    required this.month,
    required this.amount,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
      'color': color,
    };
  }
}


