import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/edit_profile.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /// =========================
          ///      GENERAL SECTION
          /// =========================
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
                _buildListTile(Icons.notifications, 'Notifications', () {}),
                _buildDarkModeSwitch(),
              ],
            ),
          ),

          /// =========================
          ///     FEEDBACK SECTION
          /// =========================
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
                _buildListTile(Icons.bug_report, 'Report a bug', () {}),
                _buildListTile(Icons.send, 'Send feedback', () {}),
              ],
            ),
          ),

          /// =========================
          ///      LOGOUT SECTION
          /// =========================
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
                _buildListTile(Icons.delete, 'Delete account', () {}),
                _buildListTile(
                  Icons.logout,
                  'Logout',
                  () {
                    showMySnackBar(
                      context: context,
                      message: 'Logging out...',
                      color: Colors.red,
                    );

                    // Delay logout to ensure snackbar is visible
                    Future.delayed(const Duration(seconds: 0), () {
                      context.read<HomeCubit>().logout(context);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a standard ListTile with an icon
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  /// Builds the Dark Mode toggle switch
  Widget _buildDarkModeSwitch() {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      secondary: const Icon(Icons.dark_mode, color: Colors.black54),
      value: isDarkMode,
      onChanged: (value) {
        setState(() {
          isDarkMode = value;
        });
      },
    );
  }
}

/// Simple widget for section header
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
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// Snackbar function to show messages
void showMySnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 1),
    ),
  );
}
