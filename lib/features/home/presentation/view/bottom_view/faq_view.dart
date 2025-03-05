// lib/features/home/presentation/view/bottom_view/faq_view.dart
import 'package:flutter/material.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
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
            _buildFAQItem(
              context: context,
              question: 'How do I sign up for Rentify?',
              answer:
                  'To sign up, download the app, tap "Sign Up," and provide your email, name, and password. Follow the verification steps sent to your email.',
            ),
            _buildFAQItem(
              context: context,
              question: 'How can I reset my password?',
              answer:
                  'Go to the login screen, tap "Forgot Password," enter your email, and follow the instructions sent to your email to reset it.',
            ),
            _buildFAQItem(
              context: context,
              question: 'What payment methods are accepted?',
              answer:
                  'We accept credit/debit cards and eSewa as payment methods depending on your region. Check the payment section in your profile.',
            ),
            _buildFAQItem(
              context: context,
              question: 'How do I contact customer support?',
              answer:
                  'You can contact our customer support team via email at support@rentify.com or through the "Contact Us" section in the app.',
            ),
            _buildFAQItem(
              context: context,
              question: 'Can I cancel my subscription?',
              answer:
                  'Yes, you can cancel your subscription anytime from your account settings. Go to "Account Settings," select "Manage Subscription," and follow the cancellation steps.',
            ),
            _buildFAQItem(
              context: context,
              question: 'How do I update my payment method?',
              answer:
                  'To update your payment method, navigate to your profile, go to "Payment Methods," and add or edit your preferred payment option (e.g., credit/debit card or eSewa).',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
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