import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> signupUser(AuthEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, String>> uploadProfilePicture(File file);
  Future<Either<Failure, AuthEntity>> updateUser(String? name, String? password, File? image);
  Future<Either<Failure, void>> deleteUser(String password); // New method
}