import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/data/data_source/local_data_source/room_local_data_source.dart';
import 'package:rentify_flat_management/features/home/data/data_source/remote_data_source/room_remote_data_source.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;
  final RoomLocalDataSource localDataSource;

  RoomRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<RoomEntity>>> getAllRooms() async {
    try {
      // Attempt to fetch from remote
      final roomModels = await remoteDataSource.getAllRooms();
      // Save to local storage
      await localDataSource.saveRooms(roomModels);
      return Right(roomModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      // If remote fetch fails, fall back to local data
      final localRooms = await localDataSource.getAllRooms();
      if (localRooms.isNotEmpty) {
        return Right(localRooms.map((model) => model.toEntity()).toList());
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(String roomId) async {
    try {
      await remoteDataSource.addToWishlist(roomId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getWishlist() async {
    try {
      final roomModels = await remoteDataSource.getWishlist();
      return Right(
          roomModels.map((model) => model.toEntity(isWishlisted: true)).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String roomId) async {
    try {
      await remoteDataSource.removeFromWishlist(roomId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}