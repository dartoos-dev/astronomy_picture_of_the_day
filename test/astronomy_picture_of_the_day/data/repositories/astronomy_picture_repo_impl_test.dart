import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/datasources/astronomy_picture_remote_data_source.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/repositories/astronomy_picture_repo_impl.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
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
    registerFallbackValue(const AstronomyPictureRetrievalFailure());
    registerFallbackValue(StackTrace.current);
  });

  final dateRange = DateRange.single(DateTime.now());

  group('Success:', () {
    test('should return the list of astronomy pictures', () async {
      final astronomyPictures = [
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
      // arrange
      when(
        () => mockRemoteDataSource.getAstronomyPicturesByDateRange(dateRange),
      ).thenAnswer((_) async => astronomyPictures);

      // act
      final result =
          await astronomyPictureRepo.getAstronomyPicturesByDateRange(dateRange);

      // assert
      // There should be 1 interaction with the Data Source.
      verify(
        () => mockRemoteDataSource.getAstronomyPicturesByDateRange(dateRange),
      ).called(1);
      // Should return the actual list of astronomy pictures.
      expect(result, equals(Right(astronomyPictures)));
    });
    test('should return an empty list of astronomy pictures', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getAstronomyPicturesByDateRange(dateRange),
      ).thenAnswer((_) async => const <AstronomyPicture>[]);

      // act
      final result =
          await astronomyPictureRepo.getAstronomyPicturesByDateRange(dateRange);

      // assert
      // There should be 1 interaction with the Data Source.
      verify(
        () => mockRemoteDataSource.getAstronomyPicturesByDateRange(dateRange),
      ).called(1);
      // Should return an empty list of astronomy pictures.
      expect(result, equals(const Right(<AstronomyPicture>[])));
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
        () => mockRemoteDataSource.getAstronomyPicturesByDateRange(dateRange),
      ).thenAnswer((_) async => throw dataSourceException);
      when(
        () => mockLogger.call<AstronomyPictureFailure, List<AstronomyPicture>>(
          retrievalFailure,
          message: any(named: "message"),
          exception: dataSourceException,
          stacktrace: any(named: "stacktrace"),
        ),
      ).thenAnswer((_) => const Left(retrievalFailure));

      // act
      final result =
          await astronomyPictureRepo.getAstronomyPicturesByDateRange(dateRange);

      // assert
      // There should be 1 interaction with the logger.
      verify(
        () => mockLogger.call<AstronomyPictureFailure, List<AstronomyPicture>>(
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
