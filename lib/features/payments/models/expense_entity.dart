class ExpensesEntity {
  int id;
  String name;
  double amount;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;
  int groupId;
  DateTime dueDate;

  ExpensesEntity({
    this.id = 0,
    this.name = '',
    this.amount = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.userId = 0,
    this.groupId = 0,
    DateTime? dueDate,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now();

  factory ExpensesEntity.fromJson(Map<String, dynamic> json) {
    return ExpensesEntity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      userId: json['userId'] ?? 0,
      groupId: json['groupId'] ?? 0,
      dueDate: DateTime(
          json['dueDate'][0] as int,
          json['dueDate'][1] as int,
          json['dueDate'][2] as int
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'groupId': groupId,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}
