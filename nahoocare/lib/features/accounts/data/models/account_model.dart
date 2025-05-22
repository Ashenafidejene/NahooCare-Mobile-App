import '../../domain/entities/account_entity.dart';

class AccountResponse {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;

  AccountResponse({
    required this.fullName,
    required this.phoneNumber,
    required this.secretQuestion,
    required this.secretAnswer,
  });

  // Convert to Entity
  AccountEntity toEntity() => AccountEntity(
    fullName: fullName,
    phoneNumber: phoneNumber,
    secretQuestion: secretQuestion,
    secretAnswer: secretAnswer,
  );
  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      secretQuestion: json['secret_question'] as String,
      secretAnswer: json['secret_answer'] as String,
    );
  }
}

class UpdateAccountRequest {
  final String fullName;
  final String phoneNumber;
  final String secretQuestion;
  final String secretAnswer;
  final String password;

  UpdateAccountRequest({
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
  );
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'secret_question': secretQuestion,
      'secret_answer': secretAnswer,
      'password': password,
    };
  }
}
