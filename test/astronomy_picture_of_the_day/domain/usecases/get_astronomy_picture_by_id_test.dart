import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/presenter/astronomy_picture_detail_presenter.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/repositories/astronomy_picture_repo.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/usecases/get_astronomy_picture_by_id.dart';
import 'package:astronomy_picture_of_the_day/shared/value_objects/id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAstronomyPictureRepo extends Mock implements AstronomyPictureRepo {}

class MockAstronomyPictureDetailPresenter extends Mock
    implements AstronomyPictureDetailPresenter {}

void main() {
  late MockAstronomyPictureRepo mockRepo;
  late MockAstronomyPictureDetailPresenter mockPresenter;
  late GetAstronomyPictureById getAstronomyPictureByIdUsecase;

  setUpAll(() {
    registerFallbackValue(const RetrievalFailure());
    registerFallbackValue(
      AstronomyPicture(
        date: DateTime.now(),
        title: "A Title",
        explanation: "Blah blah blah",
        mediumDefinitionUrl: Uri.parse('http://astronomy_pictures/img1'),
        highDefinitionUrl: Uri.parse('http://astronomy_pictures/hd/img1'),
      ),
    );
  });
  setUp(() {
    mockRepo = MockAstronomyPictureRepo();
    mockPresenter = MockAstronomyPictureDetailPresenter();
    getAstronomyPictureByIdUsecase = GetAstronomyPictureByIdImpl(mockRepo);
  });

  group('Success:', () {
    const idValue = '123-abc';
    test('should forward the Astronomy Picture to Presenter', () async {
      // arrange
      final picture = AstronomyPicture(
        id: const ID(idValue),
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
      );

      when(() => mockRepo.getAstronomyPictureById(idValue))
          .thenAnswer((_) async => Right(picture));

      // There should be no interaction with Presenter.
      verifyNever(() => mockPresenter.success(any()));
      // act
      await getAstronomyPictureByIdUsecase(mockPresenter, id: idValue);

      // assert
      // There should be 1 interaction with Presenter.
      verify(() => mockPresenter.success(picture)).called(1);
      // no failure interaction
      verifyNever(() => mockPresenter.failure(any()));
    });
  });
  group('Not found:', () {
    const nonExistentId = '789-xyz';
    test('should invoke "notFound" method of Presenter', () async {
      // arrange
      when(() => mockRepo.getAstronomyPictureById(any()))
          .thenAnswer((_) async => const Right(null));

      // There should be no interaction with Presenter.
      verifyNever(() => mockPresenter.notFound(any()));
      // act
      await getAstronomyPictureByIdUsecase(mockPresenter, id: nonExistentId);

      // assert
      // There should be 1 interaction with Presenter.
      verify(() => mockPresenter.notFound(nonExistentId)).called(1);
    });
  });
  group('Error handling:', () {
    const id = 'an id value';
    test('should pass "AstronomyPictureFailure" to Presenter', () async {
      // arrange
      const failure = RetrievalFailure();
      when(() => mockRepo.getAstronomyPictureById(id))
          .thenAnswer((_) async => const Left(failure));

      // There should be no interaction with Repo and Presenter.
      verifyNever(() => mockRepo.getAstronomyPictureById(any()));
      // act
      await getAstronomyPictureByIdUsecase(mockPresenter, id: id);

      // assert
      // There should be 1 interaction with Repo and Presenter.
      verify(() => mockRepo.getAstronomyPictureById(id)).called(1);
      verify(() => mockPresenter.failure(failure)).called(1);
    });
  });
}
