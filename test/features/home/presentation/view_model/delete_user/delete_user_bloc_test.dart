import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/delete_user_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_state.dart';

// Mock dependencies
class MockDeleteUserUseCase extends Mock implements DeleteUserUseCase {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late DeleteAccountBloc deleteAccountBloc;
  late MockDeleteUserUseCase mockDeleteUserUseCase;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockDeleteUserUseCase = MockDeleteUserUseCase();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    // Register the mock TokenSharedPrefs with getIt
    getIt.registerSingleton<TokenSharedPrefs>(mockTokenSharedPrefs);

    deleteAccountBloc = DeleteAccountBloc(
      deleteUserUseCase: mockDeleteUserUseCase,
    );

    // Register fallback values for mocktail
    registerFallbackValue(const DeleteUserParams(password: 'testPassword'));
    registerFallbackValue(BuildContextMock());
  });

  tearDown(() {
    deleteAccountBloc.close();
    getIt.reset(); // Reset getIt after each test to avoid interference
  });

  group('DeleteAccountBloc', () {
    final context = BuildContextMock();

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits loading and error states when DeleteAccountConfirmEvent fails',
      build: () {
        when(() => mockDeleteUserUseCase(any())).thenAnswer(
          (_) async => const Left(
            ApiFailure(message: 'Invalid password'),
          ),
        );
        return deleteAccountBloc;
      },
      act: (bloc) => bloc.add(
        DeleteAccountConfirmEvent(
          password: 'testPassword',
          context: context,
        ),
      ),
      expect: () => [
        DeleteAccountState.initial().copyWith(isLoading: true),
        DeleteAccountState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete account: Invalid password',
        ),
      ],
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits loading and error states when an unexpected exception occurs',
      build: () {
        when(() => mockDeleteUserUseCase(any()))
            .thenThrow(Exception('Network error'));
        return deleteAccountBloc;
      },
      act: (bloc) => bloc.add(
        DeleteAccountConfirmEvent(
          password: 'testPassword',
          context: context,
        ),
      ),
      expect: () => [
        DeleteAccountState.initial().copyWith(isLoading: true),
        DeleteAccountState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Unexpected error: Exception: Network error',
        ),
      ],
    );
  });
}

// Mock BuildContext for testing
class BuildContextMock extends Mock implements BuildContext {}
