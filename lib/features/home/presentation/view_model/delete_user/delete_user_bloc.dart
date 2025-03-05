import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart'; // Add this import
import 'package:rentify_flat_management/features/home/domain/usecase/delete_user_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteUserUseCase _deleteUserUseCase;

  DeleteAccountBloc({required DeleteUserUseCase deleteUserUseCase})
      : _deleteUserUseCase = deleteUserUseCase,
        super(DeleteAccountState.initial()) {
    on<DeleteAccountConfirmEvent>(_onDeleteAccountConfirm);
  }

  Future<void> _onDeleteAccountConfirm(
      DeleteAccountConfirmEvent event, Emitter<DeleteAccountState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result =
          await _deleteUserUseCase(DeleteUserParams(password: event.password));
      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: "Failed to delete account: ${failure.message}",
        )),
        (_) => emit(state.copyWith(
          isLoading: false,
          isDeleted: true,
        )),
      );

      if (state.isDeleted) {
        // Clear token and navigate to LoginScreenView
        final tokenSharedPrefs = getIt<TokenSharedPrefs>();
        await tokenSharedPrefs.saveToken('');
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")),
        );
        // Replace named route with direct navigation
        Navigator.pushAndRemoveUntil(
          event.context,
          MaterialPageRoute(builder: (_) => LoginScreenView()),
          (route) => false,
        );
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Unexpected error: $e"));
    }
  }
}
