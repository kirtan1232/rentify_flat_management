import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PageController _hotDealsController = PageController(viewportFraction: 0.8);
  final PageController _cheapController = PageController(viewportFraction: 0.8);
  final PageController _expensiveController = PageController(viewportFraction: 0.8);

  // Use ValueNotifiers to track real-time page positions
  final ValueNotifier<double> _hotDealsPosition = ValueNotifier(0.0);
  final ValueNotifier<double> _cheapPosition = ValueNotifier(0.0);
  final ValueNotifier<double> _expensivePosition = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _hotDealsController.addListener(() {
      _hotDealsPosition.value = _hotDealsController.page ?? 0.0;
    });
    _cheapController.addListener(() {
      _cheapPosition.value = _cheapController.page ?? 0.0;
    });
    _expensiveController.addListener(() {
      _expensivePosition.value = _expensiveController.page ?? 0.0;
    });
  }

  @override
  void dispose() {
    _hotDealsController.dispose();
    _cheapController.dispose();
    _expensiveController.dispose();
    _hotDealsPosition.dispose();
    _cheapPosition.dispose();
    _expensivePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoomBloc>(),
      child: Builder(
        builder: (blocContext) {
          BlocProvider.of<RoomBloc>(blocContext).add(FetchRoomsEvent(blocContext));
          return Scaffold(
            appBar: AppBar(
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Rentify!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: BlocBuilder<RoomBloc, RoomState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                final hotDealsRooms = state.rooms.take(3).toList();
                final cheapRooms = state.rooms
                    .where((room) => room.rentPrice < 10000)
                    .take(3)
                    .toList();
                final expensiveRooms = state.rooms
                    .where((room) => room.rentPrice > 20000)
                    .take(3)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hot Deals Section in a Frame
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hot Deals',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 180,
                                child: hotDealsRooms.isEmpty
                                    ? const Center(child: Text('No rooms available'))
                                    : PageView.builder(
                                        controller: _hotDealsController,
                                        itemCount: hotDealsRooms.length,
                                        itemBuilder: (context, index) {
                                          return ValueListenableBuilder<double>(
                                            valueListenable: _hotDealsPosition,
                                            builder: (context, position, child) {
                                              final diff = (index - position).abs();
                                              final scale = (1 - (diff * 0.2)).clamp(0.8, 1.0);
                                              return Transform.scale(
                                                scale: scale,
                                                child: _buildRoomCard(hotDealsRooms[index]),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sasto Flats Section in a Frame
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sasto Flats',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 180,
                                child: cheapRooms.isEmpty
                                    ? const Center(child: Text('No cheap rooms available'))
                                    : PageView.builder(
                                        controller: _cheapController,
                                        itemCount: cheapRooms.length,
                                        itemBuilder: (context, index) {
                                          return ValueListenableBuilder<double>(
                                            valueListenable: _cheapPosition,
                                            builder: (context, position, child) {
                                              final diff = (index - position).abs();
                                              final scale = (1 - (diff * 0.2)).clamp(0.8, 1.0);
                                              return Transform.scale(
                                                scale: scale,
                                                child: _buildRoomCard(cheapRooms[index]),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Commercial Flats Section in a Frame
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commercial Flats',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 180,
                                child: expensiveRooms.isEmpty
                                    ? const Center(child: Text('No expensive rooms available'))
                                    : PageView.builder(
                                        controller: _expensiveController,
                                        itemCount: expensiveRooms.length,
                                        itemBuilder: (context, index) {
                                          return ValueListenableBuilder<double>(
                                            valueListenable: _expensivePosition,
                                            builder: (context, position, child) {
                                              final diff = (index - position).abs();
                                              final scale = (1 - (diff * 0.2)).clamp(0.8, 1.0);
                                              return Transform.scale(
                                                scale: scale,
                                                child: _buildRoomCard(expensiveRooms[index]),
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildRoomCard(RoomEntity room) {
    final imageUrl = room.roomImage != null
        ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
        : '';
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.home,
                        size: 50,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 50, color: Colors.white),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.roomDescription,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Address: ${room.address}',
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Price: Rs.${room.rentPrice}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}