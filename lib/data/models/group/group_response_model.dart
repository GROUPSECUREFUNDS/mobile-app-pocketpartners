class GroupResponseModel {
  final int id;
  final String name;
  final String description;
  final String groupPhoto;
  final DateTime createdAt;
  //final DateTime updatedAt;
  final int adminId;

  GroupResponseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.groupPhoto,
    required this.createdAt,
    //required this.updatedAt,
    required this.adminId,
  });

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupResponseModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      groupPhoto: json['groupPhoto']?.toString() ?? 'https://via.placeholder.com/150',
      description: json['description']?.toString() ?? '',
      adminId: json['adminId'] ?? 0,
      createdAt: _parseDate(json['createdAt']),
    );
  }
  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime(2000); // Valor por defecto si no se puede parsear
      }
    } else {
      return DateTime(2000);
    }
  }
}
