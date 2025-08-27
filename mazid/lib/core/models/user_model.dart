class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
