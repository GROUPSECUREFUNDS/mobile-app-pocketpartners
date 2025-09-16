class RegisterResponseModel {
  final int id;
  final String username;
  final List<String> roles;

  RegisterResponseModel({
    required this.id,
    required this.username,
    required this.roles,
  });
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      id: json['id'],
      username: json['username'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}
