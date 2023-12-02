import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/datasources/astronomy_picture_remote_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/repositories/astronomy_picture_repo_impl.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/data_source_exception.dart';
import 'package:astronomy_picture_of_the_day/shared/logger/log_and_left.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAstronomyPictureRemoteDataSource extends Mock
    implements AstronomyPictureRemoteDataSource {}

class MockLogAndLeft extends Mock implements LogAndLeft {}

void main() {
  late MockAstronomyPictureRemoteDataSource mockRemoteDataSource;
  late MockLogAndLeft mockLogger;
  late AstronomyPictureRepoImpl astronomyPictureRepo;

  setUp(() {
    mockRemoteDataSource = MockAstronomyPictureRemoteDataSource();
    mockLogger = MockLogAndLeft();
    astronomyPictureRepo = AstronomyPictureRepoImpl(
      mockRemoteDataSource,
      logger: mockLogger,
    );
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
    registerFallbackValue(const Page.first());
    registerFallbackValue(const PicturesPerPage.seven());
    registerFallbackValue(const AstronomyPictureRetrievalFailure());
    registerFallbackValue(const AstronomyPicturesWithPagination.empty());
    registerFallbackValue(const AstronomyPictureRetrievalFailure());
    registerFallbackValue(StackTrace.current);
  });

  final dateRange = DateRange.parse(
    startDateISO8601: "2023-10-20",
    endDateISO8601: "2023-11-21",
  );
  const page = Page.first();
  const picturesPerPage = PicturesPerPage.seven();
  final totalPictures = TotalPictures.onePicturePerDay(dateRange);
  final lastPage = Page.last(totalPictures, picturesPerPage);

  group('Success:', () {
    test('should return the list of astronomy pictures', () async {
      final pictures = [
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

      final picturesWithPagination = AstronomyPicturesWithPagination(
        currentPage: page,
        lastPage: lastPage,
        totalPictures: totalPictures,
        currentPagePictures: pictures,
      );
      // arrange
      when(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          picturesPerPage: picturesPerPage,
        ),
      ).thenAnswer((_) async => picturesWithPagination);

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        picturesPerPage: picturesPerPage,
      );

      // assert
      // There should be 1 interaction with the Data Source.
      verify(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          picturesPerPage: picturesPerPage,
        ),
      ).called(1);
      // Should return the actual list of astronomy pictures.
      expect(result, equals(Right(picturesWithPagination)));
    });
    test('should return an empty list of astronomy pictures', () async {
      // arrange
      when(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          picturesPerPage: picturesPerPage,
        ),
      ).thenAnswer((_) async => const AstronomyPicturesWithPagination.empty());

      // act
      final result = await astronomyPictureRepo
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page,
        picturesPerPage: picturesPerPage,
      );

      // assert
      // There should be 1 interaction with the Data Source.
      verify(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          picturesPerPage: picturesPerPage,
        ),
      ).called(1);
      // Should return an empty list of astronomy pictures.
      expect(
        result,
        equals(const Right(AstronomyPicturesWithPagination.empty())),
      );
    });
  });

  group('Error:', () {
    test('should log the error and return "AstronomyPictureRetrievalFailure"',
        () async {
      // arrange
      const retrievalFailure = AstronomyPictureRetrievalFailure();
      const dataSourceException =
          DataSourceException('Error while retrieving data');
      when(
        () =>
            mockRemoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          picturesPerPage: picturesPerPage,
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
        picturesPerPage: picturesPerPage,
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
      // Should return "AstronomyPictureRetrievalFailure"
      expect(result, equals(const Left(retrievalFailure)));
    });
  });
}
