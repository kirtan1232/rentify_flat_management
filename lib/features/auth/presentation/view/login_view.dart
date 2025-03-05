import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/signup_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreenView extends StatefulWidget {
  LoginScreenView({super.key});

  @override
  _LoginScreenViewState createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'example@gmail.com');
  final passwordController = TextEditingController(text: '1234');
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _obscureText = true; // Added to manage password visibility

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      bool canAuthenticate = await _localAuth.canCheckBiometrics;
      if (!canAuthenticate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available')),
        );
        return;
      }

      bool isBiometricEnrolled = await _localAuth.isDeviceSupported();
      if (!isBiometricEnrolled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometric data enrolled on this device')),
        );
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in to Rentify',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && formKey.currentState != null && formKey.currentState!.validate()) {
        final loginBloc = context.read<LoginBloc>();
        if (loginBloc != null) {
          loginBloc.add(
            LoginUserEvent(
              context: context,
              email: emailController.text,
              password: passwordController.text,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('LoginBloc is not available')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication failed or form is invalid')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during biometric authentication: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                print('Login successful, navigation handled by LoginBloc');
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Determine if it's a tablet (e.g., width > 600)
                        bool isTablet = constraints.maxWidth > 600;

                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 40.0 : 20.0,
                                vertical: 20.0,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Welcome",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Login to your account",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              labelText: "Email",
                                              prefixIcon: const Icon(Icons.email, color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              labelStyle: const TextStyle(color: Colors.black),
                                            ),
                                            style: const TextStyle(color: Colors.black),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your email';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: passwordController,
                                            obscureText: _obscureText,
                                            decoration: InputDecoration(
                                              labelText: "Password",
                                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              labelStyle: const TextStyle(color: Colors.black),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText = !_obscureText;
                                                  });
                                                },
                                              ),
                                            ),
                                            style: const TextStyle(color: Colors.black),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 30),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (formKey.currentState != null) {
                                                  if (formKey.currentState!.validate()) {
                                                    final loginBloc = context.read<LoginBloc>();
                                                    if (loginBloc != null) {
                                                      loginBloc.add(
                                                        LoginUserEvent(
                                                          context: context,
                                                          email: emailController.text,
                                                          password: passwordController.text,
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('LoginBloc is not available')),
                                                      );
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Please fill in all fields correctly')),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Form is not initialized')),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text(
                                                "Login",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () => _authenticateWithBiometrics(context),
                                              icon: const Icon(Icons.fingerprint, color: Colors.black),
                                              label: const Text(
                                                "Login with Fingerprint",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: BorderSide(color: Colors.grey),
                                                ),
                                                elevation: 2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextButton(
                                            onPressed: () {
                                              final loginBloc = context.read<LoginBloc>();
                                              if (loginBloc != null) {
                                                loginBloc.add(
                                                  NavigateRegisterScreenEvent(
                                                    context: context,
                                                    destination: const SignupScreenView(),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('LoginBloc is not available')),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "Don't have an account? Sign Up",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}