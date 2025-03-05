import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';

import 'package:rentify_flat_management/features/home/presentation/view/home_view.dart';

class PaymentSuccessView extends StatefulWidget {
  final RoomEntity room;

  const PaymentSuccessView({super.key, required this.room});

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> {
  final bool _showSuccess = true; // Track whether to show success
  bool _showLoading = false; // Track whether to show loading
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to show loading after 3 seconds
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _showLoading = true;
      });
      // After showing loading for 2 seconds, navigate to DashboardView
      _timer = Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeView()), // Navigate to DashboardView
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Always show success content
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Payment Success !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your payment process has been completed successfully.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'NPR. ${widget.room.rentPrice}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your payment success. Please wait while we redirect back to vendor.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thank you!!!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),

                  // Conditionally show loading content below success content
                  if (_showLoading) ...[
                    const SizedBox(height: 24), // Spacing before loading
                    const LinearProgressIndicator(
                      color: Colors.green,
                      backgroundColor: Colors.grey,
                      minHeight: 4, // Adjust height of the line
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Redirecting to Dashboard...',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
