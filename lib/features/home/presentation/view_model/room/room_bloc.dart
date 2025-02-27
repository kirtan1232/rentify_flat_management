import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/core/common/snackbar/my_snackbar.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_all_room_usecase.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetAllRoomsUseCase _getAllRoomsUseCase;

  RoomBloc(this._getAllRoomsUseCase) : super(RoomState.initial()) {
    on<FetchRoomsEvent>(_onFetchRooms);
  }

  void _onFetchRooms(FetchRoomsEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getAllRoomsUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (rooms) {
        emit(state.copyWith(isLoading: false, rooms: rooms));
      },
    );
  }
}