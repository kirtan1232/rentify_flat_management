import 'package:dartz/dartz.dart';
import 'package:rentify_flat_management/app/usecase/usecase.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/home/domain/repository/room_repository.dart';


class AddToWishlistParams {
  final String roomId;
  const AddToWishlistParams(this.roomId);
}

class AddToWishlistUseCase implements UsecaseWithParams<void, AddToWishlistParams> {
  final RoomRepository repository;

  AddToWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToWishlistParams params) async {
    return await repository.addToWishlist(params.roomId);
  }
}