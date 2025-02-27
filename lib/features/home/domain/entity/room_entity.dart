// lib/features/room/domain/entities/room_entity.dart
import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String? id;
  final String roomDescription;
  final int floor;
  final String address;
  final double rentPrice;
  final String parking;
  final String contactNo;
  final int bathroom;
  final String? roomImage;
  final bool isWishlisted; // Added

  const RoomEntity({
    this.id,
    required this.roomDescription,
    required this.floor,
    required this.address,
    required this.rentPrice,
    required this.parking,
    required this.contactNo,
    required this.bathroom,
    this.roomImage,
    this.isWishlisted = false, // Default to false
  });

  RoomEntity copyWith({bool? isWishlisted}) {
    return RoomEntity(
      id: id,
      roomDescription: roomDescription,
      floor: floor,
      address: address,
      rentPrice: rentPrice,
      parking: parking,
      contactNo: contactNo,
      bathroom: bathroom,
      roomImage: roomImage,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        roomDescription,
        floor,
        address,
        rentPrice,
        parking,
        contactNo,
        bathroom,
        roomImage,
        isWishlisted,
      ];
}