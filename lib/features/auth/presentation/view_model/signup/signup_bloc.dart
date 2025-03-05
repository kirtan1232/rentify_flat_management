import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart'; // Add for getIt
import 'package:rentify_flat_management/core/common/snackbar/my_snackbar.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/signup_usecase.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/uploadImage_usecase.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart'; // Add for LoginScreenView
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart'; // Add for LoginBloc

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase _signupUseCase;
  final UploadImageUsecase _uploadImageUsecase;

  SignupBloc({
    required SignupUseCase signupUseCase,
    required UploadImageUsecase uploadImageUsecase,
  })  : _signupUseCase = signupUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        super(SignupState.initial()) {
    on<SignupUser>(_onSignupEvent);
    on<LoadImage>(_onLoadImage);
  }

  void _onSignupEvent(
    SignupUser event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _signupUseCase.call(SignupUserParams(
      name: event.name,
      email: event.email,
      password: event.password,
      image: state.imageName,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        final message = failure.message.contains("User already exists")
            ? "Email already exists"
            : "Signup failed: ${failure.message}";
        showMySnackBar(
          context: event.context,
          message: message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
          color: Colors.green,
        );
        // Navigate to LoginScreenView after success
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<LoginBloc>(
              create: (_) => getIt<LoginBloc>(),
              child: LoginScreenView(),
            ),
          ),
        );
      },
    );
  }

  void _onLoadImage(
    LoadImage event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(
        file: event.file,
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r));
      },
    );
  }
}
