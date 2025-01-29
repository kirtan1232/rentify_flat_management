import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;

  const SignupButtonPressed({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, email, password, confirmPassword];
}
