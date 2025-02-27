// lib/features/room/presentation/views/wishlist_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';


class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoomBloc>()..add(FetchWishlistEvent(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wishlist'),
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
            if (state.wishlist.isEmpty) {
              return const Center(child: Text('No items in wishlist'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.wishlist.length,
              itemBuilder: (context, index) {
                final room = state.wishlist[index];
                final imageUrl = room.roomImage != null
                    ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
                    : '';
                return _buildWishlistCard(
                  context: context,
                  title: room.roomDescription,
                  price: 'Rs.${room.rentPrice}/month',
                  description: '${room.roomDescription} at ${room.address}',
                  imageUrl: imageUrl,
                  roomId: room.id!,
                  isWishlisted: room.isWishlisted,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistCard({
    required BuildContext context,
    required String title,
    required String price,
    required String description,
    required String imageUrl,
    required String roomId,
    required bool isWishlisted,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                    )
                  : const Icon(Icons.image, size: 100),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          Icons.favorite,
                          color: Colors.red, // Always red in wishlist
                        ),
                        onPressed: () {
                          context.read<RoomBloc>().add(RemoveFromWishlistEvent(roomId, context));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(price),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}