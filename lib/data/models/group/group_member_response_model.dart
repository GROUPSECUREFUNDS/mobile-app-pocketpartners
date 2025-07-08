class GroupMemberResponseModel {
  final int groupId;
  final int userId;
  final String fullName;
  final String role; // ADMIN o MEMBER
  final DateTime joinedAt;

  GroupMemberResponseModel({
    required this.groupId,
    required this.userId,
    required this.fullName,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMemberResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberResponseModel(
      groupId: json['groupId'],
      userId: json['userId'],
      fullName: json['fullName'],
      role: json['role'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
