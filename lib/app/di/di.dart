import 'package:get_it/get_it.dart';
import 'package:rentify_flat_management/core/network/hive_service.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:rentify_flat_management/features/on_boarding_screen/presentation/view_model/on_boarding_screen_cubit.dart';
import 'package:rentify_flat_management/features/splash_screen/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Hive Service
  await _initHiveService();

  // Initialize Splash Screen Dependencies
  await _initSplashDependencies();

  // Initialize Onboarding Screen Dependencies
  await _initOnboardingDependencies();

  // Initialize Login Screen Dependencies
  await _initLoginDependencies();

  // Initialize Signup Screen Dependencies
  await _initSignupDependencies(); // Add this line
}

Future<void> _initHiveService() async {
  // Register HiveService as a singleton
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSplashDependencies() async {
  // Register SplashCubit as a factory
  getIt.registerFactory<SplashCubit>(() => SplashCubit());
}

Future<void> _initOnboardingDependencies() async {
  // Register OnboardingCubit as a factory
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}

// Register SignupBloc here
Future<void> _initSignupDependencies() async {
  // Register SignupBloc as a factory
  getIt.registerFactory<SignupBloc>(() => SignupBloc());
}

Future<void> _initLoginDependencies() async {
  // Register LoginBloc as a factory
  getIt.registerFactory<LoginBloc>(() => LoginBloc());
}
