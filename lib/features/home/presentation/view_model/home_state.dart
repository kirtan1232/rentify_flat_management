// lib/features/home/presentation/view_model/home_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/flats_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/notification_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/setting_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/wishlist_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  factory HomeState.initial() => const HomeState(
        selectedIndex: 2, // Changed to 2 for Home (DashboardView)
        views: [
          FlatsView(),         // Index 0
          WishlistView(),      // Index 1
          DashboardView(),     // Index 2 (Home)
          NotificationsView(), // Index 3
          SettingView(),       // Index 4
        ],
      );

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views,
    );
  }

  @override
  List<Object> get props => [selectedIndex, views];
}