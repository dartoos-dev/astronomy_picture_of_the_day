import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/datasources/astronomy_picture_local_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/datasources/astronomy_picture_remote_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/repositories/astronomy_picture_repo_impl.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:astronomy_picture_of_the_day/shared/connectivity/data/drivers/connectivity_driver.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/data_source_exception.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/driver_exception.dart';
import 'package:astronomy_picture_of_the_day/shared/logger/log_and_left.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAstronomyPictureRemoteDataSource extends Mock
    implements AstronomyPictureRemoteDataSource {}

class MockAstronomyPictureLocalDataSource extends Mock
    implements AstronomyPictureLocalDataSource {}

class MockConnectivityDriver extends Mock implements ConnectivityDriver {}

class MockLogAndLeft extends Mock implements LogAndLeft {}

void main() {
  late MockAstronomyPictureRemoteDataSource mockRemoteDataSource;
  late MockAstronomyPictureLocalDataSource mockLocalDataSource;
  late MockConnectivityDriver mockConnectivityDriver;
  late MockLogAndLeft mockLogger;
  late AstronomyPictureRepoImpl astronomyPictureRepo;

  setUp(() {
    mockRemoteDataSource = MockAstronomyPictureRemoteDataSource();
    mockLocalDataSource = MockAstronomyPictureLocalDataSource();
    mockConnectivityDriver = MockConnectivityDriver();
    mockLogger = MockLogAndLeft();
    astronomyPictureRepo = AstronomyPictureRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivityDriver: mockConnectivityDriver,
      logger: mockLogger,
    );
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
    registerFallbackValue(const Page.first());
    registerFallbackValue(const PicturesPerPage.seven());
    registerFallbackValue(const RetrievalFailure());
    registerFallbackValue(const AstronomyPicturesWithPagination.empty());
    registerFallbackValue(const RetrievalFailure());
    registerFallbackValue(StackTrace.current);
  });

  final dateRange = DateRange.parse(
    startDateISO8601: "2023-10-20",
    endDateISO8601: "2023-11-21",
  );
  const page = Page.first();
  const perPage = PicturesPerPage.seven();
  final totalPictures = TotalPictures.onePicturePerDay(dateRange);
  final lastPage = Page.last(totalPictures, perPage);

  group('Successful load of pictures from local storage', () {
    late List<AstronomyPicture> localPictures;
    late AstronomyPicturesWithPagination localPicturesWithPagination;
    setUp(() {
      // forces to get pictures from local storage
      when(() => mockLocalDataSource.containsPictures(any(), any(), any()))
          .thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).thenAnswer((_) async => localPicturesWithPagination);
    });
    // verifications that should be true for all test cases of this group.
    tearDown(() {
      // There should be 1 interaction with the Local Data Source.
      verify(
        () => mockLocalDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).called(1);
      // There should be no connection check
      verifyNever(() => mockConnectivityDriver.hasActiveInternetConnection);

      // Should not have tried to get pictures from Remote Data Source.
      verifyNever(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          any(),
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      );
    });
    test('should return the list of astronomy pictures', () async {
      localPictures = [
        AstronomyPicture(
          date: DateTime.parse("2023-11-20"),
          explanation: 'Blah blah blah',
          title: 'An Astronomy Picture',
          mediumDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_960.jpg',
          ),
          highDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_1752.jpg',
          ),
        ),
      ];

      localPicturesWithPagination = AstronomyPicturesWithPagination(
        currentPage: page,
        lastPage: lastPage,
        totalPictures: totalPictures,
        currentPagePictures: localPictures,
      );

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // Should return the actual list of astronomy pictures.
      expect(result, equals(Right(localPicturesWithPagination)));
    });
    test('should return an empty list of astronomy pictures', () async {
      // arrange
      localPicturesWithPagination =
          const AstronomyPicturesWithPagination.empty();
      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // Should return an empty list of astronomy pictures.
      expect(
        result,
        equals(const Right(AstronomyPicturesWithPagination.empty())),
      );
    });
  });
  group('Successful load of pictures from remote server', () {
    late List<AstronomyPicture> remotePictures;
    late AstronomyPicturesWithPagination remotePicturesWithPagination;
    setUp(() {
      // forces to get pictures from remote server
      when(() => mockLocalDataSource.containsPictures(any(), any(), any()))
          .thenAnswer((_) async => false);
      // must have an active connection
      when(() => mockConnectivityDriver.hasActiveInternetConnection)
          .thenAnswer((_) async => true);
      // enables caching on local storage
      void voidPlaceholder;
      when(() => mockLocalDataSource.saveAstronomyPictures(any()))
          .thenAnswer((_) async => voidPlaceholder);
      when(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).thenAnswer((_) async => remotePicturesWithPagination);
    });
    // verifications that should be true for all test cases of this group.
    tearDown(() {
      final capturedArgument = verify(
        () => mockLocalDataSource.saveAstronomyPictures(captureAny()),
      ).captured;
      // must cache the exactly same pictures.
      expect(capturedArgument.first, equals(remotePictures));
      // There should be 1 interaction with the Remote Data Source.
      verify(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).called(1);
      // There should be 1 connection check
      verify(() => mockConnectivityDriver.hasActiveInternetConnection)
          .called(1);

      // Should not have tried to get pictures from Local Data Source.
      verifyNever(
        () => mockLocalDataSource.getAstronomyPicturesWithPaginationByDateRange(
          any(),
          page: any(named: "perPage"),
          perPage: any(named: "perPage"),
        ),
      );
    });
    test('should cache and return the list of astronomy pictures', () async {
      remotePictures = [
        AstronomyPicture(
          date: DateTime.parse("2023-11-20"),
          explanation: 'Blah blah blah',
          title: 'An Astronomy Picture',
          mediumDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_960.jpg',
          ),
          highDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_1752.jpg',
          ),
        ),
      ];

      remotePicturesWithPagination = AstronomyPicturesWithPagination(
        currentPage: page,
        lastPage: lastPage,
        totalPictures: totalPictures,
        currentPagePictures: remotePictures,
      );

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // Should return the actual list of astronomy pictures.
      expect(result, equals(Right(remotePicturesWithPagination)));
    });
    test('should return an empty list of astronomy pictures', () async {
      // arrange
      remotePictures = const [];
      remotePicturesWithPagination =
          const AstronomyPicturesWithPagination.empty();
      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // Should return an empty list of astronomy pictures.
      expect(
        result,
        equals(const Right(AstronomyPicturesWithPagination.empty())),
      );
    });
  });
  group('Local data source error:', () {
    test('should log and return "RetrievalFailure" enum', () async {
      // arrange
      const retrievalFailure = RetrievalFailure();
      const dataSourceException =
          DataSourceException('Error while retrieving data from local storage');

      when(() => mockLocalDataSource.containsPictures(any(), any(), any()))
          .thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      ).thenAnswer((_) async => throw dataSourceException);
      when(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          retrievalFailure,
          message: any(named: "message"),
          exception: dataSourceException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).thenAnswer((_) => const Left(retrievalFailure));

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with the logger.
      verify(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          retrievalFailure,
          message: any(named: "message"),
          exception: dataSourceException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).called(1);

      expect(result, equals(const Left(retrievalFailure)));
    });
  });

  group('Remote data source error:', () {
    test('should log and return "RetrievalFailure" enum', () async {
      // arrange
      const retrievalFailure = RetrievalFailure();
      const dataSourceException =
          DataSourceException('Error while retrieving data from server');

      // forces to get data from remote data source.
      when(() => mockLocalDataSource.containsPictures(any(), any(), any()))
          .thenAnswer((_) async => false);
      // must have an active connection
      when(() => mockConnectivityDriver.hasActiveInternetConnection)
          .thenAnswer((_) async => true);
      when(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      ).thenAnswer((_) async => throw dataSourceException);
      when(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          retrievalFailure,
          message: any(named: "message"),
          exception: dataSourceException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).thenAnswer((_) => const Left(retrievalFailure));

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with the logger.
      verify(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          retrievalFailure,
          message: any(named: "message"),
          exception: dataSourceException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).called(1);

      expect(result, equals(const Left(retrievalFailure)));
    });
  });

  group('Connection check error:', () {
    test('should log and return "ConnectionCheckFailure" enum', () async {
      // arrange
      const connectionCheckFailure = ConnectionCheckFailure();
      const driverException =
          DriverException('Error while checking the connection status');

      // forces the repo to check for the connection status.
      when(() => mockLocalDataSource.containsPictures(any(), any(), any()))
          .thenAnswer((_) async => false);
      // connection check error
      when(() => mockConnectivityDriver.hasActiveInternetConnection)
          .thenAnswer((_) async => throw driverException);
      when(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          connectionCheckFailure,
          message: any(named: "message"),
          exception: driverException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).thenAnswer((_) => const Left(connectionCheckFailure));

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with the logger.
      verify(
        () => mockLogger
            .call<AstronomyPictureFailure, AstronomyPicturesWithPagination>(
          connectionCheckFailure,
          message: any(named: "message"),
          exception: driverException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).called(1);

      expect(result, equals(const Left(connectionCheckFailure)));
    });
  });
}
