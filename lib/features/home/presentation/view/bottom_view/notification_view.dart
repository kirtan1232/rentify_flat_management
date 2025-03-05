import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentify_flat_management/app/constants/api_endpoints.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark or light
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<RoomBloc>()..add(FetchRoomsEvent(context)),
      child: Builder(
        builder: (blocContext) {
          final roomBloc = BlocProvider.of<RoomBloc>(blocContext);
          if (roomBloc == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Notifications',
                  style: TextStyle(
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
                'Notifications',
                style: TextStyle(
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

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40.0 : 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's New",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.blueGrey[300] : Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: BlocBuilder<RoomBloc, RoomState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (state.error != null) {
                              return Center(child: Text('Error: ${state.error}'));
                            }
                            if (state.rooms.isEmpty) {
                              return const Center(
                                  child: Text('No new rooms available'));
                            }
                            return ListView.builder(
                              itemCount: state.rooms.length,
                              itemBuilder: (context, index) {
                                final room = state.rooms[index];
                                final imageUrl = room.roomImage != null
                                    ? '${ApiEndpoints.imageUrl}${room.roomImage!.split(RegExp(r'[\\/]')).last}'
                                    : '';
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Image load error: $error');
                                              return const Icon(Icons.home);
                                            },
                                          )
                                        : const Icon(Icons.home),
                                    title: Text(
                                      room.roomDescription,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Price: Rs.${room.rentPrice}',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}