class UserModel {

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      fullName: json['full_name'] ?? json['name'],
    );
  }

  UserModel({
    required this.name,
    required this.fullName,
  });
  final String name;
  final String fullName;
}