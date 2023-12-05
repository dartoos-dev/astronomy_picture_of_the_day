import '../../domain/dtos/astronomy_pictures_with_pagination.dart';
import '../../domain/entities/astronomy_picture.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/page.dart';
import '../../domain/value_objects/pictures_per_page.dart';

/// Local Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureLocalDataSource {
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

  /// Saves astronomy images on the device's local storage.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<void> saveAstronomyPictures(List<AstronomyPicture> pictures);

  /// criteria by page and date range.
  ///
  /// Returns `true` if the local storage contains all pictures whose dates fall
  /// within the given date range and pagination info; otherwise, returns
  /// `false`.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<bool> containsPictures(
    DateRange range,
    Page page,
    PicturesPerPage perPage,
  );
}
