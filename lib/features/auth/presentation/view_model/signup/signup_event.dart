part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}
class LoadImage extends SignupEvent {
  final File file;

  const LoadImage({
    required this.file,
  });
}

class SignupUser extends SignupEvent {
  final BuildContext context;
  final String name;

  // final String phone;
  final String email;
  final String password;
  final String? image;


  const SignupUser({
    required this.context,
    required this.name,
    // required this.phone,
    required this.email,
    required this.password,
     this.image,
  });
}
