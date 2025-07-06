class ContactEntity {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String photo;

  ContactEntity({
    this.id = 0,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.photo = '',
  });

  // Factory constructor to create a ContactEntity from JSON
  factory ContactEntity.fromJson(Map<String, dynamic> json) {
    return ContactEntity(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photo: json['photo'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photo': photo,
    };
  }
}
