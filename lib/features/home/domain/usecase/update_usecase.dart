import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';
import 'package:rentify_flat_management/features/auth/domain/repository/auth_repository.dart';

class UpdateUserParams extends Equatable {
  final String? name;
  final String? password;
  final File? image;

  const UpdateUserParams({
    this.name,
    this.password,
    this.image,
  });

  @override
  List<Object?> get props => [name, password, image];
}

class UpdateUserUseCase implements UsecaseWithParams<AuthEntity, UpdateUserParams> {
  final IAuthRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateUserParams params) {
    return repository.updateUser(params.name, params.password, params.image);
  }
}