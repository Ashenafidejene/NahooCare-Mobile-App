class LoginModel {
  final String phoneNumber;
  final String password;

  LoginModel({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'password': password};
  }
}
