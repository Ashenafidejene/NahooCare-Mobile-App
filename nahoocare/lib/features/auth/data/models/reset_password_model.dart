class ResetPasswordModel {
  final String phoneNumber;
  final String secretAnswer;
  final String newPassword;

  ResetPasswordModel({
    required this.phoneNumber,
    required this.secretAnswer,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'secret_answer': secretAnswer,
      'new_password': newPassword,
    };
  }
}
