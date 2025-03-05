import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/room_detail_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

class FlatsView extends StatefulWidget {
  const FlatsView({super.key});

  @override
  State<FlatsView> createState() => _FlatsViewState();
}

class _FlatsViewState extends State<FlatsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Holds the submitted search query

  @override
  void initState() {
    super.initState();
    // Remove the listener since we don’t want real-time updates
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark or light
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<RoomBloc>(),
      child: Builder(
        builder: (blocContext) {
          final roomBloc = BlocProvider.of<RoomBloc>(blocContext);
          if (roomBloc != null) {
            roomBloc.add(FetchRoomsEvent(blocContext));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Flats View',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? const Color(0xff00FF00) : Colors.white,
                  ),
                ),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).brightness == Brightness.light
                    ? const Color.fromARGB(255, 77, 187, 117)
                    : Colors.black,
              ),
              body: const Center(
                child: Text('Error: RoomBloc is not available'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Flats View',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? const Color(0xff00FF00) : Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromARGB(255, 77, 187, 117)
                  : Colors.black,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if it's a tablet (e.g., width > 600)
                bool isTablet = constraints.maxWidth > 600;

                return BlocBuilder<RoomBloc, RoomState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    // Filter rooms only based on the submitted _searchQuery
                    final filteredRooms = state.rooms.where((room) {
                      return _searchQuery.isEmpty ||
                          room.address.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isTablet ? 800 : double.infinity),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 40.0 : 16.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.grey[200]
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Theme.of(context).dividerColor),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search for flats by address...',
                                      border: InputBorder.none,
                                      icon: Icon(Icons.search),
                                    ),
                                    onSubmitted: (value) {
                                      // Update _searchQuery only when Enter is pressed
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredRooms.length,
                                itemBuilder: (context, index) {
                                  final room = filteredRooms[index];
                                  final imageUrl = room.roomImage != null
                                      ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
                                      : '';
                                  return _buildFlatCard(
                                    context: context,
                                    room: room,
                                    title: room.roomDescription,
                                    price: 'Rs.${room.rentPrice}/month',
                                    description: '${room.roomDescription} at ${room.address}',
                                    rooms: '${room.floor} Floor',
                                    furniture: room.parking ?? 'Not specified',
                                    bathrooms: room.bathroom.toString(),
                                    kitchen: '1',
                                    imageUrl: imageUrl,
                                    roomId: room.id!,
                                    isWishlisted: room.isWishlisted ?? false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlatCard({
    required BuildContext context,
    required RoomEntity room,
    required String title,
    required String price,
    required String description,
    required String rooms,
    required String furniture,
    required String bathrooms,
    required String kitchen,
    required String imageUrl,
    required String roomId,
    required bool isWishlisted,
  }) {
    print('Image URL: $imageUrl');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomDetailView(room: room),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageUrl.isNotEmpty
                    ? Center(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            print('Image load error: $error');
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                      )
                    : const Icon(Icons.image, size: 100),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: isWishlisted ? Colors.red : null,
                    ),
                    onPressed: () {
                      final roomBloc = context.read<RoomBloc>();
                      if (roomBloc != null) {
                        if (isWishlisted) {
                          roomBloc.add(RemoveFromWishlistEvent(roomId, context));
                        } else {
                          roomBloc.add(AddToWishlistEvent(roomId, context));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('RoomBloc is not available')),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(price),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoTile(icon: Icons.bed, label: rooms),
                  _buildInfoTile(icon: Icons.shower, label: bathrooms),
                  _buildInfoTile(icon: Icons.kitchen, label: kitchen),
                ],
              ),
              const SizedBox(height: 8),
              Text(furniture),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}