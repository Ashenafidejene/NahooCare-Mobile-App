import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nahoocare/features/accounts/presentation/pages/account_page.dart';
import 'package:nahoocare/features/firstaid/presentation/pages/first_aid_list_page.dart';

import 'package:nahoocare/features/healthcare_center/presentation/bloc/healthcare_center_bloc.dart';
import 'package:nahoocare/features/history/presentation/blocs/search_history_bloc.dart';
import 'package:nahoocare/features/landing/presentation/pages/landing.dart';

import 'core/theme/theme_cubit.dart';
import 'features/accounts/presentation/blocs/account_bloc.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/register_blocs/registration_flow_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';

import 'features/firstaid/presentation/blocs/first_aid_bloc.dart';
import 'features/history/presentation/pages/search_history_page.dart';
import 'features/hospitalSearch/presentation/blocs/healthcare_search_bloc.dart';
import 'features/hospitalSearch/presentation/pages/healthcare_search_page.dart';
import 'features/profile/presentation/bloc/health_profile_bloc.dart';
import 'features/profile/presentation/widgets/health_profile_view.dart';
import 'features/symptomSearch/presentation/blocs/symptom_search_bloc.dart';
import 'features/welcome/home.dart';
import 'injection_container.dart' as di;

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  // Initialize dependency injection
  await di.init();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('am')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => di.sl<AuthBloc>()..add(CheckAuthenticationEvent()),
        ),
        BlocProvider(create: (context) => di.sl<SymptomSearchBloc>()),
        BlocProvider(
          create: (context) => di.sl<HealthProfileBloc>(),
          child: const HealthProfileView(),
        ),
        BlocProvider(create: (context) => di.sl<HealthcareCenterBloc>()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (context) => di.sl<HealthcareBloc>(),
          child: const HealthcareCentersPage(),
        ),
        BlocProvider(
          create: (context) => di.sl<FirstAidBloc>(),
          child: const FirstAidListPage(),
        ),
        BlocProvider(
          create: (context) {
            final bloc = di.sl<AccountBloc>();
            // Add slight delay to ensure BLoC is fully constructed
            Future.delayed(Duration.zero, () => bloc.add(LoadAccountEvent()));
            return bloc;
          },
          child: const AccountPage(),
        ),
        BlocProvider(
          create: (context) => di.sl<SearchHistoryBloc>(),
          child: const SearchHistoryPage(),
        ),
        BlocProvider(
          create: (context) => di.sl<RegistrationFlowBloc>(),
          child: RegisterPage(),
        ),
      ],
      child: MaterialApp(
        title: 'NahooCare',
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
            secondary: Colors.blueAccent,
          ),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        initialRoute: '/welcome',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/landing':
                  return LandingPage();
                case '/welcome':
                  return const Home();
                case '/':
                  return const AuthWrapper();
                case '/login':
                  return const LoginPage();
                case '/register':
                  return const RegisterPage();
                case '/reset-password':
                  return const ResetPasswordPage();
                case '/test':
                  return FirstAidListPage();
                default:
                  return const Scaffold(
                    body: Center(child: Text('Page not found')),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const Scaffold(body: Center(child: Text('Authenticated!')));
        } else if (state is NotAuthenticated) {
          return const LoginPage();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
