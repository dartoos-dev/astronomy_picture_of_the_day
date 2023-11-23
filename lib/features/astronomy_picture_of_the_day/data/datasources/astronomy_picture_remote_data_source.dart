import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';

import '../../domain/value_objects/date_range.dart';

/// Remote Data Source of Astronomy Pictures.
abstract interface class AstronomyPictureRemoteDataSource<
    T extends AstronomyPicture> {
  /// Retrieves astronomy pictures by date range.
  ///
  /// Throws [DatasourceException] to indicate an operation error.
  Future<List<T>> getAstronomyPicturesByDateRange(DateRange range);
}
