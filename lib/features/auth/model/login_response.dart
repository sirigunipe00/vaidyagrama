class LoginResponse {

  LoginResponse({
    this.message,
    this.homePage,
    this.fullName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      homePage: json['home_page'],
      fullName: json['full_name'],
    );
  }
  final String? message;
  final String? homePage;
  final String? fullName;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'home_page': homePage,
      'full_name': fullName,
    };
  }
}
