import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/core/error/failure.dart';
import 'package:rentify_flat_management/features/auth/domain/use_case/login_usecase.dart';
import 'package:rentify_flat_management/features/auth/presentation/view/login_view.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:rentify_flat_management/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupBloc extends Mock implements SignupBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

void main() {
  late LoginBloc loginBloc;
  late LoginUseCase loginUseCase;
  late SignupBloc signupBloc;
  late HomeCubit homeCubit;

  // setUpAll(() {
  //   registerFallbackValue(LoginParams(username: '', password: ''));
  // });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    signupBloc = MockSignupBloc();
    homeCubit = MockHomeCubit();
    loginBloc = LoginBloc(
      signupBloc: signupBloc,
      homeCubit: homeCubit,
      loginUseCase: loginUseCase,
    );
// Add this
    // registerFallbackValue(const LoginParams.empty());
  });

  test('initial state should be LoginState.initial()', () {
    expect(loginBloc.state, equals(const LoginState.initial()));
    expect(loginBloc.state.isLoading, false);
    expect(loginBloc.state.isSuccess, false);
  });

  testWidgets('Check for the email and password in the view', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => loginBloc,
        child: LoginScreenView(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kirtan');
    await tester.enterText(find.byType(TextField).at(1), '1234');

    expect(find.text('kirtan'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
  });

  // Check for the validator error
  testWidgets('Check for the validator error', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => loginBloc,
        child: LoginScreenView(),
      ),
    ));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');

    // await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.tap(find.byType(ElevatedButton).at(0));

    await tester.pumpAndSettle();

    expect(find.text('Please enter email'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  // Check for the login button click
  // Before running this test, comment the Navigator.pushReplacement in the LoginBloc
  testWidgets('Check for the login button click', (tester) async {
    const correctEmail = 'kirtan';
    const correctPassword = '1234';

    when(() => loginUseCase(any())).thenAnswer((invocation) async {
      // As you are using LoginParams, you have to use registerFallbackValue(LoginParams.empty());
      final params = invocation.positionalArguments[0] as LoginParams;
      if (params.email == correctEmail && params.password == correctPassword) {
        return const Right('token');
      } else {
        return const Left(ApiFailure(message: 'Invalid Credentials'));
      }
    });

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => loginBloc,
          child: LoginScreenView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter valid credentials
    await tester.enterText(find.byType(TextField).at(0), correctEmail);
    await tester.enterText(find.byType(TextField).at(1), correctPassword);

    // Tap login
    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}
