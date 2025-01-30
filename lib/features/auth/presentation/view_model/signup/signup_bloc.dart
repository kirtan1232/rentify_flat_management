import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupButtonPressed) {
      yield SignupLoading();

      // Simulate network call or business logic here
      await Future.delayed(const Duration(seconds: 2));

      if (event.password == event.confirmPassword) {
        // Simulating successful signup
        yield SignupSuccess();
      } else {
        yield const SignupFailure("Passwords do not match.");
      }
    }
  }
}
