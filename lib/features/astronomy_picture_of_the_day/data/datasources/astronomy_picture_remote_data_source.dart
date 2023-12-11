import '../../domain/dtos/astronomy_pictures_with_pagination.dart';
import '../../domain/dtos/pagination.dart';

/// Remote Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureRemoteDataSource {
  /// Retrieves, in descending order of date, astronomy pictures according to
  /// the given date date range, page and the number of pictures per page —
  /// [pagination].
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<AstronomyPicturesWithPagination> getAstronomyPicturesDesc(
    Pagination pagination,
  );
}
