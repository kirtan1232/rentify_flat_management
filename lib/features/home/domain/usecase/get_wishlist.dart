import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';


class GetWishlistUseCase implements UsecaseWithoutParams<List<RoomEntity>> {
  final RoomRepository repository;

  GetWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, List<RoomEntity>>> call() async {
    return await repository.getWishlist();
  }
}