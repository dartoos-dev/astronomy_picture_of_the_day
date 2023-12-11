import '../dtos/pagination.dart';
import '../presenter/astronomy_picture_list_presenter.dart';
import '../repositories/astronomy_picture_repo.dart';

/// Astronomy pictures in descending order of date.
abstract interface class GetAstronomyPicturesWithPaginationDesc {
  /// Retrieves astronomy pictures in descending order of date.
  Future<void> call(
    AstronomyPictureListPresenter presenter, {
    required Pagination pagination,
  });
}

final class GetAstronomyPicturesWithPaginationDescImpl
    implements GetAstronomyPicturesWithPaginationDesc {
  const GetAstronomyPicturesWithPaginationDescImpl(this.repo);

  final AstronomyPictureRepo repo;

  @override
  Future<void> call(
    AstronomyPictureListPresenter presenter, {
    required Pagination pagination,
  }) async {
    final result = await repo.getAstronomyPicturesDesc(pagination);
    result.fold(presenter.failure, presenter.success);
  }
}
