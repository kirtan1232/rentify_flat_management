// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:vitalflow/core/error/failure.dart';
// import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';
// import 'package:vitalflow/features/auth/domain/repository/auth_repoitory.dart';
// import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';

// // Mock the IAuthRepoitory
// class MockAuthRepository extends Mock implements IAuthRepoitory {}

// void main() {
//   late SignupUsecase useCase;
//   late MockAuthRepository mockRepository;

//   setUp(() {
//     mockRepository = MockAuthRepository();
//     useCase = SignupUsecase(mockRepository);
//   });

//   // Test case for successful signup
//   test('should call signupUser with correct AuthEntity and return void',
//       () async {
//     // Arrange
//     const params = SignupUserParams(
//       name: 'John Doe',
//       email: 'john.doe@example.com',
//       password: 'password123',
//       image: 'profile.jpg',
//     );

//     const authEntity = AuthEntity(
//       name: 'John Doe',
//       email: 'john.doe@example.com',
//       password: 'password123',
//       image: 'profile.jpg',
//     );

//     // Mock the repository to return Right(null) for successful signup
//     when(() => mockRepository.signupUser(authEntity))
//         .thenAnswer((_) async => const Right(null));

//     // Act
//     final result = await useCase(params);

//     // Assert
//     expect(result, const Right(null)); // Verify that the result is Right(null)
//     verify(() => mockRepository.signupUser(authEntity)).called(
//         1); // Verify that signupUser was called with the correct AuthEntity
//     verifyNoMoreInteractions(
//         mockRepository); // Ensure no other interactions with the repository
//   });

//   // Test case for signup failure
//   test('should return a Failure when signupUser fails', () async {
//     // Arrange
//     const params = SignupUserParams(
//       name: 'John Doe',
//       email: 'john.doe@example.com',
//       password: 'password123',
//       image: 'profile.jpg',
//     );

//     const authEntity = AuthEntity(
//       name: 'John Doe',
//       email: 'john.doe@example.com',
//       password: 'password123',
//       image: 'profile.jpg',
//     );

//     const failure = ApiFailure (message: 'Signup failed');

//     // Mock the repository to return Left(Failure) for failed signup
//     when(() => mockRepository.signupUser(authEntity))
//         .thenAnswer((_) async => const Left(failure));

//     // Act
//     final result = await useCase(params);

//     // Assert
//     expect(
//         result, const Left(failure)); // Verify that the result is Left(Failure)
//     verify(() => mockRepository.signupUser(authEntity)).called(
//         1); // Verify that signupUser was called with the correct AuthEntity
//     verifyNoMoreInteractions(
//         mockRepository); // Ensure no other interactions with the repository
//   });

//   tearDown(() {
//     reset(mockRepository); // Reset the mock after each test
//   });
// }