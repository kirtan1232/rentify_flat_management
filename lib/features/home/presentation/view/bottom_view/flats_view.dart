import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

class FlatsView extends StatelessWidget {
  const FlatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoomBloc>()..add(FetchRoomsEvent(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Flats'),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.rooms.isEmpty) {
              return const Center(child: Text('No flats available'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return _buildFlatCard(
                  title: room.roomDescription,
                  price: 'Rs.${room.rentPrice}/month',
                  description: '${room.roomDescription} at ${room.address}',
                  rooms: '${room.floor} Floor',
                  furniture: room.parking,
                  bathrooms: room.bathroom.toString(),
                  kitchen:
                      '1', // Assuming 1 kitchen; adjust if your backend provides this
                 imageUrl: room.roomImage != null
    ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
    : '',
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlatCard({
    required String title,
    required String price,
    required String description,
    required String rooms,
    required String furniture,
    required String bathrooms,
    required String kitchen,
    required String imageUrl,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    )
                  : const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
