// lib/features/home/presentation/view/bottom_view/privacy_policy_view.dart
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy & Policy',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.green[400]
            : Colors.grey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: [Insert Date]\n\n'
              'At Rentify, we prioritize your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app. By using Rentify, you agree to the terms outlined here.\n\n'
              '**1. Information We Collect**\n'
              '- **Personal Information**: Name, email, and contact details provided during registration.\n'
              '- **Usage Data**: Information on how you use the app, such as search history and preferences.\n'
              '- **Device Information**: Device type, OS, and IP address.\n\n'
              '**2. How We Use Your Information**\n'
              '- To provide and improve our services.\n'
              '- To personalize your experience and show relevant listings.\n'
              '- To communicate with you about your account or updates.\n\n'
              '**3. Data Sharing and Disclosure**\n'
              '- We do not sell your personal information. We may share it with service providers or legal authorities if required by law.\n\n'
              '**4. Your Rights**\n'
              '- You can access, update, or delete your personal information via your account settings. You can also request data portability or opt-out of marketing communications.\n\n'
              '**5. Security**\n'
              '- We use industry-standard security measures to protect your data, but no method is 100% secure.\n\n'
              '**6. Changes to This Policy**\n'
              '- We may update this policy periodically. Check back for updates or subscribe to notifications.\n\n'
              '**Contact Us**\n'
              'If you have questions, contact us at support@rentify.com.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
