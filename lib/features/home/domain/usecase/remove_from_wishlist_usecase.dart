import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';


class RemoveFromWishlistParams {
  final String roomId;
  const RemoveFromWishlistParams(this.roomId);
}

class RemoveFromWishlistUseCase implements UsecaseWithParams<void, RemoveFromWishlistParams> {
  final RoomRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) async {
    return await repository.removeFromWishlist(params.roomId);
  }
}