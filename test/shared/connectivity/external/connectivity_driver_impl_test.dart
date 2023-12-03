import 'package:astronomy_picture_of_the_day/shared/connectivity/external/drivers/connectivity_driver_impl.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/driver_exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockInternetConnection mockInternet;
  late ConnectivityDriverImpl connDriver;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockInternet = MockInternetConnection();
    connDriver = ConnectivityDriverImpl(mockConnectivity, mockInternet);
  });
  group('when there is no connection,', () {
    setUp(() {
      // no connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.none));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "false" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verifyNever(() => mockInternet.hasInternetAccess);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);

        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verifyNever(() => mockInternet.hasInternetAccess);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to bluetooth,', () {
    setUp(() {
      // bluetooth connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.bluetooth));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to wi-fi,', () {
    setUp(() {
      // wi-fi connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.wifi));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to ethernet,', () {
    setUp(() {
      // ethernet connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.ethernet));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to mobile,', () {
    setUp(() {
      // mobile connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.mobile));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to a VPN,', () {
    setUp(() {
      // VPN connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.vpn));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('when connected to another type of network,', () {
    setUp(() {
      // Other connection
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.other));
    });
    group('method "hasActiveIntenetConnection"', () {
      test('should return "true" when data can be sent', () async {
        // internet access.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => true);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, true);
      });
      test('should return "false" when data cannot be sent', () async {
        // no internet access, regardless of being connected to a network.
        when(() => mockInternet.hasInternetAccess)
            .thenAnswer((_) async => false);
        // act
        final result = await connDriver.hasActiveInternetConnection;

        // assert
        verify(() => mockInternet.hasInternetAccess).called(1);
        verify(() => mockConnectivity.onConnectivityChanged).called(1);
        expect(result, false);
      });
    });
  });
  group('error handling should catch exception and rethrow "DriverException"',
      () {
    final exception = Exception('Operation error');
    test('method "onConnectivityChanged"', () async {
      // arrange
      bool driverExceptionWasThrown = false;
      when(() => mockConnectivity.onConnectivityChanged).thenThrow(exception);

      // act
      try {
        await connDriver.hasActiveInternetConnection;
      } on DriverException catch (ex) {
        driverExceptionWasThrown = true;
        // Must keep the same instance of the exception that signalled the failure.
        expect(ex.exception, same(exception));
      }
      assert(driverExceptionWasThrown, true);
    });
    test('method "hasInternetAccess"', () async {
      // arrange
      bool driverExceptionWasThrown = false;
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value(ConnectivityResult.wifi));
      when(() => mockInternet.hasInternetAccess).thenThrow(exception);

      // Act
      try {
        await connDriver.hasActiveInternetConnection;
      } on DriverException catch (ex) {
        driverExceptionWasThrown = true;
        // Must keep the same instance of the exception that signalled the failure.
        expect(ex.exception, same(exception));
      }
      assert(driverExceptionWasThrown, true);
    });
  });
}
