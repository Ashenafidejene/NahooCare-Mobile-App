import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:nahoocare/core/network/api_client.dart';
import 'package:nahoocare/core/network/network_info.dart';
import 'package:nahoocare/core/service/local_storage_service.dart';
import 'package:nahoocare/features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart';
import 'package:nahoocare/features/profile/data/datasource/health_profile_remote_data_source.dart';
import 'package:nahoocare/features/profile/data/repositories/health_profile_repository_impl.dart';
import 'package:nahoocare/features/profile/domain/repositories/health_profile_repository.dart';
import 'package:nahoocare/features/profile/domain/usecases/delete_health_profile.dart';
import 'package:nahoocare/features/profile/domain/usecases/update_health_profile.dart';
import 'package:nahoocare/features/profile/presentation/bloc/health_profile_bloc.dart';
import 'package:nahoocare/features/symptomSearch/data/datasources/location_data_source.dart';
import 'package:nahoocare/features/symptomSearch/data/datasources/symptom_search_remote_data_source.dart';
import 'package:nahoocare/features/symptomSearch/domain/repositories/symptom_search_repository.dart';
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
import 'features/healthcare_center/data/datasource/healthcare_remote_data_source.dart';
import 'features/healthcare_center/data/repositories/healthcare_repository_impl.dart';
import 'features/healthcare_center/domain/repositories/healthcare_repository.dart';
import 'features/healthcare_center/domain/usecases/get_center_ratings.dart';
import 'features/healthcare_center/domain/usecases/get_healthcare_center_details.dart';
import 'features/healthcare_center/domain/usecases/submit_rating.dart';
import 'features/hospitalSearch/data/datasources/healthcare_remote_data_source.dart';
import 'features/hospitalSearch/data/repository/healthcare_repository_impl.dart'
    show HealthcareRepositoryImpls;
import 'features/hospitalSearch/domain/repository/healthcare_repository.dart';
import 'features/hospitalSearch/domain/usecases/search_by_location.dart';
import 'features/hospitalSearch/domain/usecases/search_by_name.dart';
import 'features/hospitalSearch/domain/usecases/search_by_specialty.dart';
import 'features/hospitalSearch/domain/usecases/search_healthcare.dart';
import 'features/hospitalSearch/presentation/blocs/healthcare_search_bloc.dart';
import 'features/profile/domain/usecases/create_health_profile.dart';
import 'features/profile/domain/usecases/get_health_profile.dart';
import 'features/symptomSearch/data/repositories/symptom_search_repository_impl.dart';
import 'features/symptomSearch/domain/usecase/get_current_location.dart';
import 'features/symptomSearch/domain/usecase/search_nearby_centers.dart';
import 'features/symptomSearch/presentation/blocs/symptom_search_bloc.dart';

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
  sl.registerLazySingleton<HealthcareRemoteDataSources>(
    () => HealthcareRemoteDataSourcesImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      localStorageService: sl<LocalStorageService>(),
    ),
  );
  sl.registerLazySingleton<HealthcareRemoteDataSource>(
    () => HealthcareRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl());

  sl.registerLazySingleton<SymptomSearchRemoteDataSource>(
    () => SymptomSearchRemoteDataSourceImpl(apiClient: sl()),
  );
  // Repository
  sl.registerLazySingleton<HealthcareRepository>(
    () => HealthcareRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<SymptomSearchRepository>(
    () => SymptomSearchRepositoryImpl(
      remoteDataSource: sl(),
      locationDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HealthProfileRemoteDataSource>(
    () => HealthProfileRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<HealthcareRepositorys>(
    () => HealthcareRepositoryImpls(remoteDataSource: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => SearchByNames(sl()));
  sl.registerLazySingleton(() => SearchBySpecialtys(sl()));
  sl.registerLazySingleton(() => SearchByLocations(sl()));
  sl.registerLazySingleton(() => SearchHealthcare(sl()));
  sl.registerLazySingleton(() => GetHealthcareCenterDetails(sl()));
  sl.registerLazySingleton(() => GetCenterRatings(sl()));
  sl.registerLazySingleton(() => SubmitRating(sl()));
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
  sl.registerLazySingleton(() => SearchNearbyCenters(sl()));
  sl.registerLazySingleton(() => GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => GetHealthProfile(sl()));
  sl.registerLazySingleton(() => DeleteHealthProfile(sl()));
  sl.registerLazySingleton(() => UpdateHealthProfile(sl()));
  sl.registerLazySingleton(() => CreateHealthProfile(sl()));
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
  sl.registerFactory(
    () => HealthProfileBloc(
      getHealthProfile: sl(),
      createHealthProfile: sl(),
      updateHealthProfile: sl(),
      deleteHealthProfile: sl(),
    ),
  );
  sl.registerFactory(
    () =>
        SymptomSearchBloc(searchNearbyCenters: sl(), getCurrentLocation: sl()),
  );
  sl.registerFactory(
    () => HealthcareCenterBloc(
      getHealthcareCenterDetails: sl(),
      getCenterRatings: sl(),
      submitRating: sl(),
    ),
  );
  sl.registerFactory(
    () => HealthcareSearchBloc(
      searchByName: sl(),
      searchBySpecialty: sl(),
      searchByLocation: sl(),
      searchHealthcare: sl(),
    ),
  );
}
