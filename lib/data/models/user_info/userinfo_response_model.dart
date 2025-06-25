class UserinfoResponseModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String photo;
  final String email;
  final int userId;

  UserinfoResponseModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.photo,
    required this.email,
    required this.userId,
  });
  factory UserinfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserinfoResponseModel(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      photo: json['photo'],
      email: json['email'],
      userId: json['userId'],
    );
  }

}
