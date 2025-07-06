
class PaymentResponseModel {
  final int id;
  final String description;
  final double amount;
  final String status;
  final int userId;
  final int expenseId;

  PaymentResponseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.status,
    required this.userId,
    required this.expenseId,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      status: json['status'].toString(),
      userId: json['userId'],
      expenseId: json['expenseId'],
    );
  }
}
