class AuthModel {
  final String token;
  final String tokenType;

  AuthModel({required this.token, required this.tokenType});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': token, 'token_type': tokenType};
  }
}
