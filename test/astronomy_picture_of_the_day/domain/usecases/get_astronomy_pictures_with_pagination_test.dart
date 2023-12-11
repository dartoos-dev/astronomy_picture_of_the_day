import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/presenter/astronomy_picture_presenter.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/repositories/astronomy_picture_repo.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/usecases/get_astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
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
  late GetAstronomyPicturesWithPagination getAstronomyPicturesUsecase;

  final pagination = Pagination.oneWeek();
  const totalPictures = TotalPictures(10);
  final lastPage = Page.last(totalPictures, pagination.perPage);

  setUpAll(() {
    registerFallbackValue(Pagination.oneWeek());
    registerFallbackValue(const RetrievalFailure());
    registerFallbackValue(const AstronomyPicturesWithPagination.empty());
  });
  setUp(() {
    mockRepo = MockAstronomyPictureRepo();
    mockPresenter = MockAstronomyPicturePresenter();
    getAstronomyPicturesUsecase =
        GetAstronomyPicturesWithPaginationImpl(mockRepo);
  });

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
        currentPage: pagination.page,
        lastPage: lastPage,
        totalPictures: totalPictures,
        currentPagePictures: pictures,
      );
      when(() => mockRepo.getAstronomyPictures(pagination))
          .thenAnswer((_) async => Right(picturesWithPagination));

      // There should be no interaction with Presenter.
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(mockPresenter, pagination: pagination);

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
      when(() => mockRepo.getAstronomyPictures(pagination))
          .thenAnswer((_) async => const Right(zeroPicturesWithPagination));

      // There should be no interaction with Repo and Presenter.
      verifyNever(() => mockRepo.getAstronomyPictures(any()));
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPicturesUsecase(mockPresenter, pagination: pagination);

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(() => mockRepo.getAstronomyPictures(pagination)).called(1);
      verify(() => mockPresenter.success(zeroPicturesWithPagination)).called(1);
      // no failure interaction
      verifyNever(() => mockPresenter.failure(any()));
    });
  });

  group('Error handling:', () {
    test('should pass "AstronomyPictureFailure" to Presenter', () async {
      // arrange
      const failure = RetrievalFailure();
      when(() => mockRepo.getAstronomyPictures(any()))
          .thenAnswer((_) async => const Left(failure));

      // There should be no interaction with Repo and Presenter.
      verifyNever(() => mockRepo.getAstronomyPictures(any()));
      // act
      await getAstronomyPicturesUsecase(mockPresenter, pagination: pagination);

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(() => mockRepo.getAstronomyPictures(pagination)).called(1);
      verify(() => mockPresenter.failure(failure)).called(1);
      // no success interaction
      verifyNever(() => mockPresenter.success(any()));
    });
  });
}
