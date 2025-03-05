import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/data/repository/auth_remote_repository.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/update_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_state.dart';
import 'package:rentify_flat_management/app/di/di.dart';

// Mock dependencies
class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}
class MockAuthRemoteRepository extends Mock implements AuthRemoteRepository {}
class MockUser extends Mock {} // Minimal mock for User entity


void main() {
  late EditProfileBloc editProfileBloc;
  late MockUpdateUserUseCase mockUpdateUserUseCase;
  late MockAuthRemoteRepository mockAuthRemoteRepository;

  setUp(() {
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    mockAuthRemoteRepository = MockAuthRemoteRepository();

    // Register the mock AuthRemoteRepository with getIt
    getIt.registerSingleton<AuthRemoteRepository>(mockAuthRemoteRepository);

    editProfileBloc = EditProfileBloc(
      updateUserUseCase: mockUpdateUserUseCase,
    );

    // Register fallback values for mocktail
    registerFallbackValue(const UpdateUserParams(name: 'test', password: 'pass', image: null));
    registerFallbackValue(BuildContextMock());
  });

  tearDown(() {
    editProfileBloc.close();
    getIt.reset(); // Reset getIt after each test
  });

  group('EditProfileBloc', () {
    final context = BuildContextMock();
    final mockUser = MockUser();
    final updatedUser = MockUser();

   
    blocTest<EditProfileBloc, EditProfileState>(
      'emits loading and error states when LoadCurrentUserEvent fails',
      build: () {
        when(() => mockAuthRemoteRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(ApiFailure(message: 'Load failed')));
        return editProfileBloc;
      },
      act: (bloc) => bloc.add(const LoadCurrentUserEvent()),
      expect: () => [
        EditProfileState.initial().copyWith(isLoading: true),
        EditProfileState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Failed to load user: Load failed',
        ),
      ],
    );


    blocTest<EditProfileBloc, EditProfileState>(
      'emits loading and error states when UpdateProfileEvent fails',
      build: () {
        when(() => mockUpdateUserUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Update failed')),
        );
        return editProfileBloc;
      },
      act: (bloc) => bloc.add(
        UpdateProfileEvent(
          name: 'New Name',
          password: 'NewPass',
          image: null,
          context: context,
        ),
      ),
      expect: () => [
        EditProfileState.initial().copyWith(isLoading: true),
        EditProfileState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Update failed: Update failed',
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits loading and error states when UpdateProfileEvent throws an exception',
      build: () {
        when(() => mockUpdateUserUseCase(any()))
            .thenThrow(Exception('Network error'));
        return editProfileBloc;
      },
      act: (bloc) => bloc.add(
        UpdateProfileEvent(
          name: 'New Name',
          password: 'NewPass',
          image: null,
          context: context,
        ),
      ),
      expect: () => [
        EditProfileState.initial().copyWith(isLoading: true),
        EditProfileState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Unexpected error: Exception: Network error',
        ),
      ],
    );
  });
}

// Mock BuildContext for testing
class BuildContextMock extends Mock implements BuildContext {}