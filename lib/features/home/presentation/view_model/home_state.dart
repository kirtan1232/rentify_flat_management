import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/flats_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/setting_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state
  static HomeState initial() {
    return const HomeState(
      selectedIndex: 0,
      views: [
        Center(
          child: DashboardView(),
        ),
        Center(
          child: FlatsView(),
        ),
        Center(
          child: SettingView(),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
