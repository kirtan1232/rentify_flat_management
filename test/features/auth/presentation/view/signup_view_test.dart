import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/signup_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';

// Mock classes
@GenerateMocks([SignupBloc])
import 'signup_view_test.mocks.dart';

void main() {
  late MockSignupBloc mockSignupBloc;

  setUp(() {
    mockSignupBloc = MockSignupBloc();

    // Reset GetIt and register the mock SignupBloc
    getIt.reset();
    getIt.registerLazySingleton<SignupBloc>(() => mockSignupBloc);

    // Mock minimal SignupBloc behavior with real SignupState
    when(mockSignupBloc.stream).thenAnswer((_) => Stream.value(
        SignupState(imageName: '', isLoading: false, isSuccess: false)));
    when(mockSignupBloc.state).thenReturn(
        SignupState(imageName: '', isLoading: false, isSuccess: false));
  });

  tearDown(() {
    getIt.reset();
  });

  // Helper to build the widget
  Widget buildTestWidget() {
    return const MaterialApp(
      home: SignupScreenView(),
    );
  }

  testWidgets('SignupScreenView renders initial UI correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);
    expect(find.text('Login now'), findsOneWidget);
  });

  testWidgets('SignupScreenView has correct text fields and labels',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(
        find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
  });
  testWidgets('SignupScreenView Sign Up button is enabled',
    (WidgetTester tester) async {
  await tester.pumpWidget(buildTestWidget());
  await tester.pumpAndSettle();

  final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
  expect(tester.widget<ElevatedButton>(signUpButton).enabled, isTrue);
});

testWidgets('SignupScreenView CircleAvatar tap opens bottom sheet',
    (WidgetTester tester) async {
  await tester.pumpWidget(buildTestWidget());
  await tester.pumpAndSettle();

  // Tap the CircleAvatar
  await tester.tap(find.byType(CircleAvatar));
  await tester.pumpAndSettle();

  // Verify that the bottom sheet is displayed
  expect(find.text('Camera'), findsOneWidget);
  expect(find.text('Gallery'), findsOneWidget);
});

}
