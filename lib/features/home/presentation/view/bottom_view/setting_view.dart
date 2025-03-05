import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/app/shared_prefs/token_shared_prefs.dart';
import 'package:rentify_flat_management/core/app_theme/theme_cubit.dart';
import 'package:rentify_flat_management/core/utils/email_sender.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/delete_account.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/edit_profile.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/faq_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/privacypolicy_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Future<void> _logout(BuildContext context) async {
    final tokenSharedPrefs = getIt<TokenSharedPrefs>();
    await tokenSharedPrefs.saveToken(''); // Clear the token
    print('Token cleared, navigating to LoginScreenView');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreenView()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark or light
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDarkMode
                ? const Color(0xff00FF00)
                : Colors.white, // Dynamic AppBar text color
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(title: 'GENERAL'),
                _buildListTile(
                  Icons.person,
                  'Edit Profile',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                ),
                _buildListTile(Icons.notifications, 'Notifications', () {
                  context.read<HomeCubit>().onTabTapped(3);
                }),
                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDarkMode) {
                    return SwitchListTile(
                      title: const Text('Dark Mode'),
                      secondary: const Icon(Icons.dark_mode),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme(value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(title: 'FEEDBACK'),
                _buildListTile(Icons.bug_report, 'Report a bug', () {
                  _showBugReportDialog(context);
                }),
                _buildListTile(Icons.send, 'Send feedback', () {
                  _showFeedbackDialog(context);
                }),
              ],
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(title: 'Account Settings'),
                _buildListTile(Icons.question_answer, 'FAQ', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQView()),
                  );
                }),
                _buildListTile(Icons.lock, 'Privacy & Policy', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyView()),
                  );
                }),
                _buildListTile(Icons.delete, 'Delete account', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeleteAccountView()),
                  );
                }),
                _buildListTile(
                  Icons.logout,
                  'Logout',
                  () {
                    showMySnackBar(
                      context: context,
                      message: 'Logging out...',
                      color: Colors.red,
                    );
                    _logout(context); // Call logout directly
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Send Feedback'),
          content: TextField(
            controller: feedbackController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (feedbackController.text.isNotEmpty) {
                  try {
                    await sendEmail(
                      content: feedbackController.text,
                      subject: 'User Feedback',
                    );
                    Navigator.pop(dialogContext);
                    showMySnackBar(
                      context: context,
                      message: 'Feedback sent successfully!',
                      color: Colors.green,
                    );
                  } catch (e) {
                    showMySnackBar(
                      context: context,
                      message: 'Failed to send feedback: $e',
                      color: Colors.red,
                    );
                  }
                } else {
                  showMySnackBar(
                    context: context,
                    message: 'Please enter feedback',
                    color: Colors.red,
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final bugReportController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Report a Bug',
            style: TextStyle(color: Colors.red),
          ),
          content: TextField(
            controller: bugReportController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Describe the bug here...',
              hintStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (bugReportController.text.isNotEmpty) {
                  try {
                    await sendEmail(
                      content: bugReportController.text,
                      subject: 'Bug Report',
                    );
                    Navigator.pop(dialogContext);
                    showMySnackBar(
                      context: context,
                      message: 'Bug report sent successfully!',
                      color: Colors.green,
                    );
                  } catch (e) {
                    showMySnackBar(
                      context: context,
                      message: 'Failed to send bug report: $e',
                      color: Colors.red,
                    );
                  }
                } else {
                  showMySnackBar(
                    context: context,
                    message: 'Please enter a bug description',
                    color: Colors.red,
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

void showMySnackBar({
  required BuildContext context,
  required String message,
  Color color = Colors.green,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 1),
    ),
  );
}
