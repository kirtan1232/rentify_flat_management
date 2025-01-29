// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:rentify_flat_management/core/error/failure.dart';
// import 'package:rentify_flat_management/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
// import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';
// import 'package:rentify_flat_management/features/auth/domain/repository/auth_repository.dart';

// class AuthRemoteRepository implements IAuthRepository {
//   final AuthRemoteDataSource _authRemoteDataSource;

//   AuthRemoteRepository(this._authRemoteDataSource);

//   @override
//   Future<Either<Failure, AuthEntity>> getCurrentUser() {
//     // TODO: implement getCurrentUser
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either<Failure, String>> loginUser(
//       String email, String password) async {
//     try {
//       // Call the remote data source to handle the login API call
//       final token = await _authRemoteDataSource.loginUser(email, password);
//       return Right(token);
//     } catch (e) {
//       // If an error occurs, wrap it in a Failure and return as Left
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signupUser(AuthEntity user) async {
//     try {
//       await _authRemoteDataSource.signupUser(user);
//       return const Right(null);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, String>> uploadProfilePicture(File file) async {
//     try {
//       final imageName = await _authRemoteDataSource.uploadProfilePicture(file);
//       return Right(imageName);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }
// }
