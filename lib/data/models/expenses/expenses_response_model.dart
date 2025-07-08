class ExpensesResponseModel {
  final int id;
  final String name;
  final double amount;
  final int userId;
  final int groupId;
  final String dueDate;
  final String createdAt;
  final String updatedAt;

  ExpensesResponseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.userId,
    required this.groupId,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpensesResponseModel.fromJson(Map<String, dynamic> json) {
    return ExpensesResponseModel(
      id: json['id'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      userId: json['userId'],
      groupId: json['groupId'],
      dueDate: json['dueDate'].toString(),
      createdAt: json['createdAt'].toString(),
      updatedAt: json['updatedAt'].toString(),
    );
  }

}
