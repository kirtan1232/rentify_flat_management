import 'package:bloc/bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      emit(SplashFinished());
    });
  }
}

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashFinished extends SplashState {}
