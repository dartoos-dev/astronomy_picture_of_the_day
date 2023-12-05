import '../../domain/dtos/astronomy_pictures_with_pagination.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/page.dart';
import '../../domain/value_objects/pictures_per_page.dart';

/// Remote Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureRemoteDataSource {
  /// Retrieves astronomy pictures according to the given date range, page and
  /// number of pictures per page.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<AstronomyPicturesWithPagination>
      getAstronomyPicturesWithPaginationByDateRange(
    DateRange range, {
    required Page page,
    required PicturesPerPage perPage,
  });
}
