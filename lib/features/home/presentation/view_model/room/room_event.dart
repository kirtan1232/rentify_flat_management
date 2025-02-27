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