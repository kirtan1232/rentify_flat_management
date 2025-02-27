import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/core/app_theme/app_theme.dart';
import 'package:rentify_flat_management/features/home/presentation/view/home_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rentify Flat Management',
      theme: getApplicationTheme(),
      home: BlocProvider.value(
        value: getIt<HomeCubit>(),
        child: const HomeView(),
      ),
    );
  }
}
