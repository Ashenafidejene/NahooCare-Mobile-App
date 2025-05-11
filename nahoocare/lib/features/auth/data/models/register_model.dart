class RegisterModel {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String secretQuestion;
  final String secretAnswer;

  RegisterModel({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.secretQuestion,
    required this.secretAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'password': password,
      'secret_question': secretQuestion,
      'secret_answer': secretAnswer,
    };
  }
}
