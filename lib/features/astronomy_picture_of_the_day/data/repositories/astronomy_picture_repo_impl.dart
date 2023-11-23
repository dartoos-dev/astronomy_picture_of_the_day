import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';

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
  Future<Either<AstronomyPictureFailure, List<AstronomyPicture>>>
      getAstronomyPicturesByDateRange(DateRange range) async {
    try {
      return Right(
        await remoteDataSource.getAstronomyPicturesByDateRange(range),
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
