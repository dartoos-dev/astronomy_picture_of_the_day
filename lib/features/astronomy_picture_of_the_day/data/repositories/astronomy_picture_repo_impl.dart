import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';

import 'package:dartz/dartz.dart';

import '../../../../shared/connectivity/data/drivers/connectivity_driver.dart';
import '../../../../shared/errors/data_source_exception.dart';
import '../../../../shared/errors/driver_exception.dart';
import '../../../../shared/logger/log_and_left.dart';
import '../../domain/repositories/astronomy_picture_repo.dart';
import '../datasources/astronomy_picture_local_data_source.dart';
import '../datasources/astronomy_picture_remote_data_source.dart';

/// For a better user experience, this repository caches astronomy images
/// fetched from a remote server in the device's local storage.
class AstronomyPictureRepoImpl implements AstronomyPictureRepo {
  const AstronomyPictureRepoImpl({
    required AstronomyPictureRemoteDataSource remoteDataSource,
    required AstronomyPictureLocalDataSource localDataSource,
    required ConnectivityDriver connectivityDriver,
    required LogAndLeft logger,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivityDriver = connectivityDriver,
        _logger = logger;

  final AstronomyPictureRemoteDataSource _remoteDataSource;
  final AstronomyPictureLocalDataSource _localDataSource;
  final ConnectivityDriver _connectivityDriver;
  final LogAndLeft _logger;

  @override
  Future<Either<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      getAstronomyPicturesWithPaginationByDateRange(
    DateRange range, {
    required Page page,
    required PicturesPerPage perPage,
  }) async {
    try {
      // The first attempt is to get all pictures from the device's local
      // storage.
      if (await _localDataSource.containsPictures(range, page, perPage)) {
        return await _getPicturesFromLocalDataSource(
          range,
          page: page,
          picturesPerPage: perPage,
        );
      }
      // fetches pictures from remote server and caches them locally.
      if (await _connectivityDriver.hasActiveInternetConnection) {
        return await _getPicturesFromRemoteDataSourceAndCachesThemLocally(
          range,
          page: page,
          picturesPerPage: perPage,
        );
      }
      // Best-effort policy: at this point, the local storage does not contain all the
      // images whose dates are within [range], but it may contain some of them.
      return await _getPicturesFromLocalDataSource(
        range,
        page: page,
        picturesPerPage: perPage,
      );
    } on DataSourceException catch (ex, st) {
      return _logger(
        const RetrievalFailure(),
        exception: ex,
        stacktrace: st,
      );
    } on DriverException catch (ex, st) {
      return _logger(
        const ConnectionCheckFailure(),
        exception: ex,
        stacktrace: st,
      );
    }
  }

  Future<Right<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      _getPicturesFromLocalDataSource(
    DateRange range, {
    required Page page,
    required PicturesPerPage picturesPerPage,
  }) async {
    return Right(
      await _localDataSource.getAstronomyPicturesWithPaginationByDateRange(
        range,
        page: page,
        perPage: picturesPerPage,
      ),
    );
  }

  /// Gets images from remote server and caches them locally.
  Future<Right<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      _getPicturesFromRemoteDataSourceAndCachesThemLocally(
    DateRange range, {
    required Page page,
    required PicturesPerPage picturesPerPage,
  }) async {
    final result =
        await _remoteDataSource.getAstronomyPicturesWithPaginationByDateRange(
      range,
      page: page,
      perPage: picturesPerPage,
    );
    await _localDataSource.saveAstronomyPictures(result.currentPagePictures);
    return Right(result);
  }
}
