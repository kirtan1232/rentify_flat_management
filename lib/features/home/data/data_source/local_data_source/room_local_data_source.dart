import 'package:rentify_flat_management/core/network/hive_service.dart';
import 'package:rentify_flat_management/features/home/data/model/room_api_model.dart';
import 'package:rentify_flat_management/features/home/data/model/room_hive_model.dart';

abstract class RoomLocalDataSource {
  Future<void> saveRooms(List<RoomApiModel> rooms);
  Future<List<RoomApiModel>> getAllRooms();
  Future<void> clearRooms();
}

class RoomLocalDataSourceImpl implements RoomLocalDataSource {
  final HiveService hiveService;

  RoomLocalDataSourceImpl(this.hiveService);

  @override
  Future<void> saveRooms(List<RoomApiModel> rooms) async {
    final hiveRooms =
        rooms.map((model) => RoomHiveModel.fromApiModel(model)).toList();
    await hiveService.saveRooms(hiveRooms);
  }

  @override
  Future<List<RoomApiModel>> getAllRooms() async {
    final hiveRooms = await hiveService.getAllRooms();
    return hiveRooms.map((hiveModel) => hiveModel.toApiModel()).toList();
  }

  @override
  Future<void> clearRooms() async {
    await hiveService.clearRooms();
  }
}