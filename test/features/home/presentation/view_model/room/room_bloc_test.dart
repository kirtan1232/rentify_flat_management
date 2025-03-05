import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rentify_flat_management/features/home/domain/entity/room_entity.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/add_to_wishlist_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_all_room_usecase.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/get_wishlist.dart';
import 'package:rentify_flat_management/features/home/domain/usecase/remove_from_wishlist_usecase.dart';
import 'package:rentify_flat_management/features/home/presentation/view_model/room/room_bloc.dart';

// Mock Use Cases
class MockGetAllRoomsUseCase extends Mock implements GetAllRoomsUseCase {}
class MockAddToWishlistUseCase extends Mock implements AddToWishlistUseCase {}
class MockGetWishlistUseCase extends Mock implements GetWishlistUseCase {}
class MockRemoveFromWishlistUseCase extends Mock implements RemoveFromWishlistUseCase {}

// Mock BuildContext for testing
class BuildContextMock extends Mock implements BuildContext {}

// Fake Type for registerFallbackValue
class TypeFake extends Fake implements Type {}

void main() {
  late RoomBloc roomBloc;
  late MockGetAllRoomsUseCase mockGetAllRoomsUseCase;
  late MockAddToWishlistUseCase mockAddToWishlistUseCase;
  late MockGetWishlistUseCase mockGetWishlistUseCase;
  late MockRemoveFromWishlistUseCase mockRemoveFromWishlistUseCase;
  late BuildContextMock context;

  // Sample data with all required fields
  const room1 = RoomEntity(
    id: '1',
    roomDescription: 'Cozy room with a view',
    floor: 2,
    address: '123 Main St',
    rentPrice: 500.0,
    parking: 'Yes',
    contactNo: '123-456-7890',
    bathroom: 1,
    roomImage: 'room1.jpg',
    isWishlisted: false,
  );
  const room2 = RoomEntity(
    id: '2',
    roomDescription: 'Spacious room',
    floor: 1,
    address: '456 Oak St',
    rentPrice: 600.0,
    parking: 'No',
    contactNo: '987-654-3210',
    bathroom: 2,
    roomImage: 'room2.jpg',
    isWishlisted: false,
  );
  final rooms = [room1, room2];
  final wishlist = [room1.copyWith(isWishlisted: true)];

  setUpAll(() {
    // Register fallback value for Type
    registerFallbackValue(TypeFake());
  });

  setUp(() {
    mockGetAllRoomsUseCase = MockGetAllRoomsUseCase();
    mockAddToWishlistUseCase = MockAddToWishlistUseCase();
    mockGetWishlistUseCase = MockGetWishlistUseCase();
    mockRemoveFromWishlistUseCase = MockRemoveFromWishlistUseCase();
    context = BuildContextMock();

    // Stub context properties to avoid runtime errors with ScaffoldMessenger
    when(() => context.widget).thenReturn(const Scaffold());
    when(() => context.describeMissingAncestor(expectedAncestorType: any(named: 'expectedAncestorType')))
        .thenReturn([]);

    roomBloc = RoomBloc(
      mockGetAllRoomsUseCase,
      mockAddToWishlistUseCase,
      mockGetWishlistUseCase,
      mockRemoveFromWishlistUseCase,
    );

    // Register fallback values for mocktail
    registerFallbackValue(const AddToWishlistParams('1'));
    registerFallbackValue(const RemoveFromWishlistParams('1'));
    registerFallbackValue(const AddToWishlistParams('2'));
    registerFallbackValue(const RemoveFromWishlistParams('2'));
  });

  tearDown(() {
    roomBloc.close();
  });

  group('RoomBloc', () {
    // Existing test for FetchRoomsEvent
    blocTest<RoomBloc, RoomState>(
      'loads all rooms and syncs wishlist with FetchRoomsEvent',
      build: () {
        when(() => mockGetAllRoomsUseCase())
            .thenAnswer((_) async => Right(rooms));
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc;
      },
      act: (bloc) => bloc.add(FetchRoomsEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
    );

    // Existing test for FetchWishlistEvent
    blocTest<RoomBloc, RoomState>(
      'updates room wishlist status with FetchWishlistEvent',
      build: () {
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc..emit(const RoomState.initial().copyWith(rooms: rooms));
      },
      act: (bloc) => bloc.add(FetchWishlistEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(rooms: rooms, isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
    );

    // Existing test for FetchRoomsEvent focusing on floor and roomDescription
    blocTest<RoomBloc, RoomState>(
      'fetches floor and roomDescription data with FetchRoomsEvent',
      build: () {
        when(() => mockGetAllRoomsUseCase())
            .thenAnswer((_) async => Right(rooms));
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc;
      },
      act: (bloc) => bloc.add(FetchRoomsEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].floor, 2); // Verify floor for room1
        expect(state.rooms[0].roomDescription, 'Cozy room with a view'); // Verify roomDescription for room1
        expect(state.rooms[1].floor, 1); // Verify floor for room2
        expect(state.rooms[1].roomDescription, 'Spacious room'); // Verify roomDescription for room2
        verify(() => mockGetAllRoomsUseCase()).called(1);
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );

    // Existing test for FetchWishlistEvent focusing on floor and roomDescription
    blocTest<RoomBloc, RoomState>(
      'syncs floor and roomDescription with wishlist via FetchWishlistEvent',
      build: () {
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc..emit(const RoomState.initial().copyWith(rooms: rooms));
      },
      act: (bloc) => bloc.add(FetchWishlistEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(rooms: rooms, isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].floor, 2); // Verify floor for room1
        expect(state.rooms[0].roomDescription, 'Cozy room with a view'); // Verify roomDescription for room1
        expect(state.rooms[1].floor, 1); // Verify floor for room2
        expect(state.rooms[1].roomDescription, 'Spacious room'); // Verify roomDescription for room2
        expect(state.wishlist[0].floor, 2); // Verify floor for wishlisted room1
        expect(state.wishlist[0].roomDescription, 'Cozy room with a view'); // Verify roomDescription for wishlisted room1
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );

    // New test for FetchRoomsEvent focusing on rentPrice and parking
    blocTest<RoomBloc, RoomState>(
      'retrieves rentPrice and parking details with FetchRoomsEvent',
      build: () {
        when(() => mockGetAllRoomsUseCase())
            .thenAnswer((_) async => Right(rooms));
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc;
      },
      act: (bloc) => bloc.add(FetchRoomsEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].rentPrice, 500.0); // Verify rentPrice for room1
        expect(state.rooms[0].parking, 'Yes'); // Verify parking for room1
        expect(state.rooms[1].rentPrice, 600.0); // Verify rentPrice for room2
        expect(state.rooms[1].parking, 'No'); // Verify parking for room2
        verify(() => mockGetAllRoomsUseCase()).called(1);
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );

    // New test for FetchWishlistEvent focusing on rentPrice and parking
    blocTest<RoomBloc, RoomState>(
      'updates rentPrice and parking with wishlist via FetchWishlistEvent',
      build: () {
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc..emit(const RoomState.initial().copyWith(rooms: rooms));
      },
      act: (bloc) => bloc.add(FetchWishlistEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(rooms: rooms, isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].rentPrice, 500.0); // Verify rentPrice for room1
        expect(state.rooms[0].parking, 'Yes'); // Verify parking for room1
        expect(state.rooms[1].rentPrice, 600.0); // Verify rentPrice for room2
        expect(state.rooms[1].parking, 'No'); // Verify parking for room2
        expect(state.wishlist[0].rentPrice, 500.0); // Verify rentPrice for wishlisted room1
        expect(state.wishlist[0].parking, 'Yes'); // Verify parking for wishlisted room1
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );

    // New test for FetchRoomsEvent focusing on bathroom and roomImage
    blocTest<RoomBloc, RoomState>(
      'loads bathroom and roomImage data with FetchRoomsEvent',
      build: () {
        when(() => mockGetAllRoomsUseCase())
            .thenAnswer((_) async => Right(rooms));
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc;
      },
      act: (bloc) => bloc.add(FetchRoomsEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].bathroom, 1); // Verify bathroom for room1
        expect(state.rooms[0].roomImage, 'room1.jpg'); // Verify roomImage for room1
        expect(state.rooms[1].bathroom, 2); // Verify bathroom for room2
        expect(state.rooms[1].roomImage, 'room2.jpg'); // Verify roomImage for room2
        verify(() => mockGetAllRoomsUseCase()).called(1);
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );

    // New test for FetchWishlistEvent focusing on bathroom and roomImage
    blocTest<RoomBloc, RoomState>(
      'syncs bathroom and roomImage with wishlist via FetchWishlistEvent',
      build: () {
        when(() => mockGetWishlistUseCase())
            .thenAnswer((_) async => Right(wishlist));
        return roomBloc..emit(const RoomState.initial().copyWith(rooms: rooms));
      },
      act: (bloc) => bloc.add(FetchWishlistEvent(context)),
      expect: () => [
        const RoomState.initial().copyWith(rooms: rooms, isLoading: true),
        const RoomState.initial().copyWith(
          isLoading: false,
          rooms: [
            room1.copyWith(isWishlisted: true),
            room2.copyWith(isWishlisted: false),
          ],
          wishlist: wishlist,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.rooms[0].bathroom, 1); // Verify bathroom for room1
        expect(state.rooms[0].roomImage, 'room1.jpg'); // Verify roomImage for room1
        expect(state.rooms[1].bathroom, 2); // Verify bathroom for room2
        expect(state.rooms[1].roomImage, 'room2.jpg'); // Verify roomImage for room2
        expect(state.wishlist[0].bathroom, 1); // Verify bathroom for wishlisted room1
        expect(state.wishlist[0].roomImage, 'room1.jpg'); // Verify roomImage for wishlisted room1
        verify(() => mockGetWishlistUseCase()).called(1);
      },
    );
  });
}