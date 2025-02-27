// lib/features/room/presentation/bloc/room_state.dart
part of 'room_bloc.dart';

class RoomState extends Equatable {
  final bool isLoading;
  final List<RoomEntity> rooms;
  final List<RoomEntity> wishlist;
  final String? error;

  const RoomState({
    required this.isLoading,
    required this.rooms,
    required this.wishlist,
    this.error,
  });

  const RoomState.initial()
      : isLoading = false,
        rooms = const [],
        wishlist = const [],
        error = null;

  RoomState copyWith({
    bool? isLoading,
    List<RoomEntity>? rooms,
    List<RoomEntity>? wishlist,
    String? error,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      rooms: rooms ?? this.rooms,
      wishlist: wishlist ?? this.wishlist,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, rooms, wishlist, error];
}