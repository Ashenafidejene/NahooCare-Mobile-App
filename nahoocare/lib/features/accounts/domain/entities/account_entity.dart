// ignore_for_file: public_member_api_docs, sort_constructors_first
class AccountEntity {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;
  final String photoUrl;
  final String dateOfBirth;
  final String gender;

  AccountEntity({
    required this.fullName,
    required this.phoneNumber,
    required this.secretQuestion,
    required this.secretAnswer,
    required this.photoUrl,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountEntity &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.secretQuestion == secretQuestion &&
        other.secretAnswer == secretAnswer &&
        other.photoUrl == photoUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        phoneNumber.hashCode ^
        secretQuestion.hashCode ^
        secretAnswer.hashCode;
  }

  AccountEntity copyWith({
    String? fullName,
    String? phoneNumber,
    String? secretQuestion,
    String? secretAnswer,
    String? photoUrl,
    String? dateOfBirth,
    String? gender,
  }) {
    return AccountEntity(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      secretQuestion: secretQuestion ?? this.secretQuestion,
      secretAnswer: secretAnswer ?? this.secretAnswer,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
