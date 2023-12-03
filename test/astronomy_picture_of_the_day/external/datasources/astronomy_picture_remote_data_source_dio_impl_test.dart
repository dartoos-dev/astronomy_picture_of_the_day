import 'dart:convert';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_api_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/astronomy_pictures_with_pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
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
    remoteDataSourceDioImpl =
        AstronomyPictureRemoteDataSourceDioImpl(() => mockDio);
    registerFallbackValue(
      DateRange(start: DateTime.now(), end: DateTime.now()),
    );
    registerFallbackValue(const Page.first());
    registerFallbackValue(const PicturesPerPage.seven());
  });

  // For checks that must be true at the end of each test case in this group.
  // For example, if the Dio instance was closed after use.
  tearDown(() {
    // It must always close the Dio instance regardless of the request result.
    verify(() => mockDio.close()).called(1);
  });
  const date1 = "2023-11-21";
  const explanation1 = "Blah blah blah 1";
  const hdurl1 =
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_2801.jpg";
  const title1 = "Fleming's Triangular Wisp";
  const url1 =
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_960.jpg";

  const date2 = "2023-11-22";
  const explanation2 = "Blah blah blah 2";
  const hdurl2 = "https://apod.nasa.gov/apod/image/2311/ic342asi294large.jpg";
  const title2 = "IC 342: Hidden Galaxy in Camelopardalis";
  const url2 =
      "https://apod.nasa.gov/apod/image/2311/ic342asi294large_1024.jpg";

  const date3 = "2023-11-23";
  const explanation3 = "Blah blah blah 3";
  const hdurl3 = "https://apod.nasa.gov/apod/image/2311/ngc1555wide4096.jpg";
  const title3 = "Along the Taurus Molecular Cloud";
  const url3 = "https://apod.nasa.gov/apod/image/2311/ngc1555wide1024.jpg";

  const date4 = "2023-11-24";
  const explanation4 = "Blah blah blah 4";
  const hdurl4 =
      "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo.png";
  const title4 = "Stereo Jupiter near Opposition";
  const url4 =
      "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo1200.png";

  const date5 = "2023-11-25";
  const explanation5 = "Blah blah blah 5";
  const hdurl5 =
      "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_2048.jpg";
  const title5 = "Little Planet Aurora";
  const url5 =
      "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_1024.jpg";

  const date6 = "2023-11-26";
  const explanation6 = "Blah blah blah 6";
  const hdurl6 =
      "https://apod.nasa.gov/apod/image/2311/Jet67P_Rosetta_2048.jpg";
  const title6 = "A Dust Jet from the Surface of Comet 67P";
  const url6 = "https://apod.nasa.gov/apod/image/2311/Jet67P_Rosetta_960.jpg";

  group("pagination:", () {
    const fullPictureListJson = """
[
  {
    "date": "$date1",
    "explanation": "$explanation1",
    "hdurl": "$hdurl1",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title1",
    "url": "$url1"
  },
  {
    "date": "$date2",
    "explanation": "$explanation2",
    "hdurl": "$hdurl2",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title2",
    "url": "$url2"
  },
  {
    "date": "$date3",
    "explanation": "$explanation3",
    "hdurl": "$hdurl3",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title3",
    "url": "$url3"
  },
  {
    "date": "$date4",
    "explanation": "$explanation4",
    "hdurl": "$hdurl4",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title4",
    "url": "$url4"
  },
  {
    "date": "$date5",
    "explanation": "$explanation5",
    "hdurl": "$hdurl5",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title5",
    "url": "$url5"
  },
  {
    "date": "$date6",
    "explanation": "$explanation6",
    "hdurl": "$hdurl6",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title6",
    "url": "$url6"
  }
]
""";
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
    final picture4 = AstronomyPictureApiModel.fromStringData(
      dateIso8601: date4,
      title: title4,
      explanation: explanation4,
      mediumDefinitionUrl: url4,
      highDefinitionUrl: hdurl4,
    );
    final picture5 = AstronomyPictureApiModel.fromStringData(
      dateIso8601: date5,
      title: title5,
      explanation: explanation5,
      mediumDefinitionUrl: url5,
      highDefinitionUrl: hdurl5,
    );
    final picture6 = AstronomyPictureApiModel.fromStringData(
      dateIso8601: date6,
      title: title6,
      explanation: explanation6,
      mediumDefinitionUrl: url6,
      highDefinitionUrl: hdurl6,
    );

    final DateRange dateRange = DateRange.parse(
      startDateISO8601: date1,
      endDateISO8601: date6,
    );
    test(
        '"page" = 1 and "pictures per page" = 6: should return the entire picture list',
        () async {
      // Arrange

      const page1 = Page.first();
      const sixPerPage = PicturesPerPage(6);
      final queryParameters = <String, dynamic>{
        'start_date': date1,
        'end_date': date6,
      };

      /// Mandatory request options according to the given date range.
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
      final okResponseWithFullContent = Response(
        statusCode: 200,
        requestOptions: requestOptions,
        data: jsonDecode(fullPictureListJson),
        // data: fullList,
      );
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => okResponseWithFullContent);

      // Act
      final picturesWithPagination = await remoteDataSourceDioImpl
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page1,
        picturesPerPage: sixPerPage,
      );
      final paginatedPictures = picturesWithPagination.currentPagePictures;

      // Verify
      assert(paginatedPictures.length == 6);
      expect(picture1 == paginatedPictures[0], true);
      expect(picture2 == paginatedPictures[1], true);
      expect(picture3 == paginatedPictures[2], true);
      expect(picture4 == paginatedPictures[3], true);
      expect(picture5 == paginatedPictures[4], true);
      expect(picture6 == paginatedPictures[5], true);
    });
    test(
        '"page" = 2 and "pictures per page" = 2: should return pictures 3 and 4',
        () async {
      // Arrange

      const page2 = Page(2);
      const twoPicturesPerPage = PicturesPerPage(2);
      const pictureListJson = """
[
  {
    "date": "$date3",
    "explanation": "$explanation3",
    "hdurl": "$hdurl3",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title3",
    "url": "$url3"
  },
  {
    "date": "$date4",
    "explanation": "$explanation4",
    "hdurl": "$hdurl4",
    "media_type": "image",
    "service_version": "v1",
    "title": "$title4",
    "url": "$url4"
  }
]
""";
      final queryParameters = <String, dynamic>{
        'start_date': date3,
        'end_date': date4,
      };

      /// Mandatory request options according to the given date range.
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
      final okResponseWithPage2Content = Response(
        statusCode: 200,
        requestOptions: requestOptions,
        data: jsonDecode(pictureListJson),
        // data: fullList,
      );
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => okResponseWithPage2Content);

      // Act
      final picturesWithPagination = await remoteDataSourceDioImpl
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page2,
        picturesPerPage: twoPicturesPerPage,
      );
      final paginatedPictures = picturesWithPagination.currentPagePictures;

      // Verify
      assert(paginatedPictures.length == 2);
      expect(picture3 == paginatedPictures[0], true);
      expect(picture4 == paginatedPictures[1], true);
    });
    test(
        'edge case "page = 111" and "pictures per page = 333" should return the entire picture list',
        () async {
      // Arrange

      const page111 = Page(111);
      const severalPicturesPerPage = PicturesPerPage(333);
      final queryParameters = <String, dynamic>{
        'start_date': date1,
        'end_date': date6,
      };

      /// Mandatory request options according to the given date range.
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
      final okResponseWithPage2Content = Response(
        statusCode: 200,
        requestOptions: requestOptions,
        data: jsonDecode(fullPictureListJson),
        // data: fullList,
      );
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: queryParameters,
        ),
      ).thenAnswer((_) async => okResponseWithPage2Content);

      // Act
      final picturesWithPagination = await remoteDataSourceDioImpl
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: page111,
        picturesPerPage: severalPicturesPerPage,
      );
      final paginatedPictures = picturesWithPagination.currentPagePictures;

      // Verify
      assert(paginatedPictures.length == 6);
      expect(picture1 == paginatedPictures[0], true);
      expect(picture2 == paginatedPictures[1], true);
      expect(picture3 == paginatedPictures[2], true);
      expect(picture4 == paginatedPictures[3], true);
      expect(picture5 == paginatedPictures[4], true);
      expect(picture6 == paginatedPictures[5], true);
    });
    test('No pictures (http code 204): should return an empty list', () async {
      // Arrange
      final DateRange dateRange = DateRange.parse(
        startDateISO8601: date1,
        endDateISO8601: date6,
      );

      final queryParameters = <String, dynamic>{
        'start_date': date1,
        'end_date': date6,
      };

      /// Mandatory request options according to the given date range.
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
      final okResponseWithNoContent = Response(
        statusCode: 204,
        requestOptions: requestOptions,
        data: [],
      );

      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((_) async => okResponseWithNoContent);
      // Act
      final picturesWithPagination = await remoteDataSourceDioImpl
          .getAstronomyPicturesWithPaginationByDateRange(
        dateRange,
        page: const Page.first(),
        picturesPerPage: const PicturesPerPage(6),
      );
      const emptyPictures = AstronomyPicturesWithPagination.empty();

      // Verify
      assert(picturesWithPagination.currentPagePictures.isEmpty);
      expect(
        picturesWithPagination.currentPage == emptyPictures.currentPage,
        true,
      );
      expect(picturesWithPagination.lastPage == emptyPictures.lastPage, true);
      expect(
        picturesWithPagination.totalPictures == emptyPictures.totalPictures,
        true,
      );
    });
  });

  group("invalid http request", () {
    test('http code other than 200 or 204: should throw "DataSourceException"',
        () async {
      // Arrange

      final DateRange dateRange = DateRange.parse(
        startDateISO8601: date1,
        endDateISO8601: date6,
      );

      final queryParameters = <String, dynamic>{
        'start_date': date1,
        'end_date': date6,
      };

      /// Mandatory request options according to the given date range.
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
      final clientErrorResponse = Response(
        statusCode: 400,
        requestOptions: requestOptions,
      );

      bool dataSourceExceptionWasThrown = false;
      // Stub
      when(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((_) async => clientErrorResponse);
      // Act
      try {
        await remoteDataSourceDioImpl
            .getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: const Page(3),
          picturesPerPage: const PicturesPerPage(4),
        );
      } on DataSourceException {
        dataSourceExceptionWasThrown = true;
      }
      assert(dataSourceExceptionWasThrown, true);
      // Must have called 'get' with the right data just once.
      verify(
        () => mockDio.get(
          AstronomyPictureApiModel.apodPath,
          queryParameters: any(named: "queryParameters"),
        ),
      ).called(1);
    });
  });

  group('When Dio throws "DioException', () {
    test('should encapsulate "DioExcepton" in a "DataSourceException"',
        () async {
      // Arrange
      const page1 = Page.first();
      const sixPerPage = PicturesPerPage(6);
      final DateRange dateRange = DateRange.parse(
        startDateISO8601: date1,
        endDateISO8601: date6,
      );
      final queryParameters = <String, dynamic>{
        'start_date': date1,
        'end_date': date6,
      };
      final requestOptions = RequestOptions(
        path: AstronomyPictureApiModel.apodPath,
        queryParameters: queryParameters,
      );
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
        await remoteDataSourceDioImpl
            .getAstronomyPicturesWithPaginationByDateRange(
          dateRange,
          page: page1,
          picturesPerPage: sixPerPage,
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
