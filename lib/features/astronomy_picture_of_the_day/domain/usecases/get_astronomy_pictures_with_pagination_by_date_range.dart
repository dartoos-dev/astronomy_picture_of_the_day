import '../presenter/astronomy_picture_presenter.dart';
import '../repositories/astronomy_picture_repo.dart';
import '../value_objects/date_range.dart';
import '../value_objects/page.dart';
import '../value_objects/pictures_per_page.dart';

abstract interface class GetAstronomyPicturesWithPaginationByDateRange {
  /// Retrieves and process astronomy pictures.
  Future<void> call(
    AstronomyPicturePresenter presenter, {
    required DateRange dateRange,
    required Page page,
    required PicturesPerPage perPage,
  });
}

final class GetAstronomyPicturesWithPaginationByDateRangeImpl
    implements GetAstronomyPicturesWithPaginationByDateRange {
  const GetAstronomyPicturesWithPaginationByDateRangeImpl(this.repo);

  final AstronomyPictureRepo repo;

  @override
  Future<void> call(
    AstronomyPicturePresenter presenter, {
    required DateRange dateRange,
    required Page page,
    required PicturesPerPage perPage,
  }) async {
    final result = await repo.getAstronomyPicturesWithPaginationByDateRange(
      dateRange,
      page: page,
      perPage: perPage,
    );
    result.fold(presenter.failure, presenter.success);
  }
}
