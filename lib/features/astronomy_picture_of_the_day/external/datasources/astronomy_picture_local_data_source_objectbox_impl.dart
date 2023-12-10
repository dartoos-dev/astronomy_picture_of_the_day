import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_objectbox_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';

import '../../../../objectbox.g.dart';
import '../../../../shared/errors/data_source_exception.dart';
import '../../data/datasources/astronomy_picture_local_data_source.dart';

/// [AstronomyPictureLocalDataSource] implementation that uses Objectbox as the
/// NoSql local database.
final class AstronomyPictureLocalDataSourceObjectboxImpl
    implements AstronomyPictureLocalDataSource {
  /// Sets the [Box] instance.
  const AstronomyPictureLocalDataSourceObjectboxImpl(
    Box<AstronomyPictureObjectboxModel> box,
  ) : _box = box;

  final Box<AstronomyPictureObjectboxModel> _box;

  @override
  Future<bool> containsPictures(
    DateRange range,
    Page page,
    PicturesPerPage perPage,
  ) async {
    final dateRangeQuery = _dateRangeQuery(range);
    final startDateQuery = _startDateQuery(range);
    final endDateQuery = _endDateQuery(range);
    try {
      final containsPicturesInRange =
          startDateQuery.count() >= 1 && endDateQuery.count() >= 1;
      if (!containsPicturesInRange) {
        return false;
      }
      final totalInDatabase = TotalPictures(dateRangeQuery.count());
      final lastPageInDataBase = Page.last(totalInDatabase, perPage);
      return lastPageInDataBase >= page;
    } on Exception catch (ex) {
      throw DataSourceException(
        _formattedErrorMessage(
          'Error when counting pictures saved in local database "ObjectBox"',
          range,
          page,
          perPage,
        ),
        exception: ex,
      );
    } finally {
      dateRangeQuery.close();
      startDateQuery.close();
      endDateQuery.close();
    }
  }

  @override
  Future<AstronomyPicturesWithPagination>
      getAstronomyPicturesWithPaginationByDateRange(
    DateRange range, {
    required Page page,
    required PicturesPerPage perPage,
  }) async {
    final dateRangeQueryOrderByDateAsc = _dateRangeQueryOrderByDateDesc(range);
    try {
      final totalPicturesByDateRange =
          TotalPictures(dateRangeQueryOrderByDateAsc.count());
      final pagingQuery = dateRangeQueryOrderByDateAsc
        ..offset = page.offset(perPage)
        ..limit = perPage.value;
      final pagePictures = pagingQuery.find();
      return AstronomyPicturesWithPagination(
        currentPage: page,
        lastPage: Page.last(totalPicturesByDateRange, perPage),
        totalPictures: totalPicturesByDateRange,
        currentPagePictures: pagePictures,
      );
    } on Exception catch (ex) {
      throw DataSourceException(
        _formattedErrorMessage(
          'Error retrieving page with astronomy pictures from local database "ObjectBox".',
          range,
          page,
          perPage,
        ),
        exception: ex,
      );
    } finally {
      dateRangeQueryOrderByDateAsc.close();
    }
  }

  @override
  Future<void> saveAstronomyPictures(List<AstronomyPicture> pictures) async {
    try {
      _box.putMany(
        pictures
            .map(AstronomyPictureObjectboxModel.fromEntity)
            .toList(growable: false),
      );
    } on Exception catch (ex) {
      throw DataSourceException(
        'Error saving pictures to local database "Objectbox".',
        exception: ex,
      );
    }
  }

  String _formattedErrorMessage(
    String mainMessage,
    DateRange range,
    Page page,
    PicturesPerPage perPage,
  ) {
    return """
      $mainMessage
      Date range: [${range.startDateIso8601} – ${range.endDateIso8601}]
      Page: $page'
      Pictures per page: $perPage;
    """;
  }

  /// Query by [DateRange.start].
  Query<AstronomyPictureObjectboxModel> _startDateQuery(
    DateRange range,
  ) {
    return _box
        .query(
          AstronomyPictureObjectboxModel_.date
              .equals(range.start.millisecondsSinceEpoch),
        )
        .build()
      ..limit = 1;
  }

  /// Query by [DateRange.end].
  Query<AstronomyPictureObjectboxModel> _endDateQuery(
    DateRange range,
  ) {
    return _box
        .query(
          AstronomyPictureObjectboxModel_.date
              .equals(range.end.millisecondsSinceEpoch),
        )
        .build()
      ..limit = 1;
  }

  /// Query by [DateRange].
  Query<AstronomyPictureObjectboxModel> _dateRangeQuery(
    DateRange range,
  ) {
    return _box
        .query(
          AstronomyPictureObjectboxModel_.date.between(
            range.start.millisecondsSinceEpoch,
            range.end.millisecondsSinceEpoch,
          ),
        )
        .build();
  }

  /// Query by [DateRange] ordered by descending date.
  Query<AstronomyPictureObjectboxModel> _dateRangeQueryOrderByDateDesc(
    DateRange range,
  ) {
    return _box
        .query(
          AstronomyPictureObjectboxModel_.date.between(
            range.start.millisecondsSinceEpoch,
            range.end.millisecondsSinceEpoch,
          ),
        )
        .order(AstronomyPictureObjectboxModel_.date, flags: Order.descending)
        .build();
  }
}
