import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/repository/auth_repository.dart';

class DeleteUserParams extends Equatable {
  final String password;

  const DeleteUserParams({required this.password});

  @override
  List<Object> get props => [password];
}

class DeleteUserUseCase implements UsecaseWithParams<void, DeleteUserParams> {
  final IAuthRepository repository;

  DeleteUserUseCase(this.repository); // Only one argument: repository

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) {
    return repository.deleteUser(params.password);
  }
}