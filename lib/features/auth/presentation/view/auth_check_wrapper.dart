import 'package:flutter/material.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/features/home/presentation/view/home_view.dart';
import 'package:rentify_flat_management/features/splash_screen/presentation/view/splash_view.dart';

class AuthCheckWrapper extends StatefulWidget {
  const AuthCheckWrapper({super.key});

  @override
  State<AuthCheckWrapper> createState() => _AuthCheckWrapperState();
}

class _AuthCheckWrapperState extends State<AuthCheckWrapper> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final tokenSharedPrefs = getIt<TokenSharedPrefs>();
    final tokenResult = await tokenSharedPrefs.getToken();

    tokenResult.fold(
      (failure) {
        print('Token check failed: ${failure.message}');
        _navigateToSplash(); // Navigate to SplashScreenView on failure
      },
      (token) {
        print('Token retrieved: "$token"');
        if (token.isNotEmpty) {
          print('User is logged in, navigating to HomeView');
          _navigateToHome();
        } else {
          print('No token found, navigating to SplashScreenView');
          _navigateToSplash(); // Navigate to SplashScreenView when no token
        }
      },
    );
  }

  void _navigateToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    });
  }

  void _navigateToSplash() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SplashScreenView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}