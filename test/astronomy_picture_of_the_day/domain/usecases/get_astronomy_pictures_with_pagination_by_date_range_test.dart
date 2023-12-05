import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/presenter/astronomy_picture_presenter.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/repositories/astronomy_picture_repo.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/usecases/get_astronomy_pictures_with_pagination_by_date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAstronomyPictureRepo extends Mock implements AstronomyPictureRepo {}

class MockAstronomyPicturePresenter extends Mock
    implements AstronomyPicturePresenter {}

void main() {
  late MockAstronomyPictureRepo mockRepo;
  late MockAstronomyPicturePresenter mockPresenter;
  late GetAstronomyPicturesWithPaginationByDateRange
      getAstronomyPicturesUsecase;

  setUp(() {
    mockRepo = MockAstronomyPictureRepo();
    mockPresenter = MockAstronomyPicturePresenter();
    getAstronomyPicturesUsecase =
        GetAstronomyPicturesWithPaginationByDateRangeImpl(mockRepo);
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
    registerFallbackValue(const Page.first());
    registerFallbackValue(const PicturesPerPage.seven());
    registerFallbackValue(const RetrievalFailure());
    registerFallbackValue(const AstronomyPicturesWithPagination.empty());
  });

  final dateRange = DateRange.parse(
    startDateISO8601: "2023-11-19",
    endDateISO8601: "2023-11-19",
  );
  const page = Page.first();
  const perPage = PicturesPerPage.seven();
  const totalPictures = TotalPictures(10);
  final lastPage = Page.last(totalPictures, perPage);

  group('Success:', () {
    test('should pass the paginated list of pictures to Presenter', () async {
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

      final picturesWithPagination = AstronomyPicturesWithPagination(
        currentPage: page,
        lastPage: lastPage,
        totalPictures: totalPictures,
        currentPagePictures: pictures,
      );
      when(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      ).thenAnswer((_) async => Right(picturesWithPagination));

      // There should be no interaction with Presenter.
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(
        mockPresenter,
        dateRange: dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with Presenter.
      verify(() => mockPresenter.success(picturesWithPagination)).called(1);
      // no failure interaction
      verifyNever(() => mockPresenter.failure(any()));
    });
    test('should pass an empty list to Presenter', () async {
      // arrange
      const zeroPicturesWithPagination =
          AstronomyPicturesWithPagination.empty();
      when(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      ).thenAnswer((_) async => const Right(zeroPicturesWithPagination));

      // There should be no interaction with Repo and Presenter.
      verifyNever(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          any(),
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      );
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(
        mockPresenter,
        dateRange: dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).called(1);
      verify(() => mockPresenter.success(zeroPicturesWithPagination)).called(1);
      // no failure interaction
      verifyNever(() => mockPresenter.failure(any()));
    });
  });

  group('Failure:', () {
    test('should pass "AstronomyPictureFailure" to Presenter', () async {
      // arrange
      const failure = RetrievalFailure();
      when(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          any(),
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      ).thenAnswer((_) async => const Left(failure));

      // There should be no interaction with Repo and Presenter.
      verifyNever(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          any(),
          page: any(named: "page"),
          perPage: any(named: "perPage"),
        ),
      );
      // act
      await getAstronomyPicturesUsecase(
        mockPresenter,
        dateRange: dateRange,
        page: page,
        perPage: perPage,
      );

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(
        () => mockRepo.getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page,
          perPage: perPage,
        ),
      ).called(1);
      verify(() => mockPresenter.failure(failure)).called(1);

      // no success interaction
      verifyNever(() => mockPresenter.success(any()));
    });
  });
}
