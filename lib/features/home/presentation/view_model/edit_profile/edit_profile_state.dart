import 'package:equatable/equatable.dart';
import 'package:rentify_flat_management/features/auth/domain/entity/auth_entity.dart';

class EditProfileState extends Equatable {
  final bool isLoading;
  final AuthEntity? currentUser;
  final String? errorMessage;
  final bool isUpdateSuccess;

  const EditProfileState({
    this.isLoading = false,
    this.currentUser,
    this.errorMessage,
    this.isUpdateSuccess = false,
  });

  factory EditProfileState.initial() => const EditProfileState();

  EditProfileState copyWith({
    bool? isLoading,
    AuthEntity? currentUser,
    String? errorMessage,
    bool? isUpdateSuccess,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, currentUser, errorMessage, isUpdateSuccess];
}