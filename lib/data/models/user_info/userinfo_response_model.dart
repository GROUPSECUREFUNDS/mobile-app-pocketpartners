class UserinfoResponseModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String photo;
  final String email;
  final int userId;

  UserinfoResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.photo,
    required this.email,
    required this.userId,
  });

  factory UserinfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserinfoResponseModel(
      id: json['id'] ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      userId: json['userId'] ?? 0,
    );
  }
}
