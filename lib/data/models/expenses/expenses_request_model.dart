class ExpensesRequestModel {
  final String name;
  final double amount;
  final DateTime dueDate;
  final int userId;
  final int groupId;

  ExpensesRequestModel({
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.userId,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'userId': userId,
      'groupId': groupId,
    };
  }
}
