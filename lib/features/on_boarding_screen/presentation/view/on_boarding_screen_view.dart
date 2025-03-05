import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:rentify_flat_management/features/on_boarding_screen/presentation/view_model/on_boarding_screen_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnBoardingScreenCubit _onBoardingCubit;

  @override
  void initState() {
    super.initState();
    _onBoardingCubit = context.read<OnBoardingScreenCubit>();
  }

  // Define the onboarding pages
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Find Your Dream Flat Effortlessly",
        bodyWidget: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          // Removed the decoration with border
          child: const Text(
            "Explore verified listings, connect with landlords, and rent your ideal flat with ease.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Changed from black to white
              height: 1.5,
            ),
          ),
        ),
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/slide1.png', height: 220),
          ),
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Get Verified Listings",
        bodyWidget: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          // Removed the decoration with border
          child: const Text(
            "Access a wide range of verified listings with accurate information to avoid hassle.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Changed from black to white
              height: 1.5,
            ),
          ),
        ),
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/verify.png', height: 220),
          ),
        ),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Easy & Secure Transactions",
        bodyWidget: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          // Removed the decoration with border
          child: const Text(
            "Make payments securely and track your transactions for a stress-free experience.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Changed from black to white
              height: 1.5,
            ),
          ),
        ),
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset('assets/images/payment.png', height: 220),
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
        height: 1.2,
      ),
      bodyPadding: EdgeInsets.all(20.0),
      imagePadding: EdgeInsets.only(top: 30),
      pageColor: Colors.transparent, // Set to transparent to show the full gradient
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF81C784), // Light green on the left
              Color(0xFF388E3C), // Dark green on the right
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: IntroductionScreen(
          pages: getPages(),
          onDone: () => _onBoardingCubit.navigateToLogin(context),
          onSkip: () => _onBoardingCubit.navigateToLogin(context),
          showSkipButton: true,
          skip: const Text(
            "Skip",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
          ),
          next: const Icon(Icons.arrow_forward, color: Colors.white),
          done: const Text(
            "Get Started",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ), // Plain text instead of gradient button
          dotsDecorator: getDotsDecorator(),
          globalBackgroundColor: Colors.transparent, // Transparent to show the gradient
        ),
      ),
    );
  }
}