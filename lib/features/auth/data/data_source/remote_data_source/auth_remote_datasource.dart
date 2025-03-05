import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/features/auth/data/data_source/auth_data_source.dart';
import 'package:rentify_flat_management/features/auth/data/model/auth_api_model.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<AuthEntity> getCurrentUser() async {
    try {
      final token = await _getToken();
      print("Fetching current user with token: $token");
      final response = await _dio.get(
        ApiEndpoints.getMe,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("getMe response: ${response.statusCode} - ${response.data}");
      if (response.statusCode == 200) {
        return AuthApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("DioException in getCurrentUser: ${e.type}, Response: ${e.response?.statusCode} - ${e.response?.data}, Message: ${e.message}, Error: ${e.error}");
      throw Exception("Failed to fetch user: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      print("General error in getCurrentUser: $e");
      throw Exception("Error fetching user: $e");
    }
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );
      print("Login response: ${response.statusCode} - ${response.data}");
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception("Login failed: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Login failed: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }

  @override
  Future<void> signupUser(AuthEntity user) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.signup,
        data: {
          "image": user.image,
          "name": user.name,
          "email": user.email,
          "password": user.password,
        },
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception("Signup failed: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Signup failed: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      throw Exception("Signup error: $e");
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final token = await _getToken();
      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception("Upload failed: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Upload failed: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      throw Exception("Upload error: $e");
    }
  }

  Future<AuthEntity> updateUser(String? name, String? password, String? imageName) async {
    try {
      final token = await _getToken();
      final data = {
        if (name != null) "name": name,
        if (password != null) "password": password,
        if (imageName != null) "image": imageName,
      };
      print("Sending updateUser request with token: $token, body: $data");
      final response = await _dio.put(
        ApiEndpoints.updateUser,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("updateUser response: ${response.statusCode} - ${response.data}");
      if (response.statusCode == 200) {
        return AuthApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception("Update failed: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("DioException in updateUser: ${e.type}, Response: ${e.response?.statusCode} - ${e.response?.data}, Message: ${e.message}, Error: ${e.error}");
      throw Exception("Update failed: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      print("General error in updateUser: $e");
      throw Exception("Update error: $e");
    }
  }

  Future<void> deleteUser(String password) async { // New method
    try {
      final token = await _getToken();
      print("Sending deleteUser request with token: $token, password: $password");
      final response = await _dio.post(
        "v1/deleteUser", // Match your backend route
        data: {"password": password},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("deleteUser response: ${response.statusCode} - ${response.data}");
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Delete failed: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("DioException in deleteUser: ${e.type}, Response: ${e.response?.statusCode} - ${e.response?.data}, Message: ${e.message}, Error: ${e.error}");
      throw Exception("Delete failed: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      print("General error in deleteUser: $e");
      throw Exception("Delete error: $e");
    }
  }

  Future<String> _getToken() async {
    final tokenSharedPrefs = getIt<TokenSharedPrefs>();
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => throw Exception("Failed to get token: ${failure.message}"),
      (token) {
        print("Token retrieved: $token");
        return token;
      },
    );
  }
}