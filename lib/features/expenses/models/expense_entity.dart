class ExpenseModel {
  final int id;
  final String name;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final int groupId;
  final DateTime dueDate;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.groupId,
    required this.dueDate,
  });

  static DateTime _parseDate(dynamic value) {
    if (value is int) {
      // Timestamp en milisegundos
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is List && value.length >= 3) {
      // Formato [año, mes, día]
      return DateTime(value[0], value[1], value[2]);
    } else {
      throw Exception('Formato de fecha no soportado: $value');
    }
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      userId: json['userId'],
      groupId: json['groupId'],
      dueDate: _parseDate(json['dueDate']),
    );
  }
}