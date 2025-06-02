import '../../domain/entities/account_entity.dart';

class AccountResponse {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;
  final String photoUrl;
  final String dataOfBirth;
  final String gender;

  AccountResponse({
    required this.fullName,
    required this.phoneNumber,
    required this.secretQuestion,
    required this.secretAnswer,
    required this.photoUrl,
    required this.dataOfBirth,
    required this.gender,
  });

  // Convert to Entity
  AccountEntity toEntity() => AccountEntity(
    fullName: fullName,
    phoneNumber: phoneNumber,
    secretQuestion: secretQuestion,
    secretAnswer: secretAnswer,
    photoUrl: photoUrl,
    dateOfBirth: dataOfBirth,
    gender: gender,
  );
  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      secretQuestion: json['secret_question'] as String,
      secretAnswer: json['secret_answer'] as String,
      photoUrl: json['photo_url'] as String,
      dataOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
    );
  }
}

class UpdateAccountRequest {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;
  final String password;
  final String gender;
  final String dataOfBirth;
  final String photoUrl;

  UpdateAccountRequest({
    required this.photoUrl,
    required this.dataOfBirth,
    required this.gender,
    required this.fullName,
    required this.phoneNumber,
    required this.secretQuestion,
    required this.secretAnswer,
    required this.password,
  });

  // Convert from Entity
  factory UpdateAccountRequest.fromEntity({
    required AccountEntity entity,
    required String password,
  }) => UpdateAccountRequest(
    fullName: entity.fullName,
    phoneNumber: entity.phoneNumber,
    secretQuestion: entity.secretQuestion,
    secretAnswer: entity.secretAnswer,
    password: password,
    gender: entity.gender,
    dataOfBirth: entity.dateOfBirth,
    photoUrl: entity.photoUrl,
  );
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'secret_question': secretQuestion,
      'secret_answer': secretAnswer,
      'password': password,
      'photo_url': photoUrl,
      'gender': gender,
      'date_of_birth': dataOfBirth,
    };
  }
}
