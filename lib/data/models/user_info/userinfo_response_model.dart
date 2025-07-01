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
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      photo: json['photo'],
      email: json['email'],
      userId: json['userId'],
    );
  }

}
