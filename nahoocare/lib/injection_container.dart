import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/service/local_storage_service.dart';
import 'core/theme/theme_cubit.dart';
import 'features/accounts/data/datasources/account_remote_data_source.dart';
import 'features/accounts/data/repository/account_repository_impl.dart';
import 'features/accounts/domain/repository/account_repository.dart';
import 'features/accounts/domain/usecases/delete_account_usecase.dart';
import 'features/accounts/domain/usecases/get_account_usecase.dart';
import 'features/accounts/domain/usecases/update_account_usecase.dart';
import 'features/accounts/presentation/blocs/account_bloc.dart';
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
import 'features/firstaid/data/datasources/local_first_aid_datasource.dart';
import 'features/firstaid/data/datasources/remote_first_aid_datasource.dart';
import 'features/firstaid/data/repository/first_aid_repository_impl.dart';
import 'features/firstaid/domain/repository/first_aid_repository.dart';
import 'features/firstaid/domain/usecase/get_first_aid_guides.dart';
import 'features/firstaid/presentation/blocs/first_aid_bloc.dart';
import 'features/healthcare_center/data/datasource/healthcare_remote_data_source.dart';
import 'features/healthcare_center/data/repositories/healthcare_repository_impl.dart';
import 'features/healthcare_center/domain/repositories/healthcare_repository.dart';
import 'features/healthcare_center/domain/usecases/get_center_ratings.dart';
import 'features/healthcare_center/domain/usecases/get_healthcare_center_details.dart';
import 'features/healthcare_center/domain/usecases/submit_rating.dart';
import 'features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart';
import 'features/history/data/datasource/remote_search_history_datasource.dart';
import 'features/history/data/repository/search_history_repository_impl.dart';
import 'features/history/domain/repositories/search_history_repository.dart';
import 'features/history/domain/usecases/delete_all_history_usecase.dart';
import 'features/history/domain/usecases/delete_single_history_usecase.dart';
import 'features/history/domain/usecases/get_history_usecase.dart';
import 'features/history/presentation/blocs/search_history_bloc.dart';
import 'features/hospitalSearch/data/datasources/healthcare_remote_data_source.dart';
import 'features/hospitalSearch/data/repository/healthcare_repository_impl.dart';
import 'features/hospitalSearch/domain/repository/healthcare_repository.dart';

import 'features/hospitalSearch/domain/usecases/filter_healthcare.dart';
import 'features/hospitalSearch/domain/usecases/get_healthcare.dart';
import 'features/hospitalSearch/domain/usecases/get_specialties.dart';
import 'features/hospitalSearch/domain/usecases/sort_healthcare.dart';
import 'features/hospitalSearch/presentation/blocs/healthcare_search_bloc.dart';
import 'features/profile/data/datasource/health_profile_remote_data_source.dart';
import 'features/profile/data/repositories/health_profile_repository_impl.dart';
import 'features/profile/domain/repositories/health_profile_repository.dart';
import 'features/profile/domain/usecases/create_health_profile.dart';
import 'features/profile/domain/usecases/delete_health_profile.dart';
import 'features/profile/domain/usecases/get_health_profile.dart';
import 'features/profile/domain/usecases/update_health_profile.dart';
import 'features/profile/presentation/bloc/health_profile_bloc.dart';
import 'features/symptomSearch/data/datasources/location_data_source.dart';
import 'features/symptomSearch/data/datasources/symptom_search_remote_data_source.dart';
import 'features/symptomSearch/data/repositories/symptom_search_repository_impl.dart';
import 'features/symptomSearch/domain/repositories/symptom_search_repository.dart';
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
  sl.registerLazySingleton<RemoteSearchHistoryDataSource>(
    () => RemoteSearchHistoryDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<HealthcareCenterRemoteDataSources>(
    () => HealthcareCenterRemoteDataSourcesImpl(apiClient: sl<ApiClient>()),
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
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
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
  sl.registerLazySingleton<LocalFirstAidDataSource>(
    () => LocalFirstAidDataSource(),
  );
  sl.registerLazySingleton<RemoteFirstAidDataSource>(
    () => RemoteFirstAidDataSource(client: sl()),
  );

  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HealthProfileRemoteDataSource>(
    () => HealthProfileRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<HealthcareRepositories>(
    () => HealthcareRepositoriesImpl(
      remoteDataSource: sl<HealthcareCenterRemoteDataSources>(),
      locationService: sl<LocationDataSource>(),
    ),
  );
  sl.registerLazySingleton<FirstAidRepository>(
    () => FirstAidRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      connectivity: sl(),
    ),
  );
  sl.registerLazySingleton<AccountRepository>(
    () =>
        AccountRepositoryImpl(remoteDataSource: sl<AccountRemoteDataSource>()),
  );
  sl.registerLazySingleton<SearchHistoryRepository>(
    () => SearchHistoryRepositoryImpl(
      remoteDataSource: sl<RemoteSearchHistoryDataSource>(),
    ),
  );

  // Register the repository
  sl.registerFactory(() => ThemeCubit());
  // Use cases
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSingleHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAllHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetAccountUseCase(sl<AccountRepository>()));
  sl.registerLazySingleton(() => UpdateAccountUseCase(sl<AccountRepository>()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl<AccountRepository>()));
  sl.registerLazySingleton(() => GetFirstAidGuides(sl<FirstAidRepository>()));
  sl.registerLazySingleton(() => GetAllHealthcareCenters(sl()));
  sl.registerLazySingleton(() => GetAllSpecialties(sl()));
  sl.registerLazySingleton(() => FilterHealthcareCenter());
  sl.registerLazySingleton(() => SortHealthcareCenter());
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
    () => HealthcareBloc(
      getAllHealthcareCenters: sl<GetAllHealthcareCenters>(),
      getAllSpecialties: sl<GetAllSpecialties>(),
      filterHealthcareCenters: sl<FilterHealthcareCenter>(),
      sortHealthcareCenters: sl<SortHealthcareCenter>(),
      locationService: sl<LocationDataSource>(),
    ),
  );
  sl.registerFactory(
    () => FirstAidBloc(getFirstAidGuides: sl<GetFirstAidGuides>()),
  );
  sl.registerFactory(
    () => AccountBloc(
      getAccountUseCase: sl<GetAccountUseCase>(),
      updateAccountUseCase: sl<UpdateAccountUseCase>(),
      deleteAccountUseCase: sl<DeleteAccountUseCase>(),
    ),
  );
  sl.registerFactory(
    () => SearchHistoryBloc(
      getHistory: sl<GetHistoryUseCase>(),
      deleteAllHistory: sl<DeleteAllHistoryUseCase>(),
      deleteHistory: sl<DeleteSingleHistoryUseCase>(),
    ),
  );
}
