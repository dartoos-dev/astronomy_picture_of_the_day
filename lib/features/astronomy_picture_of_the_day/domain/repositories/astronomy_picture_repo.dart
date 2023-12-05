import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:dartz/dartz.dart';

import '../entities/astronomy_picture.dart';
import '../errors/astronomy_picture_failure.dart';
import '../value_objects/date_range.dart';
import '../value_objects/page.dart';
import '../value_objects/pictures_per_page.dart';

/// Repository of [AstronomyPicture].
abstract interface class AstronomyPictureRepo {
  /// Retrieves astronomy pictures whose date falls within the given date range,
  /// current page and the number of pictures per page.
  Future<Either<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      getAstronomyPicturesWithPaginationByDateRange(
    DateRange range, {
    required Page page,
    required PicturesPerPage perPage,
  });
}
