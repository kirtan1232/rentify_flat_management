import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/delete_user/delete_user_state.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<DeleteAccountBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Delete Account"),
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.green[400]
              : Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }

            final passwordController = TextEditingController();

            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            Colors.grey[900]!,
                            Colors.black
                          ] // Dark mode gradient
                        : [
                            Colors.red[50]!,
                            Colors.white
                          ], // Light mode gradient
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white, // Card color adapts
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Delete Your Account",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "This action is permanent and cannot be undone. Please confirm your password to proceed.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey, // Text color adapts
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  labelStyle: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isDarkMode
                                            ? Colors.grey[700]!
                                            : Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (passwordController.text.isNotEmpty) {
                                      context.read<DeleteAccountBloc>().add(
                                            DeleteAccountConfirmEvent(
                                              password: passwordController.text,
                                              context: context,
                                            ),
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              "Please enter your password"),
                                          backgroundColor: Colors.red[700],
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
