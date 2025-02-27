import 'package:dio/dio.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/features/home/data/model/room_api_model.dart';


abstract class RoomRemoteDataSource {
  Future<List<RoomApiModel>> getAllRooms();
  Future<void> addToWishlist(String roomId);
  Future<List<RoomApiModel>> getWishlist();
  Future<void> removeFromWishlist(String roomId); // Added
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  RoomRemoteDataSourceImpl(this._dio, this._tokenSharedPrefs);

  Future<Map<String, String>> _getHeaders() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.fold((_) => '', (token) => token);
    print('Token sent: $token'); // Debug
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<RoomApiModel>> getAllRooms() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllRooms);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => RoomApiModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  @override
  Future<void> addToWishlist(String roomId) async {
    try {
      final headers = await _getHeaders();
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}wishlist/add/$roomId',
        options: Options(headers: headers),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add to wishlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to wishlist: $e');
    }
  }

  @override
  Future<List<RoomApiModel>> getWishlist() async {
    try {
      final headers = await _getHeaders();
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}wishlist',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => RoomApiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch wishlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String roomId) async {
    try {
      final headers = await _getHeaders();
      final response = await _dio.delete(
        '${ApiEndpoints.baseUrl}wishlist/remove/$roomId',
        options: Options(headers: headers),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove from wishlist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing from wishlist: $e');
    }
  }
}