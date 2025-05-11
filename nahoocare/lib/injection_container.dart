import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:nahoocare/core/network/api_client.dart';
import 'package:nahoocare/core/network/network_info.dart';
import 'package:nahoocare/core/service/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_secret_question_usecase.dart';
import 'features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize environment variables
  await dotenv.load();

  // External packages
  sl.registerSingleton<Connectivity>(Connectivity());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  sl.registerSingleton<LocalStorageService>(
    LocalStorageServiceImpl(sl<SharedPreferences>()),
  );

  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(sl<Connectivity>()));

  // NEW: Register http.Client instead of Dio
  sl.registerSingleton<http.Client>(http.Client());

  // Update ApiClient to use http and not Dio
  sl.registerSingleton<ApiClient>(
    ApiClient(
      localStorage: sl<LocalStorageService>(),
      baseUrl: dotenv.env['API_URL'] ?? 'https://api.example.com',
    ),
  );

  // Data sources
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      localStorageService: sl<LocalStorageService>(),
    ),
  );

  // Repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl<AuthRepository>()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl<AuthRepository>()));
  sl.registerSingleton<GetSecretQuestionUseCase>(
    GetSecretQuestionUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<ResetPasswordUseCase>(
    ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<IsAuthenticatedUseCase>(
    IsAuthenticatedUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      getSecretQuestionUseCase: sl<GetSecretQuestionUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      isAuthenticatedUseCase: sl<IsAuthenticatedUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );
}
