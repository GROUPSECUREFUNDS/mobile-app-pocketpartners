
class GroupResponseModel {
  final int id;
  final String name;
  final String groupPhoto;
  final String description;
  final int adminId;
  final DateTime createdAt;

  GroupResponseModel({
    required this.id,
    required this.name,
    required this.groupPhoto,
    required this.description,
    required this.adminId,
    required this.createdAt,
  });

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupResponseModel(
      id: json['id'],
      name: json['name'],
      groupPhoto: json['groupPhoto'],
      description: json['description'],
      adminId: json['adminId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
