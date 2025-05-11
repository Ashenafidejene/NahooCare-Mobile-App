class AuthEntity {
  final String token;
  final String tokenType;

  const AuthEntity({required this.token, required this.tokenType});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthEntity &&
        other.token == token &&
        other.tokenType == tokenType;
  }

  @override
  int get hashCode => token.hashCode ^ tokenType.hashCode;
}
