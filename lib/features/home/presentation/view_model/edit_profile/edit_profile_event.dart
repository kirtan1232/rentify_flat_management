import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:io';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrentUserEvent extends EditProfileEvent {
  const LoadCurrentUserEvent();
}

class UpdateProfileEvent extends EditProfileEvent {
  final String name;
  final String password;
  final BuildContext context;
  final File? image; // Added for image support

  const UpdateProfileEvent({
    required this.name,
    required this.password,
    required this.context,
    this.image, // Optional image parameter
  });

  @override
  List<Object?> get props => [name, password, context, image];
}