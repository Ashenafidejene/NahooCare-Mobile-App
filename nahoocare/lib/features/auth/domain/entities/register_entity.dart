class RegisterEntity {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String secretQuestion;
  final String secretAnswer;

  const RegisterEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.secretQuestion,
    required this.secretAnswer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterEntity &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.secretQuestion == secretQuestion &&
        other.secretAnswer == secretAnswer;
  }

  @override
  int get hashCode =>
      fullName.hashCode ^
      phoneNumber.hashCode ^
      password.hashCode ^
      secretQuestion.hashCode ^
      secretAnswer.hashCode;
}
