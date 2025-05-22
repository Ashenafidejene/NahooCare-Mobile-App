class AccountEntity {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;

  AccountEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.secretQuestion,
    required this.secretAnswer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountEntity &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.secretQuestion == secretQuestion &&
        other.secretAnswer == secretAnswer;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        phoneNumber.hashCode ^
        secretQuestion.hashCode ^
        secretAnswer.hashCode;
  }
}
