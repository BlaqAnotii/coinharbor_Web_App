class Member {
  final int id;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String role;

  Member({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
    );
  }
}

class MembersResponse {
  final String message;
  final List<Member> members;

  MembersResponse({
    required this.message,
    required this.members,
  });

  factory MembersResponse.fromJson(Map<String, dynamic> json) {
    return MembersResponse(
      message: json['message'],
      members: (json['members'] as List)
          .map((member) => Member.fromJson(member))
          .toList(),
    );
  }
}
