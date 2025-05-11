class AppConstants {
  // API Endpoints
  static const String loginEndpoint = 'api/account/login';
  static const String registerEndpoint = 'api/account/register';
  static const String secretQuestionEndpoint = 'api/account/getSecretQuestion';
  static const String resetPasswordEndpoint = 'api/account/resetPassword';

  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String invalidPhone = 'Enter a valid phone number';
  static const String shortPassword = 'Password must be at least 8 characters';
  static const String passwordMismatch = 'Passwords do not match';

  // Secret Questions
  static const List<String> secretQuestions = [
    'What was your first pet\'s name?',
    'What city were you born in?',
    'What is your mother\'s maiden name?',
    'What was the name of your first school?',
    'What was your childhood nickname?',
    'What is your favorite book?',
  ];

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDuration = Duration(seconds: 2);
}
