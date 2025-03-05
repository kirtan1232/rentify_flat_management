import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rentify_flat_management/app/di/di.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/presentation/view/bottom_view/flats_view.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

// Mock classes
@GenerateMocks([RoomBloc]) // Removed NavigatorObserver from here
import 'flats_view_test.mocks.dart'; // Ensure this is generated

void main() {
  late MockRoomBloc mockRoomBloc;
  // late MockNavigatorObserver mockNavigatorObserver; // Removed
  late StreamController<RoomState> roomStateController;

  setUp(() {
    mockRoomBloc = MockRoomBloc();
    // mockNavigatorObserver = MockNavigatorObserver(); // Removed
    roomStateController = StreamController<RoomState>.broadcast();

    when(mockRoomBloc.stream).thenAnswer((_) => roomStateController.stream);
    when(mockRoomBloc.state).thenReturn(const RoomState.initial());

    // Register mocks with getIt (if your app uses it)
    getIt.registerSingleton<RoomBloc>(mockRoomBloc);
  });

  tearDown(() {
    roomStateController.close();
    getIt.reset(); // Clean up getIt after each test
  });

  Widget buildTestWidget({RoomState? initialState}) {
    // Set initial state if provided
    if (initialState != null) {
      when(mockRoomBloc.state).thenReturn(initialState);
    }

    return MaterialApp(
      home: BlocProvider<RoomBloc>(
        create: (_) => mockRoomBloc,
        child: const FlatsView(),
      ),
      // navigatorObservers: [mockNavigatorObserver], // Removed this line
    );
  }

  testWidgets('FlatsView renders initial UI correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Flats View'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search for flats by address...'), findsOneWidget);
  });

  testWidgets('FlatsView shows error message when state has an error',
      (WidgetTester tester) async {
    const errorState = RoomState(
        isLoading: false,
        rooms: [],
        error: 'Failed to fetch rooms',
        wishlist: []);
    await tester.pumpWidget(buildTestWidget(initialState: errorState));
    await tester.pumpAndSettle();

    expect(find.text('Error: Failed to fetch rooms'), findsOneWidget);
  });

  testWidgets('FlatsView dispatches AddToWishlistEvent on wishlist icon tap',
      (WidgetTester tester) async {
    final rooms = [
      const RoomEntity(
          id: '1',
          roomDescription: 'Cozy Apartment',
          address: '123 Main St',
          rentPrice: 1000,
          floor: 2,
          bathroom: 1,
          parking: 'Yes',
          isWishlisted: false,
          roomImage: 'image1.jpg',
          contactNo: ''),
    ];
    final loadedState = RoomState(
        isLoading: false, rooms: rooms, error: null, wishlist: const []);
    await tester.pumpWidget(buildTestWidget(initialState: loadedState));
    await tester.pumpAndSettle();

    // Tap the wishlist icon
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    // Verify that AddToWishlistEvent is dispatched
    verify(mockRoomBloc.add(argThat(
            isA<AddToWishlistEvent>().having((e) => e.roomId, 'roomId', '1'))))
        .called(1);
  });
}
