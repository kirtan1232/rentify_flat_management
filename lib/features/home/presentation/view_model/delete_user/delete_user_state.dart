import 'package:equatable/equatable.dart';

class DeleteAccountState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleted;

  const DeleteAccountState({
    this.isLoading = false,
    this.errorMessage,
    this.isDeleted = false,
  });

  factory DeleteAccountState.initial() => const DeleteAccountState();

  DeleteAccountState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isDeleted,
  }) {
    return DeleteAccountState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isDeleted];
}