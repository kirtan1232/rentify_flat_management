import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/edit_profile/edit_profile_state.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  final _key = GlobalKey<FormState>();
  static const String _baseUrl = 'http://192.168.101.11:3000'; // Replace with your backend URL

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _browseImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Error selecting image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

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
              label: const Text('Camera', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _browseImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.image, color: Colors.black),
              label: const Text('Gallery', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileBloc>()..add(const LoadCurrentUserEvent()),
      child: Builder(
        builder: (blocContext) {
          final editProfileBloc = BlocProvider.of<EditProfileBloc>(blocContext);
          if (editProfileBloc == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(
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
              body: const Center(
                child: Text('Error: EditProfileBloc is not available'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Edit Profile",
                style: GoogleFonts.poppins(
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if it's a tablet (e.g., width > 600)
                bool isTablet = constraints.maxWidth > 600;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40.0 : 16.0,
                    vertical: 16.0,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Image Picker
                            BlocBuilder<EditProfileBloc, EditProfileState>(
                              builder: (context, state) {
                                ImageProvider? imageProvider;
                                if (_profileImage != null) {
                                  imageProvider = FileImage(_profileImage!);
                                } else if (state.currentUser?.image != null &&
                                    state.currentUser!.image!.isNotEmpty) {
                                  imageProvider = NetworkImage(
                                    '$_baseUrl/uploads/profile/${state.currentUser!.image}',
                                  );
                                } else {
                                  imageProvider = const AssetImage('assets/images/profile.png');
                                }

                                return InkWell(
                                  onTap: () => _showImageSourceSelector(context),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: CircleAvatar(
                                      backgroundImage: imageProvider,
                                      backgroundColor: Colors.grey[300],
                                      child: _profileImage == null &&
                                              (state.currentUser?.image == null ||
                                                  state.currentUser!.image!.isEmpty)
                                          ? const Icon(Icons.camera_alt,
                                              size: 50, color: Colors.black)
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            // Form Fields
                            BlocConsumer<EditProfileBloc, EditProfileState>(
                              listener: (context, state) {
                                if (state.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.errorMessage!)),
                                  );
                                }
                                if (state.isUpdateSuccess) {
                                  if (mounted) {
                                    setState(() {
                                      _profileImage = null; // Reset local image
                                    });
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (state.currentUser == null) {
                                  return const Center(child: Text("Unable to load user data"));
                                }

                                final nameController = TextEditingController(text: state.currentUser!.name);
                                final passwordController = TextEditingController();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email (Read-only)
                                    TextFormField(
                                      initialValue: state.currentUser!.email,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        enabled: false,
                                        fillColor: Theme.of(context).brightness == Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[800],
                                        filled: true,
                                      ),
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    // Name (Editable)
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        fillColor: Theme.of(context).brightness == Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[800],
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Name cannot be empty";
                                        }
                                        return null;
                                      },
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    // Password (Editable)
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: "New Password (optional)",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        fillColor: Theme.of(context).brightness == Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[800],
                                        filled: true,
                                      ),
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_key.currentState != null) {
                                            if (_key.currentState!.validate()) {
                                              final editProfileBloc = context.read<EditProfileBloc>();
                                              if (editProfileBloc != null) {
                                                editProfileBloc.add(
                                                  UpdateProfileEvent(
                                                    name: nameController.text,
                                                    password: passwordController.text,
                                                    context: context,
                                                    image: _profileImage,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                      content: Text('EditProfileBloc is not available')),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text('Please fill in all fields correctly')),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text('Form is not initialized')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[400],
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: Text(
                                          "Update Profile",
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _profileImage?.delete(); // Clean up the temporary file if it exists
    super.dispose();
  }
}