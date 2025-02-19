import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/signup_usecase.dart';

import 'repository.mock.dart';

void main() {
  late MockAuthRepository repository;
  late SignupUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignupUseCase(repository);
    registerFallbackValue(const AuthEntity(
      name: 'Kirtan Shrestha',
      email: 'kirtan.doe@example.com',
      password: 'password123',
      image: 'profile.jpg',
    ));
  });

  const registerParams = SignupUserParams(
    name: 'Kirtan Shrestha',
    email: 'kirtan.doe@example.com',
    password: 'password123',
    image: 'profile.jpg',
  );

  group('RegisterUseCase Tests', () {
    test('should return Failure when email is already in use', () async {
      // Arrange
      when(() => repository.signupUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Email is already registered")));

      // Act
      final result = await useCase(registerParams);

      // Assert
      expect(result,
          const Left(ApiFailure(message: "Email is already registered")));
      verify(() => repository.signupUser(any())).called(1);
    });

    test('should return Failure when required fields are missing', () async {
      // Arrange
      const invalidParams = SignupUserParams(
        name: '',
        email: 'kirtan.doe@example.com',
        password: 'password123',
        image: 'profile.jpg',
      );

      when(() => repository.signupUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "One or more credentials are empty")));

      // Act
      final result = await useCase(invalidParams);

      // Assert
      expect(result,
          const Left(ApiFailure(message: "One or more credentials are empty")));
      verify(() => repository.signupUser(any())).called(1);
    });

    test('should return Failure when there is Api Failure', () async {
      // Arrange
      when(() => repository.signupUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Unexpected server error")));

      // Act
      final result = await useCase(registerParams);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Unexpected server error")));
      verify(() => repository.signupUser(any())).called(1);
    });

    test('should successfully register a user and return Right(null)',
        () async {
      // Arrange
      when(() => repository.signupUser(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(registerParams);

      // Assert
      expect(result, const Right(null));
      verify(() => repository.signupUser(any())).called(1);
      verifyNoMoreInteractions(repository);
    });

    // test('should return Failure when passwords do not match', () async {
    //   // Arrange
    //   const mismatchedParams = SignupUserParams(
    //     fullName: 'Kirtan Shrestha',
    //     email: 'kirtan.doe@example.com',
    //     password: 'password123',
    //     image: 'profile.jpg',
    //   );

    //   when(() => repository.signupUser(any())).thenAnswer((_) async =>
    //       const Left(ApiFailure(message: "Passwords do not match")));

    //   // Act
    //   final result = await useCase(mismatchedParams);

    //   // Assert
    //   expect(result, const Left(ApiFailure(message: "Passwords do not match")));
    //   verify(() => repository.signupUser(any())).called(1);
    // });
  });
}
