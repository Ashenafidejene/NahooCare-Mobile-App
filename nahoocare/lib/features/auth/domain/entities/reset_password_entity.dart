class ResetPasswordEntity {
  final String phoneNumber;
  final String secretAnswer;
  final String newPassword;

  const ResetPasswordEntity({
    required this.phoneNumber,
    required this.secretAnswer,
    required this.newPassword,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResetPasswordEntity &&
        other.phoneNumber == phoneNumber &&
        other.secretAnswer == secretAnswer &&
        other.newPassword == newPassword;
  }

  @override
  int get hashCode =>
      phoneNumber.hashCode ^ secretAnswer.hashCode ^ newPassword.hashCode;
}
