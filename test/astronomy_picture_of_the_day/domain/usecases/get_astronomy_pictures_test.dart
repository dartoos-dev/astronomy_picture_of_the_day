import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/repositories/astronomy_picture_repo.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/usecases/get_astronomy_pictures_by_date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAstronomyPictureRepo extends Mock implements AstronomyPictureRepo {}

class MockAstronomyPicturePresenter extends Mock
    implements AstronomyPicturePresenter {}

void main() {
  late MockAstronomyPictureRepo mockRepo;
  late MockAstronomyPicturePresenter mockPresenter;
  late GetAstronomyPicturesByDateRange getAstronomyPicturesUsecase;

  setUp(() {
    mockRepo = MockAstronomyPictureRepo();
    mockPresenter = MockAstronomyPicturePresenter();
    getAstronomyPicturesUsecase = GetAstronomyPicturesByDateRangeImpl(mockRepo);
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
    registerFallbackValue(const AstronomyPictureRetrievalFailure());
  });

  final rangeDate = DateRange.parse(
    startDateISO8601: "2023-11-19",
    endDateISO8601: "2023-11-19",
  );
  group('Success:', () {
    test('should pass the list of pictures to Presenter', () async {
      // arrange
      final pictures = [
        AstronomyPicture(
          date: DateTime.parse("2023-11-19"),
          explanation:
              "That's no sunspot. It's the International Space Station (ISS) caught passing in front of the Sun.",
          title: 'Space Station, Solar Prominences, Sun',
          mediumDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_960.jpg',
          ),
          highDefinitionUrl: Uri.parse(
            'https://apod.nasa.gov/apod/image/2311/IssSun_Ergun_1752.jpg',
          ),
        ),
      ];
      when(() => mockRepo.getAstronomyPicturesByDateRange(rangeDate))
          .thenAnswer((_) async => Right(pictures));

      // There should be no interaction with Presenter.
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(rangeDate, mockPresenter);

      // assert
      // There should be 1 interaction with Presenter.
      verify(() => mockPresenter.success(pictures)).called(1);
    });
    test('should pass an empty list to Presenter', () async {
      // arrange
      const noPictures = <AstronomyPicture>[];
      when(() => mockRepo.getAstronomyPicturesByDateRange(rangeDate))
          .thenAnswer((_) async => const Right(noPictures));

      // There should be no interaction with Repo and Presenter.
      verifyNever(() => mockRepo.getAstronomyPicturesByDateRange(any()));
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(rangeDate, mockPresenter);

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(() => mockRepo.getAstronomyPicturesByDateRange(rangeDate))
          .called(1);
      verify(() => mockPresenter.success(noPictures)).called(1);
    });
  });

  group('Failure:', () {
    test('should pass "AstronomyPictureFailure" to Presenter', () async {
      // arrange
      const failure = AstronomyPictureRetrievalFailure();
      when(() => mockRepo.getAstronomyPicturesByDateRange(rangeDate))
          .thenAnswer((_) async => const Left(failure));

      // There should be no interaction with Repo and Presenter.
      verifyNever(() => mockRepo.getAstronomyPicturesByDateRange(any()));
      verifyNever(() => mockPresenter.failure(any()));
      // act
      await getAstronomyPicturesUsecase(rangeDate, mockPresenter);

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(() => mockRepo.getAstronomyPicturesByDateRange(rangeDate))
          .called(1);
      verify(() => mockPresenter.failure(failure)).called(1);
    });
  });
}
