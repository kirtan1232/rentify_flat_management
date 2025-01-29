import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/on_boarding_screen/presentation/view_model/on_boarding_screen_cubit.dart';

class OnboardingScreenView extends StatelessWidget {
  const OnboardingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const OnboardingScreenBody(),
    );
  }
}

class OnboardingScreenBody extends StatelessWidget {
  const OnboardingScreenBody({super.key});

  final List<Widget> _onboardingPages = const [
    OnboardingPage(
      imagePath: 'assets/images/logo.png',
      title: 'Find Your Dream Flat\nEffortlessly',
      description:
          'Explore verified listings, connect with landlords,\nand rent your ideal flat with ease.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/verify.png',
      title: 'Get Verified Listings',
      description:
          'Access a wide range of verified listings\nwith accurate information to avoid hassle.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/payment.png',
      title: 'Easy & Secure Transactions',
      description:
          'Make payments securely and track your\ntransactions for a stress-free experience.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF28CC0D), Color(0xFF8BF979)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // PageView for Onboarding Screens
          PageView.builder(
            controller: pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (index) {
              // Update the current page index in Cubit
              context.read<OnboardingCubit>().updatePageIndex(index);
            },
            itemBuilder: (context, index) {
              return _onboardingPages[index];
            },
          ),

          // Skip Button (only on slide 1 and slide 2)
          BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentPage) {
              return currentPage < _onboardingPages.length - 1
                  ? Positioned(
                      top: 50,
                      right: 20,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: getIt<
                                    LoginBloc>(), // Pass the existing LoginBloc instance here
                                child: const LoginScreenView(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),

          // Bottom Page Indicator and "Get Started" Button on Slide 3
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page Indicator Dots
                BlocBuilder<OnboardingCubit, int>(
                  builder: (context, currentPage) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingPages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.white
                                : Colors.white38,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // "Get Started" Button (only on the last page)
                BlocBuilder<OnboardingCubit, int>(
                  builder: (context, currentPage) {
                    return currentPage == _onboardingPages.length - 1
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: getIt<
                                        LoginBloc>(), // Pass the existing LoginBloc instance here
                                    child: const LoginScreenView(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF28CC0D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A reusable widget for onboarding pages
class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            imagePath,
            height: 200,
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
