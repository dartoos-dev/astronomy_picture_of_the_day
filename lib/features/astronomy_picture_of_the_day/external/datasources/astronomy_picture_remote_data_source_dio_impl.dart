import 'package:dio/dio.dart';

import '../../../../shared/errors/data_source_exception.dart';
import '../../data/datasources/astronomy_picture_remote_data_source.dart';
import '../../data/models/astronomy_picture_api_model.dart';
import '../../domain/value_objects/date_range.dart';

/// [AstronomyPictureRemoteDataSource] implementation that uses [Dio] as the
/// http client.
class AstronomyPictureRemoteDataSourceDioImpl
    implements AstronomyPictureRemoteDataSource<AstronomyPictureApiModel> {
  AstronomyPictureRemoteDataSourceDioImpl(this.httpClient);

  final Dio httpClient;

  @override
  Future<List<AstronomyPictureApiModel>> getAstronomyPicturesByDateRange(
    DateRange range,
  ) async {
    try {
      final response = await httpClient.get(
        AstronomyPictureApiModel.apodPath,
        queryParameters: {
          'start_date': range.startDateIso8601,
          'end_date': range.endDateIso8601,
        },
      );

      /// Empty; there is no body content.
      if (response.statusCode == 204) {
        return [];
      }
      if (response.statusCode == 200) {
        /// The response body has already been converted to json by [Dio] as the
        /// 'Content-Type' header of the response is 'application/json'.
        final astronomyPictureList = (response.data as List<dynamic>)
            .map(
              (item) => AstronomyPictureApiModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
        return astronomyPictureList;
      }
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
    }
  }
}
