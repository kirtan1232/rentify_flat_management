import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';

class OnBoardingScreenCubit extends Cubit<void> {
  OnBoardingScreenCubit(this._loginBloc) : super(null);
  final LoginBloc _loginBloc;

  List<PageViewModel> getPages(BuildContext context) {
    return [
      PageViewModel(
        title: "Find Your Dream Flat Effortlessly",
        body:
            "Explore verified listings, connect with landlords, and rent your ideal flat with ease.",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/logo.png', height: 170),
          ),
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Get Verified Listings",
        body:
            "Access a wide range of verified listings with accurate information to avoid hassle.",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/verify.png', height: 170),
          ),
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Easy & Secure Transactions",
        body:
            "Make payments securely and track your transactions for a stress-free experience.",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/payment.png', height: 170),
          ),
        ),
        decoration: getPageDecoration(),
      ),
    ];
  }

  // Page decoration for all pages
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.2, // Added line height for better spacing
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.white70,
        height: 1.5, // Added line height for better spacing
      ),
      bodyPadding: EdgeInsets.all(20.0),
      imagePadding: EdgeInsets.only(top: 30),
      pageColor: Color(0xFF4CAF50),
    );
  }

  // Dots decorator for pagination
  DotsDecorator getDotsDecorator() {
    return DotsDecorator(
      size: const Size(12, 12),
      color: Colors.white38,
      activeSize: const Size(24, 12),
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      activeColor: Colors.white,
    );
  }

  // Navigation to Login Screen
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _loginBloc,
                child: LoginScreenView(),
              )),
    );
  }
}
