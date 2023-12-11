import '../../domain/dtos/astronomy_pictures_with_pagination.dart';
import '../../domain/dtos/pagination.dart';
import '../../domain/entities/astronomy_picture.dart';

/// Local Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureLocalDataSource {
  /// Retrieves, in descending order of date, astronomy pictures according to
  /// the given date date range, page and the number of pictures per page —
  /// [pagination].
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<AstronomyPicturesWithPagination> getAstronomyPicturesDesc(
    Pagination pagination,
  );

  /// Checks for the existance of pictures by the given [pagination] criteria.
  ///
  /// Returns `true` if the local storage contains all pictures whose dates fall
  /// within the given [pagination]; otherwise, returns `false`.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<bool> containsPictures(Pagination pagination);

  /// Saves astronomy images on the device's local storage.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<void> saveAstronomyPictures(List<AstronomyPicture> pictures);
}
