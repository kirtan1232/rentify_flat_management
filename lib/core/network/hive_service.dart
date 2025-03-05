import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentify_flat_management/app/constants/hive_table_constants.dart';
import 'package:rentify_flat_management/features/auth/data/model/auth_hive_model.dart';
import 'package:rentify_flat_management/features/home/data/model/room_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}rentify.db';
    Hive.init(path);

    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(RoomHiveModelAdapter());
  }

  // Auth Queries (unchanged)
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var student = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return student;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> clearStudentBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }

  // Room Queries (simplified for RoomLocalDataSource)
  Future<void> saveRooms(List<RoomHiveModel> rooms) async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    await box.clear();
    for (var room in rooms) {
      await box.put(room.id, room);
    }
  }

  Future<List<RoomHiveModel>> getAllRooms() async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    return box.values.toList();
  }

  Future<void> clearRooms() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.roomBox);
  }
}