// group_response_model.dart
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

  static DateTime _parseDate(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw Exception('Formato de fecha no soportado: $value');
    }
  }

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupResponseModel(
      id: json['id'],
      name: json['name'],
      groupPhoto: json['groupPhoto'],
      description: json['description'],
      adminId: json['adminId'],
      createdAt: _parseDate(json['createdAt']),
    );
  }
}