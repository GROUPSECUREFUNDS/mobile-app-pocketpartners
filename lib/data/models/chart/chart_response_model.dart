class ChartResponseModel {
  final String month;
  final double amount;
  final String color;

  ChartResponseModel({
    required this.month,
    required this.amount,
    required this.color,
  });

  factory ChartResponseModel.fromJson(Map<String, dynamic> json) {
    return ChartResponseModel(
      month: json['month'],
      amount: json['amount'].toDouble(),
      color: json['color'],
    );
  }
}