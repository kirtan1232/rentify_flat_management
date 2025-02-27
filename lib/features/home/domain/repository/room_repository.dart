import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';


abstract class RoomRepository {
  Future<Either<Failure, List<RoomEntity>>> getAllRooms();
}