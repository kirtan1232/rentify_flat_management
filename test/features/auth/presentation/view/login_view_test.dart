import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/signup_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:local_auth/local_auth.dart';

// Mock classes
@GenerateMocks([LoginBloc, LocalAuthentication, BuildContext])
import 'login_view_test.mocks.dart';

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockLocalAuthentication mockLocalAuth;
  late MockBuildContext mockContext;
  late StreamController<LoginState> loginStateController;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockLocalAuth = MockLocalAuthentication();
    mockContext = MockBuildContext();

    // Ensure GetIt is reset and mockLoginBloc is registered before any widget is built
    getIt.reset();
    getIt.registerLazySingleton<LoginBloc>(() => mockLoginBloc);

    // Stream controller for LoginBloc
    loginStateController = StreamController<LoginState>.broadcast();
    when(mockLoginBloc.stream).thenAnswer((_) => loginStateController.stream);
    // Adjust this based on your actual LoginState constructor
    when(mockLoginBloc.state).thenReturn(const LoginState(
      isLoading: false,
      isSuccess: false,
    ));

    // Mock LocalAuthentication behavior
    when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
    when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);
    when(mockLocalAuth.authenticate(
      localizedReason: anyNamed('localizedReason'),
      options: anyNamed('options'),
    )).thenAnswer((_) async => true);
  });

  tearDown(() {
    loginStateController.close();
    getIt.reset();
  });

  // Helper to build the widget, ensuring GetIt is ready
  Widget buildTestWidget() {
    // Double-check GetIt registration before building
    if (!getIt.isRegistered<LoginBloc>()) {
      getIt.registerLazySingleton<LoginBloc>(() => mockLoginBloc);
    }
    return MaterialApp(
      home: LoginScreenView(),
    );
  }

  testWidgets('LoginScreenView renders initial UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Login to your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have an account? Sign Up"), findsOneWidget);
    expect(find.text('Login with Fingerprint'), findsOneWidget);
  });

  testWidgets('LoginScreenView triggers LoginUserEvent on login button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    verify(mockLoginBloc.add(argThat(isA<LoginUserEvent>()
            .having((e) => e.email, 'email', 'test@example.com')
            .having((e) => e.password, 'password', 'password123')
            .having((e) => e.context, 'context', isA<BuildContext>()))))
        .called(1);
  });

  testWidgets('LoginScreenView navigates to SignUp on sign-up button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pump();

    verify(mockLoginBloc.add(argThat(isA<NavigateRegisterScreenEvent>()
            .having((e) => e.destination, 'destination', isA<SignupScreenView>())
            .having((e) => e.context, 'context', isA<BuildContext>()))))
        .called(1);
  });


}