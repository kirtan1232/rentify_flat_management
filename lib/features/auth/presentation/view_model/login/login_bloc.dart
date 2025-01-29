import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_event.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    // Simulate a delay for login process
    await Future.delayed(const Duration(seconds: 2));

    // Replace the below logic with actual authentication logic
    if (event.email == "test@example.com" && event.password == "password") {
      emit(LoginSuccess());
    } else {
      emit(const LoginFailure("Invalid email or password."));
    }
  }
}