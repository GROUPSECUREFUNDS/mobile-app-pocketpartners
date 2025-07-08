class PartnerResponseModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String photo;

  PartnerResponseModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photo,
  });

  factory PartnerResponseModel.fromJson(Map<String, dynamic> json) {
    return PartnerResponseModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      photo: json['photo'],
    );
  }
}
