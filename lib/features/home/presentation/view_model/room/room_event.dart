part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomsEvent extends RoomEvent {
  final BuildContext context;
  const FetchRoomsEvent(this.context);
}

class AddToWishlistEvent extends RoomEvent {
  final String roomId;
  final BuildContext context;
  const AddToWishlistEvent(this.roomId, this.context);
}

class RemoveFromWishlistEvent extends RoomEvent {
  final String roomId;
  final BuildContext context;
  const RemoveFromWishlistEvent(this.roomId, this.context);
}

class FetchWishlistEvent extends RoomEvent {
  final BuildContext context;
  const FetchWishlistEvent(this.context);
}