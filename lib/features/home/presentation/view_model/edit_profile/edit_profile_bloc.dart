import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/data/repository/auth_remote_repository.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/update_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateUserUseCase _updateUserUseCase;

  EditProfileBloc({required UpdateUserUseCase updateUserUseCase})
      : _updateUserUseCase = updateUserUseCase,
        super(EditProfileState.initial()) {
    on<LoadCurrentUserEvent>(_onLoadCurrentUser);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadCurrentUser(
      LoadCurrentUserEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getIt<AuthRemoteRepository>().getCurrentUser();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: "Failed to load user: ${failure.message}",
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        currentUser: user,
      )),
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _updateUserUseCase(UpdateUserParams(
        name: event.name.isNotEmpty ? event.name : null,
        password: event.password.isNotEmpty ? event.password : null,
        image: event.image, // Pass the image file to the use case
      ));

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: "Update failed: ${failure.message}",
        )),
        (updatedUser) => emit(state.copyWith(
          isLoading: false,
          currentUser: updatedUser,
          isUpdateSuccess: true,
        )),
      );

      if (state.isUpdateSuccess) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(event.context);
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Unexpected error: $e"));
    }
  }
}