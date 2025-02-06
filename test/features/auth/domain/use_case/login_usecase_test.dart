import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/login_usecase.dart';

import 'auth_repo.mock.dart';
import 'token.mock.dart';

void main() {
  late AuthRepoMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase usecase;

  setUp(() {
    repository = AuthRepoMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUseCase(repository, tokenSharedPrefs);

    // Mock `getToken` to return a valid token
    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    // Mock `saveToken` to return a successful response
    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));
  });

  test(
      'should call the [AuthRepo.login] with correct email and password (kirtan, 1234)',
      () async {
    when(() => repository.loginUser(any(), any())).thenAnswer(
      (invocation) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'kirtan' && password == '1234') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
              const Left(ApiFailure(message: 'Invalid email or password')));
        }
      },
    );

    when(() => tokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getToken())
        .thenAnswer((_) async => const Right('mocked_token'));

    final result = await usecase(const LoginParams(
      email: 'kirtan',
      password: '1234',
    ));

    expect(result, const Right('token'));

    verify(() => repository.loginUser(any(), any())).called(1);
    verify(() => tokenSharedPrefs.saveToken(any())).called(1);
    verify(() => tokenSharedPrefs.getToken())
        .called(1); // Explicitly verify this call

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
