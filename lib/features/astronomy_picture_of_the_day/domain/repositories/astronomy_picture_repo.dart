import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:dartz/dartz.dart';

import '../dtos/pagination.dart';
import '../entities/astronomy_picture.dart';
import '../errors/astronomy_picture_failure.dart';

/// Repository of [AstronomyPicture].
abstract interface class AstronomyPictureRepo {
  /// Retrieves, in descending order of date, astronomy pictures whose date
  /// falls within the given date range, page and the number of pictures per
  /// page — [pagination].
  Future<Either<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      getAstronomyPicturesDesc(Pagination pagination);

  /// Retrieves an [AstronomyPicture] by its id or null if not found.
  Future<Either<AstronomyPictureFailure, AstronomyPicture?>>
      getAstronomyPictureById(String id);
}
