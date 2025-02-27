// lib/features/room/data/data_sources/room_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/features/home/data/model/room_api_model.dart';


abstract class RoomRemoteDataSource {
  Future<List<RoomApiModel>> getAllRooms();
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Dio _dio;

  RoomRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RoomApiModel>> getAllRooms() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllRooms); // Updated here
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => RoomApiModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // No rooms found
      } else {
        throw Exception('Failed to fetch rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }
}