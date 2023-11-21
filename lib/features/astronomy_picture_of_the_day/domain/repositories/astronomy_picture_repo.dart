import 'package:dartz/dartz.dart';

import '../entities/astronomy_picture.dart';
import '../errors/astronomy_picture_failure.dart';
import '../value_objects/date_range.dart';

/// Repository of [AstronomyPicture].
abstract interface class AstronomyPictureRepo {
  /// Retrieves astronomy pictures whose date falls within the given date range.
  Future<Either<AstronomyPictureFailure, List<AstronomyPicture>>>
      getAstronomyPicturesByDateRange(DateRange range);
}
