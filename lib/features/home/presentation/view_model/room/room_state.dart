part of 'room_bloc.dart';

class RoomState extends Equatable {
  final bool isLoading;
  final List<RoomEntity> rooms;
  final String? error;

  const RoomState({
    required this.isLoading,
    required this.rooms,
    this.error,
  });

  const RoomState.initial()
      : isLoading = false,
        rooms = const [],
        error = null;

  RoomState copyWith({
    bool? isLoading,
    List<RoomEntity>? rooms,
    String? error,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      rooms: rooms ?? this.rooms,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, rooms, error];
}