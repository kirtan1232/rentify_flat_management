// part 'auth_hive_model.g.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rentify_flat_management/app/constants/hive_table_constants.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String? image;

  AuthHiveModel({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
    this.image,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : userId = '',
        name = '',
        email = '',
        password = '',
        image = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      image: entity.image,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      name: name,
      email: email,
      password: password,
      image: image,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, password, image];
}
