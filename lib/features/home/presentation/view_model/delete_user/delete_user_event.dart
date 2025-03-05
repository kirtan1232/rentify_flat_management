import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

class DeleteAccountConfirmEvent extends DeleteAccountEvent {
  final String password;
  final BuildContext context;

  const DeleteAccountConfirmEvent({
    required this.password,
    required this.context,
  });

  @override
  List<Object?> get props => [password, context];
}