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
  final _nameController = TextEditingController(text: 'Kirtan Shrestha');
  final _emailController = TextEditingController(text: 'example@gmail.com');
  final _passwordController = TextEditingController(text: '1234');
  final _confirmPasswordController = TextEditingController();

  File? _img; // Variable to hold selected image
  bool _obscurePassword = true; // To toggle password visibility
  bool _obscureConfirmPassword = true; // To toggle confirm password visibility

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
          final signupBloc = context.read<SignupBloc>();
          signupBloc.add(LoadImage(file: _img!));
        });
      }
    } catch (e) {
      debugPrint("Error selecting image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
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
                Navigator.pop(context);
              },
              icon: const Icon(Icons.camera, color: Colors.black),
              label:
                  const Text('Camera', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _browseImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.image, color: Colors.black),
              label:
                  const Text('Gallery', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignupBloc>(),
      child: Builder(
        builder: (context) {
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
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine if it's a tablet (e.g., width > 600)
                      bool isTablet = constraints.maxWidth > 600;

                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: isTablet ? 500 : double.infinity),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40.0 : 20.0,
                              vertical: 20.0,
                            ),
                            child: Form(
                              key: _key,
                              child: Container(
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
                                      onTap: () =>
                                          _showImageSourceSelector(context),
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: CircleAvatar(
                                          backgroundImage: _img != null
                                              ? FileImage(_img!)
                                              : const AssetImage(
                                                      'assets/images/logo.png')
                                                  as ImageProvider,
                                          child: _img == null
                                              ? const Icon(Icons.camera_alt,
                                                  size: 50, color: Colors.black)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Full Name Field
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Full Name',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                      obscureText: _obscureConfirmPassword,
                                      decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword =
                                                  !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                          if (_key.currentState != null) {
                                            if (_key.currentState!.validate()) {
                                              final signupBloc =
                                                  context.read<SignupBloc>();
                                              final signupState =
                                                  signupBloc.state;
                                              final imageName =
                                                  signupState.imageName;
                                              signupBloc.add(
                                                SignupUser(
                                                  context: context,
                                                  name: _nameController.text,
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                  image: imageName,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please fill in all fields correctly')),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Form is not initialized')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF4CAF50),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Already have an account? Login now
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            "Already have an account? ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              final signupBloc =
                                                  context.read<SignupBloc>();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BlocProvider<
                                                        LoginBloc>(
                                                      create: (_) =>
                                                          getIt<LoginBloc>(),
                                                      child: LoginScreenView(),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "Login now",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
