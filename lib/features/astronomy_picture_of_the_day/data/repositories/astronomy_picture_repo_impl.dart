import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/errors/astronomy_picture_failure.dart';

import 'package:dartz/dartz.dart';

import '../../../../shared/connectivity/data/drivers/connectivity_driver.dart';
import '../../../../shared/errors/data_source_exception.dart';
import '../../../../shared/errors/driver_exception.dart';
import '../../../../shared/logger/log_and_left.dart';
import '../../domain/dtos/pagination.dart';
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
      getAstronomyPictures(Pagination pagination) async {
    try {
      // The first attempt is to get all pictures from the device's local
      // storage.
      if (await _localDataSource.containsPictures(pagination)) {
        return await _getPicturesFromLocalDataSource(pagination);
      }
      // fetches pictures from remote server and caches them locally.
      if (await _connectivityDriver.hasActiveInternetConnection) {
        return await _getPicturesFromRemoteDataSourceAndCachesThemLocally(
          pagination,
        );
      }
      // Best-effort policy: at this point, the local storage does not contain all the
      // images whose dates are within [range], but it may contain some of them.
      return await _getPicturesFromLocalDataSource(pagination);
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
      _getPicturesFromLocalDataSource(Pagination pagination) async {
    return Right(await _localDataSource.getAstronomyPictures(pagination));
  }

  /// Gets images from remote server and caches them locally.
  Future<Right<AstronomyPictureFailure, AstronomyPicturesWithPagination>>
      _getPicturesFromRemoteDataSourceAndCachesThemLocally(
    Pagination pagination,
  ) async {
    final result = await _remoteDataSource.getAstronomyPictures(pagination);
    await _localDataSource.saveAstronomyPictures(result.currentPagePictures);
    return Right(result);
  }
}
