import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/data/data_source/remote_data_source/room_remote_data_source.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';


class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RoomEntity>>> getAllRooms() async {
    try {
      final roomModels = await remoteDataSource.getAllRooms();
      final roomEntities = roomModels.map((model) => model.toEntity()).toList();
      return Right(roomEntities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}