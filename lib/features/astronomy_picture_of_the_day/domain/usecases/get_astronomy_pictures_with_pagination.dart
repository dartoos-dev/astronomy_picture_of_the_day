import '../dtos/pagination.dart';
import '../presenter/astronomy_picture_presenter.dart';
import '../repositories/astronomy_picture_repo.dart';

abstract interface class GetAstronomyPicturesWithPagination {
  /// Retrieves and process astronomy pictures.
  Future<void> call(
    AstronomyPicturePresenter presenter, {
    required Pagination pagination,
  });
}

final class GetAstronomyPicturesWithPaginationImpl
    implements GetAstronomyPicturesWithPagination {
  const GetAstronomyPicturesWithPaginationImpl(this.repo);

  final AstronomyPictureRepo repo;

  @override
  Future<void> call(
    AstronomyPicturePresenter presenter, {
    required Pagination pagination,
  }) async {
    final result = await repo.getAstronomyPictures(pagination);
    result.fold(presenter.failure, presenter.success);
  }
}
