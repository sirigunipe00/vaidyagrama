class UserModel {
  final String name;
  final String fullName;

  UserModel({
    required this.name,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      fullName: json['full_name'] ?? json['name'],
    );
  }
}