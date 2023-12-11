import '../../domain/dtos/astronomy_pictures_with_pagination.dart';
import '../../domain/dtos/pagination.dart';

/// Remote Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureRemoteDataSource {
  /// Retrieves astronomy pictures according to the given date range, page and
  /// number of pictures per page — [pagination].
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<AstronomyPicturesWithPagination> getAstronomyPictures(
    Pagination pagination,
  );
}
