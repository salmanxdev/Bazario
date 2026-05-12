class AppUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'buyer' or 'seller'
  final String? profileImageUrl;
  final double walletBalance;

  AppUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profileImageUrl,
    this.walletBalance = 0.0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? 'buyer',
      profileImageUrl: map['profileImageUrl'],
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'walletBalance': walletBalance,
    };
  }
}
