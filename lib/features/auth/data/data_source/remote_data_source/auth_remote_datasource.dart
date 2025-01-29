import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/features/auth/data/data_source/auth_data_source.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);
//  TODO: implement getCurrentUser
  @override
  Future<AuthEntity> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a token upon successful login
        String token = response.data['token'];
        return token;
      } else {
        throw Exception("Login failed: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception("Dio error: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      // Handle general errors
      throw Exception("Login error: $e");
    }
  }

  @override
  Future<void> signupUser(AuthEntity user) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "fullName": user.fullName,
          "email": user.email,
          "password": user.password,
          "image": user.image,
        },
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'profilePicture': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );
      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
