class LoginEntity {
  final String phoneNumber;
  final String password;

  const LoginEntity({required this.phoneNumber, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginEntity &&
        other.phoneNumber == phoneNumber &&
        other.password == password;
  }

  @override
  int get hashCode => phoneNumber.hashCode ^ password.hashCode;
}
