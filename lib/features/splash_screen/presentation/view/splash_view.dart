import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/features/on_boarding_screen/presentation/view/on_boarding_screen_view.dart';
import 'package:rentify_flat_management/features/splash_screen/presentation/view_model/splash_cubit.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(),
      child: const SplashScreenBody(),
    );
  }
}

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Start the timer to navigate to the Onboarding screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreenView()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 3),
          tween: Tween(begin: -1.0, end: 3.0),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.transparent,
                    Colors.white.withOpacity(0.6)
                  ],
                  begin: Alignment(-1 + value, 0),
                  end: Alignment(1 + value, 0),
                ).createShader(bounds);
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            );
          },
        ),
      ),
    );
  }
}
