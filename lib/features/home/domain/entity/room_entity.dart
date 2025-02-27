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
  });

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
      ];
}