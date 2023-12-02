import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';

import 'package:dartz/dartz.dart';

import '../../../../shared/errors/data_source_exception.dart';
import '../../../../shared/logger/log_and_left.dart';
import '../../domain/repositories/astronomy_picture_repo.dart';
import '../datasources/astronomy_picture_remote_data_source.dart';

class AstronomyPictureRepoImpl implements AstronomyPictureRepo {
  const AstronomyPictureRepoImpl(
    this.remoteDataSource, {
    required this.logger,
  });

  final AstronomyPictureRemoteDataSource remoteDataSource;
  final LogAndLeft logger;

  @override
  Future<Either<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      getAstronomyPicturesWithPaginationByDateRange(
    DateRange range, {
    required Page page,
    required PicturesPerPage picturesPerPage,
  }) async {
    try {
      return Right(
        await remoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
          range,
          page: page,
          picturesPerPage: picturesPerPage,
        ),
      );
    } on DataSourceException catch (ex, st) {
      return logger(
        const AstronomyPictureRetrievalFailure(),
        exception: ex,
        stacktrace: st,
      );
    }
  }
}
