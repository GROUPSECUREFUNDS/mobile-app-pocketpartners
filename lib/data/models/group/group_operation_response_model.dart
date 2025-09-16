class GroupOperationResponseModel {
  final int id;
  final int groupId;
  final int expenseId;
  final int paymentId;

  GroupOperationResponseModel({
    required this.id,
    required this.groupId,
    required this.expenseId,
    required this.paymentId,
  });

  factory GroupOperationResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupOperationResponseModel(
      id: json['id'],
      groupId: json['groupId'],
      expenseId: json['expenseId'],
      paymentId: json['paymentId'],
    );
  }
}
