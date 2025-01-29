import 'package:bloc/bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  // Update the current page index
  void updatePageIndex(int index) {
    emit(index);
  }
}
