class PaymentModel {
  final int id;
  final double amount;
  final String description;
  final String status;
  final int expenseId;
  final int userId;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.status,
    required this.expenseId,
    required this.userId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      expenseId: json['expenseId'],
      userId: json['userId'],
    );
  }
}
