// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomApiModel _$RoomApiModelFromJson(Map<String, dynamic> json) => RoomApiModel(
      id: json['_id'] as String?,
      roomDescription: json['roomDescription'] as String,
      floor: (json['floor'] as num).toInt(),
      address: json['address'] as String,
      rentPrice: (json['rentPrice'] as num).toDouble(),
      parking: json['parking'] as String,
      contactNo: json['contactNo'] as String,
      bathroom: (json['bathroom'] as num).toInt(),
      roomImage: json['roomImage'] as String?,
    );

Map<String, dynamic> _$RoomApiModelToJson(RoomApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'roomDescription': instance.roomDescription,
      'floor': instance.floor,
      'address': instance.address,
      'rentPrice': instance.rentPrice,
      'parking': instance.parking,
      'contactNo': instance.contactNo,
      'bathroom': instance.bathroom,
      'roomImage': instance.roomImage,
    };
