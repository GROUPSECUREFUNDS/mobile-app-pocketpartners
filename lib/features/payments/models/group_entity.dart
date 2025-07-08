class GroupEntity {
  int id;
  String name;
  String groupPhoto;
  String description;
  int adminId;
  DateTime createdAt;

  GroupEntity({
    this.id = 0,
    this.name = '',
    this.groupPhoto = '',
    this.description = '',
    this.adminId = 0,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now();

  factory GroupEntity.fromJson(Map<String, dynamic> json) {
    return GroupEntity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      groupPhoto: json['groupPhoto'] ?? '',
      description: json['description'] ?? '',
      adminId: json['adminId'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'groupPhoto': groupPhoto,
      'description': description,
      'adminId': adminId,
      'createdAt': createdAt.toIso8601String(),

    };
  }
}

class Member {
  int userId;
  String fullName;
  DateTime joinedAt;
  String role;

  Member({
    this.userId = 0,
    this.fullName = '',
    DateTime? joinedAt,
    this.role = '',
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'joinedAt': joinedAt.toIso8601String(),
      'role': role,
    };
  }
}

class HistoryEntry {
  int id;
  DateTime date;
  double amount;
  MemberInfo member;

  HistoryEntry({
    this.id = 0,
    DateTime? date,
    this.amount = 0.0,
    MemberInfo? member,
  })  : date = date ?? DateTime.now(),
        member = member ?? MemberInfo();

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      member: MemberInfo.fromJson(json['member'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'member': member.toJson(),
    };
  }
}

class MemberInfo {
  int id;
  String name;

  MemberInfo({
    this.id = 0,
    this.name = '',
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
