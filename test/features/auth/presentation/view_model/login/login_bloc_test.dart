import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/login_usecase.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';

// Generate mocks
@GenerateMocks([LoginUseCase, SignupBloc, HomeCubit, BuildContext])
import 'login_bloc_test.mocks.dart';

void main() {
  blocTest<LoginBloc, LoginState>(
    'has correct initial state when created',
    build: () => LoginBloc(
      signupBloc: MockSignupBloc(),
      homeCubit: MockHomeCubit(),
      loginUseCase: MockLoginUseCase(),
    ),
    verify: (bloc) {
      expect(bloc.state, const LoginState(isLoading: false, isSuccess: false));
    },
  );

}