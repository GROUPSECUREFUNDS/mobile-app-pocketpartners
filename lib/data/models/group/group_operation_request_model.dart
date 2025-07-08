class GroupOperationRequestModel {
  final int groupId;
  final int expenseId;
  final int paymentId;

  GroupOperationRequestModel({
    required this.groupId,
    required this.expenseId,
    required this.paymentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'expenseId': expenseId,
      'paymentId': paymentId,
    };
  }
}
