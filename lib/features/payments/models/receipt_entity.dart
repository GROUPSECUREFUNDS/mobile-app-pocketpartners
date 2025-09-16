class ReceiptEntity {
  final int id;
  final String? name;
  final String? receiptNumber;
  final double? amount;
  final DateTime? issueDate;
  final String? imagePath;

  ReceiptEntity({
    required this.id,
    this.name,
    this.receiptNumber,
    this.amount,
    this.issueDate,
    this.imagePath,
  });

  factory ReceiptEntity.fromJson(Map<String, dynamic> json) {
    final issueDateArray = json['issueDate'];
    DateTime? parsedDate;
    if (issueDateArray != null && issueDateArray is List) {
      parsedDate = DateTime(issueDateArray[0], issueDateArray[1], issueDateArray[2]);
    }

    return ReceiptEntity(
      id: json['id'],
      name: json['name'],
      receiptNumber: json['receiptNumber'],
      amount: (json['amount'] as num?)?.toDouble(),
      issueDate: parsedDate,
      imagePath: json['imagePath'],
    );
  }
}
