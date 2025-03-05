import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/auth/data/repository/auth_remote_repository.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/edit_profile.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/location_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/room_detail_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PageController _hotDealsController = PageController(viewportFraction: 0.9);
  final PageController _cheapController = PageController(viewportFraction: 0.9);
  final PageController _expensiveController = PageController(viewportFraction: 0.9);
  static const String _baseUrl = 'http://192.168.101.11:3000';

  @override
  void dispose() {
    _hotDealsController.dispose();
    _cheapController.dispose();
    _expensiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoomBloc>()..add(FetchRoomsEvent(context)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBodyBehindAppBar: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if it's a tablet (e.g., width > 600)
                bool isTablet = constraints.maxWidth > 600;

                return Column(
                  children: [
                    AppBar(
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to Rentify!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Theme.of(context).brightness == Brightness.light
                          ? const Color.fromARGB(255, 77, 187, 117)
                          : Colors.grey[900],
                      actions: [
                        // Profile Picture in AppBar with Navigation
                        FutureBuilder(
                          future: getIt<AuthRemoteRepository>().getCurrentUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              );
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const EditProfile()),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage('assets/images/profile.png'),
                                  ),
                                ),
                              );
                            }

                            final user = snapshot.data!.fold(
                              (failure) => null,
                              (user) => user,
                            );

                            final imageUrl = user?.image != null && user!.image!.isNotEmpty
                                ? '$_baseUrl/uploads/profile/${user.image}'
                                : null;

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfile()),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage('assets/images/profile.png') as ImageProvider,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: BlocConsumer<RoomBloc, RoomState>(
                        listener: (context, state) {
                          if (state.isLoading) {
                            print('RoomBloc State: Loading');
                          } else if (state.error != null) {
                            print('RoomBloc State: Error - ${state.error}');
                          } else {
                            print('RoomBloc State: Loaded - ${state.rooms.length} rooms');
                          }
                        },
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state.error != null) {
                            return Center(child: Text('Error: ${state.error}'));
                          }

                          final hotDealsRooms = state.rooms.toList();
                          final cheapRooms = state.rooms
                              .where((room) => room.rentPrice < 10000)
                              .toList();
                          final expensiveRooms = state.rooms
                              .where((room) => room.rentPrice > 20000)
                              .toList();

                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: isTablet ? 800 : double.infinity),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 40.0 : 16.0,
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Find by Address Section
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? const Color.fromARGB(255, 77, 187, 117)
                                            : Colors.grey.shade800,
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Find by Address',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).brightness == Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildLocationButton(
                                                context: context,
                                                icon: Icons.location_city,
                                                location: 'Kathmandu',
                                                locationName: 'Kathmandu',
                                              ),
                                              _buildLocationButton(
                                                context: context,
                                                icon: Icons.location_city,
                                                location: 'Lalitpur',
                                                locationName: 'Lalitpur',
                                              ),
                                              _buildLocationButton(
                                                context: context,
                                                icon: Icons.location_city,
                                                location: 'Bhaktapur',
                                                locationName: 'Bhaktapur',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Hot Deals Section
                                    _buildSection(
                                      'Hot Deals',
                                      hotDealsRooms,
                                      _hotDealsController,
                                      Theme.of(context).brightness == Brightness.light
                                          ? const Color.fromARGB(255, 77, 187, 117)
                                          : Colors.grey.shade800,
                                    ),

                                    // Sasto Flats Section
                                    _buildSection(
                                      'Sasto Flats',
                                      cheapRooms,
                                      _cheapController,
                                      Theme.of(context).brightness == Brightness.light
                                          ? const Color.fromARGB(255, 77, 187, 117)
                                          : Colors.grey.shade800,
                                    ),

                                    // Commercial Flats Section
                                    _buildSection(
                                      'Commercial Flats',
                                      expensiveRooms,
                                      _expensiveController,
                                      Theme.of(context).brightness == Brightness.light
                                          ? const Color.fromARGB(255, 77, 187, 117)
                                          : Colors.grey.shade800,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<RoomEntity> rooms, PageController controller, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade700,
            width: 1,
          ),
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade300
                : Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: rooms.isEmpty
                ? const Center(child: Text('No rooms available'))
                : PageView.builder(
                    controller: controller,
                    padEnds: true,
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return _buildRoomCard(rooms[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(RoomEntity room) {
    final imageUrl = room.roomImage != null
        ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
        : '';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomDetailView(room: room)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: Container(
                width: 120,
                height: 180,
                color: Colors.grey[200],
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
                      )
                    : const Icon(Icons.home, size: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room.roomDescription,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[600]
                              : Colors.grey[300],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            room.address ?? 'Address not available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[600]
                                  : Colors.grey[300],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs.${room.rentPrice}/month',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton({
    required BuildContext context,
    required IconData icon,
    required String location,
    required String locationName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationView(location: location),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.grey[700],
            child: Icon(
              icon,
              size: 30,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.green[400]
                  : Colors.green[200],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            locationName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}