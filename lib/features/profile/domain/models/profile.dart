class Address {
  const Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final bool isDefault;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      label: (json['label'] ?? json['name'] ?? 'Address').toString(),
      street: (json['street'] ?? json['addressLine1'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      postalCode: (json['postalCode'] ?? json['pincode'] ?? '').toString(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  String get fullAddress => [street, city, state, country, postalCode].where((value) => value.trim().isNotEmpty).join(', ');
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.addresses = const [],
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final List<Address> addresses;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final list = (json['addresses'] as List? ?? const [])
        .map((item) => Address.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return UserProfile(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      firstName: (json['firstName'] ?? json['first_name'] ?? '').toString(),
      lastName: (json['lastName'] ?? json['last_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: json['phone']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      addresses: list,
    );
  }

  String get fullName => [firstName, lastName].where((value) => value.trim().isNotEmpty).join(' ');
}
