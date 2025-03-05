import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';

class OnBoardingScreenCubit extends Cubit<void> {
  OnBoardingScreenCubit(this._loginBloc) : super(null);
  final LoginBloc _loginBloc;

  // Navigation to Login Screen
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _loginBloc,
            child: LoginScreenView(),
          )),
    );
  }
}