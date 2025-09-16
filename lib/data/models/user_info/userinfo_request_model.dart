class UserinfoRequestModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String photo;
  final String email;
  int userId;

  UserinfoRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.photo,
    required this.email,
    required this.userId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'email': email,
      'userId': userId,
    };
  }

}
