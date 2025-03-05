import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/features/splash_screen/presentation/view_model/splash_cubit.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController for blinking
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Blink every 1 second
      vsync: this,
    )..repeat(reverse: true); // Repeat and reverse for fade in/out

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Trigger SplashCubit initialization
    context.read<SplashCubit>().init(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Blinking Logo
            FadeTransition(
              opacity: _blinkAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 200, // Adjust size as needed
                height: 200,
              ),
            ),
            const SizedBox(height: 20), // Space between logo and loading circle
            // Loading Circle with subtle animation
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.withOpacity(0.7)),
                strokeWidth: 4.0,
                backgroundColor: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}