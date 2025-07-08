class PaymentRequestModel {
  final String description;
  final double amount;
  final String status;
  final int userId;
  final int expenseId;

  PaymentRequestModel({
    required this.description,
    required this.amount,
    required this.status,
    required this.userId,
    required this.expenseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'status': status,
      'userId': userId,
      'expenseId': expenseId,
    };
  }
}
