// lib/features/room/data/models/room_api_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';


part 'room_api_model.g.dart';

@JsonSerializable()
class RoomApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String roomDescription;
  final int floor;
  final String address;
  final double rentPrice;
  final String parking;
  final String contactNo;
  final int bathroom;
  final String? roomImage;

  RoomApiModel({
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

  factory RoomApiModel.fromJson(Map<String, dynamic> json) =>
      _$RoomApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomApiModelToJson(this);

  RoomEntity toEntity({bool isWishlisted = false}) => RoomEntity(
        id: id,
        roomDescription: roomDescription,
        floor: floor,
        address: address,
        rentPrice: rentPrice,
        parking: parking,
        contactNo: contactNo,
        bathroom: bathroom,
        roomImage: roomImage,
        isWishlisted: isWishlisted,
      );

  static RoomApiModel fromEntity(RoomEntity entity) => RoomApiModel(
        id: entity.id,
        roomDescription: entity.roomDescription,
        floor: entity.floor,
        address: entity.address,
        rentPrice: entity.rentPrice,
        parking: entity.parking,
        contactNo: entity.contactNo,
        bathroom: entity.bathroom,
        roomImage: entity.roomImage,
      );
}