import '../entities/astronomy_picture.dart';
import '../presenter/astronomy_picture_detail_presenter.dart';
import '../repositories/astronomy_picture_repo.dart';

/// Astronomy picture by its id.
abstract interface class GetAstronomyPictureById {
  /// Presents the result of searching for an astronomy picture by its id.
  Future<void> call(
    AstronomyPictureDetailPresenter presenter, {
    required String id,
  });
}

final class GetAstronomyPictureByIdImpl implements GetAstronomyPictureById {
  const GetAstronomyPictureByIdImpl(this.repo);

  final AstronomyPictureRepo repo;

  @override
  Future<void> call(
    AstronomyPictureDetailPresenter presenter, {
    required String id,
  }) async {
    final result = await repo.getAstronomyPictureById(id);
    result.fold(
      (failure) => presenter.failure(failure),
      (AstronomyPicture? picture) {
        if (picture != null) {
          presenter.success(picture);
        } else {
          presenter.notFound(id);
        }
      },
    );
  }
}
