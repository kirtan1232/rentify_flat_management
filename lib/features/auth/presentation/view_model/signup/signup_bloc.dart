import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/core/common/snackbar/my_snackbar.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/signup_usecase.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/uploadImage_usecase.dart';

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
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      image: state.imageName,
    ));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
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
