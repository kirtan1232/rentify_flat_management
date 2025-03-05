import 'package:hive/hive.dart';
import 'package:rentify_flat_management/features/home/data/model/room_api_model.dart';

part 'room_hive_model.g.dart';

@HiveType(typeId: 1) // Use a unique typeId
class RoomHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String roomDescription;

  @HiveField(2)
  final int floor;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final double rentPrice;

  @HiveField(5)
  final String parking;

  @HiveField(6)
  final String contactNo;

  @HiveField(7)
  final int bathroom;

  @HiveField(8)
  final String? roomImage;

  RoomHiveModel({
    this.id,
    required this.roomDescription,
    required this.floor,
    required this.address,
    required this.rentPrice,
    required this.parking,
    required this.contactNo,
    required this.bathroom,
    this.roomImage,
  });

  factory RoomHiveModel.fromApiModel(RoomApiModel model) => RoomHiveModel(
        id: model.id,
        roomDescription: model.roomDescription,
        floor: model.floor,
        address: model.address,
        rentPrice: model.rentPrice,
        parking: model.parking,
        contactNo: model.contactNo,
        bathroom: model.bathroom,
        roomImage: model.roomImage,
      );

  RoomApiModel toApiModel() => RoomApiModel(
        id: id,
        roomDescription: roomDescription,
        floor: floor,
        address: address,
        rentPrice: rentPrice,
        parking: parking,
        contactNo: contactNo,
        bathroom: bathroom,
        roomImage: roomImage,
      );
}