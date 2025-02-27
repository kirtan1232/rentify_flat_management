import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';


abstract class RoomRepository {
  Future<Either<Failure, List<RoomEntity>>> getAllRooms();
  Future<Either<Failure, void>> addToWishlist(String roomId);
  Future<Either<Failure, List<RoomEntity>>> getWishlist();
  Future<Either<Failure, void>> removeFromWishlist(String roomId); // Added
}