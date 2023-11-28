import 'dart:convert';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_api_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/external/datasources/astronomy_picture_remote_data_source_dio_impl.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/data_source_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AstronomyPictureRemoteDataSourceDioImpl remoteDataSourceDioImpl;

  setUp(() {
    mockDio = MockDio();
    remoteDataSourceDioImpl = AstronomyPictureRemoteDataSourceDioImpl(mockDio);
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
  });
  const copyright1 = "NASA © 1";
  const date1 = "2023-11-20";
  const explanation1 = "Blah blah blah 1";
  const hdurl1 =
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg";
  const title1 = "The Horsehead Nebula";
  const url1 = "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg";

  const copyright2 = "NASA © 2";
  const date2 = "2023-11-21";
  const explanation2 = "Blah blah blah 2";
  const hdurl2 =
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_2801.jpg";
  const title2 = "Fleming's Triangular Wisp";
  const url2 =
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_960.jpg";

  const copyright3 = "NASA © 3";
  const date3 = "2023-11-22";
  const explanation3 = "Blah blah blah 3";
  const hdurl3 = "https://apod.nasa.gov/apod/image/2311/ic342asi294large.jpg";
  const title3 = "IC 342: Hidden Galaxy in Camelopardalis";
  const url3 =
      "https://apod.nasa.gov/apod/image/2311/ic342asi294large_1024.jpg";

  const picturesListJson = """
[
  {
    "copyright": "$copyright1",
    "date": "$date1",
    "explanation": "$explanation1",
    "hdurl": "$hdurl1",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title1",
    "url": "$url1"
  },
  {
    "copyright": "$copyright2",
    "date": "$date2",
    "explanation": "$explanation2",
    "hdurl": "$hdurl2",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title2",
    "url": "$url2"
  },
  {
    "copyright": "$copyright3",
    "date": "$date3",
    "explanation": "$explanation3",
    "hdurl": "$hdurl3",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title3",
    "url": "$url3"
  }
]
""";

  final DateRange dateRange = DateRange.parse(
    startDateISO8601: date1,
    endDateISO8601: date3,
  );

  /// Mandatory request options according to the given date range.
  final requestOptions = RequestOptions(
    path: AstronomyPictureApiModel.apodPath,
    queryParameters: {'start_date': date1, 'end_date': date3},
  );

  final queryParameters = <String, dynamic>{
    'start_date': date1,
    'end_date': date3,
  };
  group("valid http request (status code 200 or 204)", () {
    test('http code 200: should return the picture list', () async {
      // arrange
      final picture1 = AstronomyPictureApiModel.fromStringData(
        dateIso8601: date1,
        title: title1,
        explanation: explanation1,
        mediumDefinitionUrl: url1,
        highDefinitionUrl: hdurl1,
      );
      final picture2 = AstronomyPictureApiModel.fromStringData(
        dateIso8601: date2,
        title: title2,
        explanation: explanation2,
        mediumDefinitionUrl: url2,
        highDefinitionUrl: hdurl2,
      );
      final picture3 = AstronomyPictureApiModel.fromStringData(
        dateIso8601: date3,
        title: title3,
        explanation: explanation3,
        mediumDefinitionUrl: url3,
        highDefinitionUrl: hdurl3,
      );

      // Arrange
      final okResponseWithContent = Response(
        statusCode: 200,
        requestOptions: requestOptions,
        data: jsonDecode(picturesListJson),
      );

      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => okResponseWithContent);
      // Act
      final pictures = await remoteDataSourceDioImpl
          .getAstronomyPicturesByDateRange(dateRange);

      // Verify
      assert(pictures.length == 3);
      expect(picture1.isEquivalentTo(pictures[0]), true);
      expect(picture2.isEquivalentTo(pictures[1]), true);
      expect(picture3.isEquivalentTo(pictures[2]), true);
    });
    test('http code 204: should return an empty list', () async {
      // Arrange
      final okResponseWithNoContent = Response(
        statusCode: 204,
        requestOptions: requestOptions,
        data: [],
      );

      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => okResponseWithNoContent);
      // Act
      final pictures = await remoteDataSourceDioImpl
          .getAstronomyPicturesByDateRange(dateRange);

      // Verify
      assert(pictures.isEmpty);
    });
  });
  group("invalid http request", () {
    test('http code other than 200 or 204: should throw "DataSourceException"',
        () async {
      // Arrange
      final clientErrorResponse = Response(
        statusCode: 400,
        requestOptions: requestOptions,
      );

      bool dataSourceExceptionWasThrown = false;
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => clientErrorResponse);
      // Act
      try {
        await remoteDataSourceDioImpl.getAstronomyPicturesByDateRange(
          dateRange,
        );
      } on DataSourceException {
        dataSourceExceptionWasThrown = true;
      }
      assert(dataSourceExceptionWasThrown, true);
      // Must have called 'get' with the right data just once.
      verify(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).called(1);
    });
  });
  group("Dio exception", () {
    test('should encapsulate "DioExcepton" in a "DataSourceException"',
        () async {
      // Arrange
      final serverErrorResponse = Response(
        statusCode: 500,
        requestOptions: requestOptions,
      );

      final dioException = DioException(
        response: serverErrorResponse,
        requestOptions: requestOptions,
      );
      bool dataSourceExceptionWasThrown = false;
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenThrow(dioException);
      // Act
      try {
        await remoteDataSourceDioImpl.getAstronomyPicturesByDateRange(
          dateRange,
        );
      } on DataSourceException catch (ex) {
        dataSourceExceptionWasThrown = true;
        // Must keep the same instance of the exception that signalled the failure.
        expect(ex.exception, same(dioException));
      }
      assert(dataSourceExceptionWasThrown, true);
      // Must have called 'get' with the right data just once.
      verify(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).called(1);
    });
  });
}
