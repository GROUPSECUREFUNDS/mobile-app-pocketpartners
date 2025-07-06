class GroupRequestModel {
  final String name;
  final String groupPhoto;
  final String description;
  final int adminId;

  GroupRequestModel({
    required this.name,
    required this.groupPhoto,
    required this.description,
    required this.adminId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'groupPhoto': groupPhoto,
      'description': description,
      'adminId': adminId,
    };
  }
}