import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_cubit.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<dynamic>? _proximitySubscription;
  double _lastX = 0.0;
  static const double _shakeThreshold = 15.0; // Adjust for shake sensitivity
  double _originalBrightness = 0.5; // Store original brightness
  bool _isNearEar = false;
  DateTime? _lastShakeTime; // Track last shake time
  static const int _shakeCooldown = 500; // Cooldown in milliseconds

  // Platform Channel for Proximity Sensor
  static const EventChannel _proximityChannel = EventChannel('proximity_sensor_events');

  @override
  void initState() {
    super.initState();
    _startShakeDetection();
    _startProximityDetection();
    _getCurrentBrightness(); // Store initial brightness
  }

  void _getCurrentBrightness() async {
    try {
      _originalBrightness = await ScreenBrightness().current;
    } catch (e) {
      print('Error getting brightness: $e');
      _originalBrightness = 0.5; // Default fallback
    }
  }

  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      final now = DateTime.now();
      // Check if enough time has passed since the last shake
      if (_lastShakeTime != null && now.difference(_lastShakeTime!).inMilliseconds < _shakeCooldown) {
        return; // Ignore shakes within cooldown period
      }

      final double currentX = event.x;
      final double deltaX = currentX - _lastX;

      // Shake Left -> Next tab (right content)
      if (deltaX < -_shakeThreshold) {
        final currentIndex = context.read<HomeCubit>().state.selectedIndex;
        if (currentIndex < 4) { // Ensure we don't exceed max index (Settings = 4)
          context.read<HomeCubit>().onTabTapped(currentIndex + 1);
          _lastShakeTime = now; // Update last shake time
        }
      }
      // Shake Right -> Previous tab (left content)
      else if (deltaX > _shakeThreshold) {
        final currentIndex = context.read<HomeCubit>().state.selectedIndex;
        if (currentIndex > 0) { // Ensure we don't go below min index (Flats = 0)
          context.read<HomeCubit>().onTabTapped(currentIndex - 1);
          _lastShakeTime = now; // Update last shake time
        }
      }

      _lastX = currentX; // Update last X value
    });
  }

  void _startProximityDetection() {
    _proximitySubscription = _proximityChannel.receiveBroadcastStream().listen((dynamic event) {
      final bool isNear = event == 1; // 1 = near, 0 = far from platform channel
      if (isNear) {
        if (!_isNearEar) {
          _isNearEar = true;
          _setScreenMaxBrightness(); // Increase brightness to max
        }
      } else {
        if (_isNearEar) {
          _isNearEar = false;
          _setScreenOn(); // Restore original brightness
        }
      }
    }, onError: (dynamic error) {
      print('Proximity sensor error: $error');
    });
  }

  Future<void> _setScreenMaxBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(1.0); // Set to maximum brightness
    } catch (e) {
      print('Error setting max brightness: $e');
    }
  }

  Future<void> _setScreenOn() async {
    try {
      await ScreenBrightness().setScreenBrightness(_originalBrightness); // Restore original brightness
    } catch (e) {
      print('Error restoring screen brightness: $e');
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _proximitySubscription?.cancel();
    _setScreenOn(); // Ensure screen brightness is restored on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.views.elementAt(state.selectedIndex);
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.apartment),
                label: "Flats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              context.read<HomeCubit>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}