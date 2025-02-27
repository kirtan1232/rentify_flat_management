// lib/features/room/presentation/bloc/room_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/core/common/snackbar/my_snackbar.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/add_to_wishlist_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_all_room_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_wishlist.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/remove_from_wishlist_usecase.dart'; // Add this

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetAllRoomsUseCase _getAllRoomsUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final GetWishlistUseCase _getWishlistUseCase;
  final RemoveFromWishlistUseCase _removeFromWishlistUseCase; // Add this

  RoomBloc(
    this._getAllRoomsUseCase,
    this._addToWishlistUseCase,
    this._getWishlistUseCase,
    this._removeFromWishlistUseCase, // Add this
  ) : super(const RoomState.initial()) {
    on<FetchRoomsEvent>(_onFetchRooms);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<FetchWishlistEvent>(_onFetchWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist); // Add this
  }

  void _onFetchRooms(FetchRoomsEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final roomsResult = await _getAllRoomsUseCase();
    final wishlistResult = await _getWishlistUseCase();

    roomsResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        showMySnackBar(
            context: event.context,
            message: failure.message,
            color: Colors.red);
      },
      (rooms) {
        wishlistResult.fold(
          (failure) {
            // If wishlist fetch fails, still show rooms without wishlist sync
            emit(state.copyWith(isLoading: false, rooms: rooms));
          },
          (wishlist) {
            // Sync isWishlisted with wishlist
            final updatedRooms = rooms.map((room) {
              return room.copyWith(
                  isWishlisted: wishlist.any((w) => w.id == room.id));
            }).toList();
            emit(state.copyWith(
                isLoading: false, rooms: updatedRooms, wishlist: wishlist));
          },
        );
      },
    );
  }

  void _onAddToWishlist(
      AddToWishlistEvent event, Emitter<RoomState> emit) async {
    final result =
        await _addToWishlistUseCase(AddToWishlistParams(event.roomId));
    result.fold(
      (failure) {
        showMySnackBar(
            context: event.context,
            message: failure.message,
            color: Colors.red);
      },
      (_) {
        final updatedRooms = state.rooms.map((room) {
          if (room.id == event.roomId) {
            return room.copyWith(isWishlisted: true);
          }
          return room;
        }).toList();
        final updatedWishlist = [
          ...state.wishlist,
          state.rooms.firstWhere((r) => r.id == event.roomId)
        ];
        emit(state.copyWith(rooms: updatedRooms, wishlist: updatedWishlist));
        showMySnackBar(context: event.context, message: 'Added to wishlist!');
      },
    );
  }

  void _onFetchWishlist(
      FetchWishlistEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getWishlistUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        showMySnackBar(
            context: event.context,
            message: failure.message,
            color: Colors.red);
      },
      (wishlist) {
        // Sync isWishlisted for rooms when wishlist is fetched
        final updatedRooms = state.rooms.map((room) {
          return room.copyWith(
              isWishlisted: wishlist.any((w) => w.id == room.id));
        }).toList();
        emit(state.copyWith(
            isLoading: false, wishlist: wishlist, rooms: updatedRooms));
      },
    );
  }

  void _onRemoveFromWishlist(
      RemoveFromWishlistEvent event, Emitter<RoomState> emit) async {
    final result = await _removeFromWishlistUseCase(
        RemoveFromWishlistParams(event.roomId));
    result.fold(
      (failure) {
        showMySnackBar(
            context: event.context,
            message: failure.message,
            color: Colors.red);
      },
      (_) {
        final updatedRooms = state.rooms.map((room) {
          if (room.id == event.roomId) {
            return room.copyWith(isWishlisted: false);
          }
          return room;
        }).toList();
        final updatedWishlist =
            state.wishlist.where((room) => room.id != event.roomId).toList();
        emit(state.copyWith(rooms: updatedRooms, wishlist: updatedWishlist));
        showMySnackBar(
            context: event.context, message: 'Removed from wishlist!');
      },
    );
  }
}
