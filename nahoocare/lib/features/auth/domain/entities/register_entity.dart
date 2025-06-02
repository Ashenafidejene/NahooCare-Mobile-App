class RegisterEntity {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String secretQuestion;
  final String secretAnswer;
  final String photoUrl; // Add this
  final String gender;
  final String dataOfBirth; // Add this

  RegisterEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.secretQuestion,
    required this.secretAnswer,
    required this.photoUrl, // Add this
    required this.gender,
    required this.dataOfBirth, // Add this
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterEntity &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.secretQuestion == secretQuestion &&
        other.secretAnswer == secretAnswer &&
        other.photoUrl == photoUrl &&
        other.gender == gender &&
        other.dataOfBirth == dataOfBirth;
  }

  @override
  int get hashCode =>
      fullName.hashCode ^
      phoneNumber.hashCode ^
      password.hashCode ^
      secretQuestion.hashCode ^
      secretAnswer.hashCode;
}
