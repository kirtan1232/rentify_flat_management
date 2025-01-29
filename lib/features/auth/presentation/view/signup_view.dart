import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';

class SignupScreenView extends StatefulWidget {
  const SignupScreenView({super.key});

  @override
  State<SignupScreenView> createState() => _SignupScreenViewState();
}

class _SignupScreenViewState extends State<SignupScreenView> {
  final _gap = const SizedBox(height: 8);
  final _key = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'Kirtan Shrestha');
  final _emailController = TextEditingController(text: 'example@gmail.com');
  final _passwordController = TextEditingController(text: '1234');
  final _confirmPasswordController = TextEditingController();

  File? _img; // Variable to hold selected image

  // Check camera permission
  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  // Browse image from camera or gallery
  Future<void> _browseImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        setState(() {
          _img = File(image.path);
            context.read<SignupBloc>().add(
                LoadImage(file: _img!));
        });
      }
    } catch (e) {
      debugPrint("Error selecting image: $e");
    }
  }

  // Show bottom sheet for image source selection
  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[300],
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await _checkCameraPermission();
                await _browseImage(ImageSource.camera);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              icon: const Icon(Icons.camera),
              label: const Text('Camera'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _browseImage(ImageSource.gallery);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              icon: const Icon(Icons.image),
              label: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Card
          Form(
            key: _key,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image Picker
                      InkWell(
                        onTap: () => _showImageSourceSelector(context),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            backgroundImage: _img != null
                                ? FileImage(_img!)
                                : const AssetImage('assets/images/logo.png')
                                    as ImageProvider,
                            child: _img == null
                                ? const Icon(Icons.camera_alt, size: 50)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name Field
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      _gap,

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      _gap,

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      _gap,

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      _gap,

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              final registerState =
                              context.read<SignupBloc>().state;
                          final imageName = registerState.imageName;
                              context.read<SignupBloc>().add(
                                    SignupUser(
                                      context: context,
                                      fullName: _fullNameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      image: imageName,
                                    ),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Already have an account? Login now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BlocProvider<LoginBloc>(
                                      create: (_) => getIt<LoginBloc>(),
                                      child: LoginScreenView(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "Login now",
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
