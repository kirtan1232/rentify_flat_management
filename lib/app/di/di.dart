import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/core/app_theme/theme_cubit.dart';
import 'package:rentify_flat_management/core/network/api_service.dart';
import 'package:rentify_flat_management/core/network/hive_service.dart';
import 'package:rentify_flat_management/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:rentify_flat_management/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:rentify_flat_management/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:rentify_flat_management/features/auth/data/repository/auth_remote_repository.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/login_usecase.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/signup_usecase.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/uploadImage_usecase.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:rentify_flat_management/features/home/data/data_source/remote_data_source/room_remote_data_source.dart';
import 'package:rentify_flat_management/features/home/data/repository/room_repository_impl.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/add_to_wishlist_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/delete_user_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_all_room_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_wishlist.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/remove_from_wishlist_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/update_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';
import 'package:rentify_flat_management/features/on_boarding_screen/presentation/view_model/on_boarding_screen_cubit.dart';
import 'package:rentify_flat_management/features/splash_screen/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSplashDependencies();
  await _initOnboardingDependencies();
  await _initLoginDependencies();
  await _initSignupDependencies();
  await _initHomeDependencies();
  await _initSharedPreferences();
  await _initRoomDependencies();
  await _initThemeDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initApiService() {
  getIt.registerLazySingleton<Dio>(() => ApiService(Dio()).dio);
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initOnboardingDependencies() async {
  getIt.registerFactory<OnBoardingScreenCubit>(
      () => OnBoardingScreenCubit(getIt<LoginBloc>()));
}

Future<void> _initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

Future<void> _initSplashDependencies() async {
  getIt.registerFactory<SplashCubit>(
      () => SplashCubit(getIt<OnBoardingScreenCubit>()));
}

_initSignupDependencies() async {
  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt<HiveService>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton(
      () => AuthLocalRepository(getIt<AuthLocalDataSource>()));
  getIt.registerLazySingleton(
      () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<SignupUseCase>(
      () => SignupUseCase(getIt<AuthRemoteRepository>()));
  getIt.registerLazySingleton<UploadImageUsecase>(
      () => UploadImageUsecase(getIt<AuthRemoteRepository>()));
  getIt.registerFactory<SignupBloc>(
      () => SignupBloc(signupUseCase: getIt(), uploadImageUsecase: getIt()));
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
      () => TokenSharedPrefs(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<LoginUseCase>(() =>
      LoginUseCase(getIt<AuthRemoteRepository>(), getIt<TokenSharedPrefs>()));
  getIt.registerLazySingleton<UpdateUserUseCase>(
      () => UpdateUserUseCase(getIt<AuthRemoteRepository>()));
  getIt.registerLazySingleton<DeleteUserUseCase>(
      () => DeleteUserUseCase(getIt<AuthRemoteRepository>())); // Corrected: one argument
  getIt.registerFactory<LoginBloc>(() => LoginBloc(
      signupBloc: getIt<SignupBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>()));
  getIt.registerFactory<EditProfileBloc>(
      () => EditProfileBloc(updateUserUseCase: getIt<UpdateUserUseCase>()));
  getIt.registerFactory<DeleteAccountBloc>(
      () => DeleteAccountBloc(deleteUserUseCase: getIt<DeleteUserUseCase>()));
}

Future<void> _initRoomDependencies() async {
  getIt.registerLazySingleton<RoomRemoteDataSource>(
      () => RoomRemoteDataSourceImpl(getIt<Dio>(), getIt<TokenSharedPrefs>()));
  getIt.registerLazySingleton<RoomRepository>(
      () => RoomRepositoryImpl(getIt<RoomRemoteDataSource>()));
  getIt.registerLazySingleton<GetAllRoomsUseCase>(
      () => GetAllRoomsUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton<AddToWishlistUseCase>(
      () => AddToWishlistUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton<GetWishlistUseCase>(
      () => GetWishlistUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton<RemoveFromWishlistUseCase>(
      () => RemoveFromWishlistUseCase(getIt<RoomRepository>()));
  getIt.registerFactory<RoomBloc>(() => RoomBloc(
        getIt<GetAllRoomsUseCase>(),
        getIt<AddToWishlistUseCase>(),
        getIt<GetWishlistUseCase>(),
        getIt<RemoveFromWishlistUseCase>(),
      ));
}

Future<void> _initThemeDependencies() async {
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}