class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.isEmailVerified = false,
  });

  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final bool isEmailVerified;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? json['fullName'] ?? 'Customer').toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      isEmailVerified:
          json['isEmailVerified'] == true || json['emailVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
    };
  }
}
