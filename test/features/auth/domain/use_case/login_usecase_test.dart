import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/login_usecase.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockTokenSharedPrefs tokenStorage;
  late LoginUseCase loginUseCase;

  setUp(() {
    authRepository = MockAuthRepository();
    tokenStorage = MockTokenSharedPrefs();
    loginUseCase = LoginUseCase(authRepository, tokenStorage);
  });

  const loginData = LoginParams(
    email: "kirtan",
    password: "kirtan123",
  );

  const mockToken = "test_jwt_token";

  group('Login_Use_Case Tests', () {
    test('returns Failure when credentials are incorrect', () async {
      // Arrange
      when(() => authRepository.loginUser(any(), any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid credentials")));

      // Act
      final result = await loginUseCase(loginData);

      // Assert
      expect(result, const Left(ApiFailure(message: "Invalid credentials")));
      verify(() => authRepository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenStorage.saveToken(any()));
    });

    test('returns Failure when email is empty', () async {
      // Arrange
      const emptyEmailData = LoginParams(email: "", password: "kirtan123");
      when(() => authRepository.loginUser(any(), any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "email cannot be empty")));

      // Act
      final result = await loginUseCase(emptyEmailData);

      // Assert
      expect(result, const Left(ApiFailure(message: "email cannot be empty")));
      verify(() => authRepository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenStorage.saveToken(any()));
    });

    test('returns Failure when password is empty', () async {
      // Arrange
      const emptyPasswordData = LoginParams(email: "kirtan", password: "");
      when(() => authRepository.loginUser(any(), any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Password cannot be empty")));

      // Act
      final result = await loginUseCase(emptyPasswordData);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Password cannot be empty")));
      verify(() => authRepository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenStorage.saveToken(any()));
    });

    test('returns Failure on server error', () async {
      // Arrange
      when(() => authRepository.loginUser(any(), any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Server error")));

      // Act
      final result = await loginUseCase(loginData);

      // Assert
      expect(result, const Left(ApiFailure(message: "Server error")));
      verify(() => authRepository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenStorage.saveToken(any()));
    });

    test('logs in successfully and stores token', () async {
      // Arrange
      when(() => authRepository.loginUser(any(), any()))
          .thenAnswer((_) async => const Right(mockToken));
      when(() => tokenStorage.saveToken(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => tokenStorage.getToken())
          .thenAnswer((_) async => const Right(mockToken));

      // Act
      final result = await loginUseCase(loginData);

      // Assert
      expect(result, const Right(mockToken));
      verify(() =>
              authRepository.loginUser(loginData.email, loginData.password))
          .called(1);
      verify(() => tokenStorage.saveToken(mockToken)).called(1);
      verify(() => tokenStorage.getToken()).called(1);
    });
  });
}
