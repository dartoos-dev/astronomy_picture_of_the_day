import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/shared/http/custom_dio/types.dart';
import 'package:dio/dio.dart';

import '../../../../shared/errors/data_source_exception.dart';
import '../../data/datasources/astronomy_picture_remote_data_source.dart';
import '../../data/models/astronomy_picture_api_model.dart';
import '../../domain/dtos/pagination.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/total_pictures.dart';

/// [AstronomyPictureRemoteDataSource] implementation that uses [Dio] as the
/// http client.
class AstronomyPictureRemoteDataSourceDioImpl
    implements AstronomyPictureRemoteDataSource {
  AstronomyPictureRemoteDataSourceDioImpl(this.httpClientFactory);

  final DioFactory httpClientFactory;

  @override
  Future<AstronomyPicturesWithPagination> getAstronomyPicturesDesc(
    Pagination pagination,
  ) async {
    final httpClient = httpClientFactory();
    try {
      final pageInfo = _pageInfo(pagination);
      final response = await httpClient.get(
        AstronomyPictureApiModel.apodPath,
        queryParameters: {
          'start_date': pageInfo.pageDateRange.startDateIso8601,
          'end_date': pageInfo.pageDateRange.endDateIso8601,
        },
      );
      // Ok response; there is a response body content.
      if (response.statusCode == 200) {
        // The response body has already been converted to json by [Dio] as the
        // 'Content-Type' header of the response is 'application/json'.
        final astronomyPictureList = (response.data as List<dynamic>)
            .map(
              (item) => AstronomyPictureApiModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();

        return AstronomyPicturesWithPagination(
          currentPage: pageInfo.currentPage,
          lastPage: pageInfo.lastPage,
          totalPictures: pageInfo.totalPictures,
          currentPagePictures: astronomyPictureList..sort(),
        );
      }

      // Empty; there is no response body content.
      if (response.statusCode == 204) {
        return const AstronomyPicturesWithPagination.empty();
      }

      // Handle error
      final errorMessage = """
        Http Request Error
        - url...........: '${response.realUri}'
        - status code...: '${response.statusCode}'
        - status message: '${response.statusMessage}'
        """;
      throw DataSourceException(errorMessage);
    } on DioException catch (ex) {
      throw DataSourceException(
        "Error when trying to access NASA's API.",
        exception: ex,
      );
    } finally {
      httpClient.close();
    }
  }

  /// Pagination-related info.
  _PageInfoDto _pageInfo(Pagination pagination) {
    final totalPictures = TotalPictures.onePicturePerDay(pagination.range);
    final lastPage = Page.last(totalPictures, pagination.perPage);
    // ensures that there is no "past-the-end" page.
    final currentPage = pagination.page > lastPage ? lastPage : pagination.page;
    final calculatedDateRange = _calculatedPageDateRange(
      pagination.range,
      page: currentPage,
      lastPage: lastPage,
      perPage: pagination.perPage,
      totalPictures: totalPictures,
    );
    return _PageInfoDto(
      pageDateRange: DateRange(
        start: _calculatedStartDateOrMinStartDate(calculatedDateRange.start),
        end: _calculatedEndDateOrMaxEndDate(calculatedDateRange.end),
      ),
      currentPage: currentPage,
      lastPage: lastPage,
      totalPictures: totalPictures,
    );
  }

  /// Calculates a date range according to the given pagination info.
  DateRange _calculatedPageDateRange(
    DateRange range, {
    required Page page,
    required Page lastPage,
    required PicturesPerPage perPage,
    required TotalPictures totalPictures,
  }) {
    final startDateOffsetInDays = perPage.value * (page.value - 1);
    final endDateOffsetInDays = page != lastPage
        ? endDateOffsetInDaysForAllButTheLastPage(
            startDateOffsetInDays,
            perPage,
          )
        : endDateOffsetForTheLastPage(
            startDateOffsetInDays,
            perPage,
            totalPictures,
          );
    final startDate = range.start;
    final startDateWithOffset =
        startDate.add(Duration(days: startDateOffsetInDays));
    final endDate = range.end;
    final endDateWithOffset =
        startDate.add(Duration(days: endDateOffsetInDays));
    final actualEndDate =
        endDateWithOffset.isAfter(endDate) ? endDate : endDateWithOffset;
    return DateRange(
      start: startDateWithOffset,
      end: actualEndDate,
    );
  }

  int endDateOffsetInDaysForAllButTheLastPage(
    int startDateOffsetInDays,
    PicturesPerPage perPage,
  ) {
    return startDateOffsetInDays + perPage.value - 1;
  }

  int endDateOffsetForTheLastPage(
    int startDateOffsetInDays,
    PicturesPerPage perPage,
    TotalPictures totalPictures,
  ) {
    return startDateOffsetInDays +
        perPage.value -
        (totalPictures.value % perPage.value) -
        1;
  }

  /// Returns the given [calculatedStartDate] if it is not earlier than
  /// [AstronomyPictureApiModel.minStartDate]; otherwise,
  /// [AstronomyPictureApiModel.minStartDate].
  DateTime _calculatedStartDateOrMinStartDate(DateTime calculatedStartDate) {
    final minStartDate = AstronomyPictureApiModel.minStartDate;
    return calculatedStartDate.isBefore(minStartDate)
        ? minStartDate
        : calculatedStartDate;
  }

  /// Returns the given [calculatedEndDate] if it is not later than
  /// [AstronomyPictureApiModel.maxEndDate]; otherwise,
  /// [AstronomyPictureApiModel.maxEndDate].
  DateTime _calculatedEndDateOrMaxEndDate(DateTime calculatedEndDate) {
    final maxEndDate = AstronomyPictureApiModel.maxEndDate;
    return calculatedEndDate.isAfter(maxEndDate)
        ? maxEndDate
        : calculatedEndDate;
  }
}

/// Helper DTO that aggregates pagination-related info.
final class _PageInfoDto {
  const _PageInfoDto({
    required this.pageDateRange,
    required this.currentPage,
    required this.lastPage,
    required this.totalPictures,
  });

  final DateRange pageDateRange;
  final Page currentPage;
  final Page lastPage;
  final TotalPictures totalPictures;
}
