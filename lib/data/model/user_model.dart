class UserProfileResponse {
  final String message;
  final User user;

  UserProfileResponse({
    required this.message,
    required this.user,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String status;
  final List<dynamic> businesses;
  final bool isBusinessCreated;
  final bool hasJoinedBusiness;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.status,
    required this.businesses,
    required this.isBusinessCreated,
    required this.hasJoinedBusiness,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      businesses: json['businesses'] ?? [],
      isBusinessCreated: json['is_business_created'] ?? false,
      hasJoinedBusiness: json['has_joined_business'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'status': status,
      'businesses': businesses,
      'is_business_created': isBusinessCreated,
      'has_joined_business': hasJoinedBusiness,
    };
  }
}
