import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';
import 'package:rentify_flat_management/features/auth/domain/repository/auth_repository.dart';

class SignupUserParams extends Equatable {
  final String name;

  
  final String email;
  final String password;
  final String? image;

  const SignupUserParams({
    required this.name,
  
    required this.email,
    required this.password,
     this.image,
  });

  //intial constructor
  const SignupUserParams.initial({
    required this.name,

    required this.email,
    required this.password,
    this.image,
  });

  @override
  List<Object?> get props => [name,  email, password,image];
}

class SignupUseCase implements UsecaseWithParams<void, SignupUserParams> {
  final IAuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignupUserParams params) {
    final authEntity = AuthEntity(
      name: params.name,
      email: params.email,
      password: params.password,
      image: params.image,
    );
    return repository.signupUser(authEntity);
  }
}
