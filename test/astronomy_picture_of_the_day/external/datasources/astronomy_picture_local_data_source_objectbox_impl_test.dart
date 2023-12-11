import 'dart:io';

import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_api_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_objectbox_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/dtos/pagination.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/external/datasources/astronomy_picture_local_data_source_objectbox_impl.dart';
import 'package:astronomy_picture_of_the_day/objectbox.g.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/data_source_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<AstronomyPictureObjectboxModel> {}

class MockQuery extends Mock implements Query<AstronomyPictureObjectboxModel> {}

class MockQueryBuilder extends Mock
    implements QueryBuilder<AstronomyPictureObjectboxModel> {}

class MockQueryProperty extends Mock
    implements QueryProperty<AstronomyPictureObjectboxModel, Object?> {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AstronomyPictureLocalDataSourceObjectboxImpl localDataSource;

  final dateRange = DateRange(
    start: DateTime.parse('2023-11-21'),
    end: DateTime.parse('2023-11-30'),
  );
  final pagination = Pagination(
    range: dateRange,
    page: const Page.first(),
    perPage: const PicturesPerPage.seven(),
  );
  const objectboxTestFolderPath = './objectbox_test';

  setUpAll(() {
    registerFallbackValue(Pagination.oneWeek());
  });
  tearDownAll(() {
    Directory(objectboxTestFolderPath).delete(recursive: true);
  });
  group('Test Objectbox', () {
    late Store testStore;
    late Box<AstronomyPictureObjectboxModel> testBox;
    setUp(() async {
      testStore = await openStore(directory: objectboxTestFolderPath);
      testBox = testStore.box();
      localDataSource = AstronomyPictureLocalDataSourceObjectboxImpl(testBox);
    });
    tearDown(() {
      testStore.close();
    });
    group('with an empty database:', () {
      test('predicate methods checking for existance should return false',
          () async {
        final containsPictures =
            await localDataSource.containsPictures(pagination);
        expect(containsPictures, false);
      });
      test('fetching methods should return empty values', () async {
        const zeroPage = Page.zero();
        const zeroTotal = TotalPictures.zero();
        final pictures = await localDataSource.getAstronomyPictures(pagination);
        expect(pictures.currentPagePictures, const <AstronomyPicture>[]);
        expect(pictures.currentPage, const Page.first());
        expect(pictures.lastPage, zeroPage);
        expect(pictures.totalPictures, zeroTotal);
      });
    });
    group('with a database containing 10 pictures:', () {
      final picture1 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-21",
          title: "Fleming's Triangular Wisp",
          explanation: "Blah blah blah 1",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_960.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_2801.jpg",
        ),
      );

      final picture2 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-22",
          title: "IC 342: Hidden Galaxy in Camelopardalis",
          explanation: "Blah blah blah 2",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/ic342asi294large_1024.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/ic342asi294large.jpg",
        ),
      );

      final picture3 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-23",
          title: "Along the Taurus Molecular Cloud",
          explanation: "Blah blah blah 3",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/ngc1555wide1024.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/ngc1555wide4096.jpg",
        ),
      );
      final picture4 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-24",
          title: "Stereo Jupiter near Opposition",
          explanation: "Blah blah blah 4",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo1200.png",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo.png",
        ),
      );
      final picture5 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-25",
          title: "Little Planet Aurora",
          explanation: "Blah blah blah 5",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_1024.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_2048.jpg",
        ),
      );
      final picture6 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-26",
          title: "A Dust Jet from the Surface of Comet 67P",
          explanation: "Blah blah blah 6",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Jet67P_Rosetta_960.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Jet67P_Rosetta_2048.jpg",
        ),
      );
      final picture7 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-27",
          title: "LBN 86: The Eagle Ray Nebula",
          explanation: "Blah blah blah 7",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/EagleRay_Chander_960.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/EagleRay_Chander_3277.jpg",
        ),
      );
      final picture8 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-28",
          title: "Ganymede from Juno",
          explanation: "Blah blah blah 8",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Ganymede2_JunoGill_960.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/Ganymede2_JunoGill_3445.jpg",
        ),
      );
      final picture9 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-29",
          title: "A Landspout Tornado over Kansas",
          explanation: "Blah blah blah 9",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/LowerLandspout_Hannon_960.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/LowerLandspout_Hannon_960.jpg",
        ),
      );
      final picture10 = AstronomyPictureObjectboxModel.fromEntity(
        AstronomyPictureApiModel.fromStringData(
          dateIso8601: "2023-11-30",
          title: "Artemis 1: Flight Day 13",
          explanation: "Blah blah blah 10",
          mediumDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/art001e000672-orig1024c.jpg",
          highDefinitionUrl:
              "https://apod.nasa.gov/apod/image/2311/art001e000672-orig.jpg",
        ),
      );
      setUp(() {
        testBox.putMany([
          AstronomyPictureObjectboxModel.fromEntity(picture1),
          AstronomyPictureObjectboxModel.fromEntity(picture2),
          AstronomyPictureObjectboxModel.fromEntity(picture3),
          AstronomyPictureObjectboxModel.fromEntity(picture4),
          AstronomyPictureObjectboxModel.fromEntity(picture5),
          AstronomyPictureObjectboxModel.fromEntity(picture6),
          AstronomyPictureObjectboxModel.fromEntity(picture7),
          AstronomyPictureObjectboxModel.fromEntity(picture8),
          AstronomyPictureObjectboxModel.fromEntity(picture9),
          AstronomyPictureObjectboxModel.fromEntity(picture10),
        ]);
      });
      tearDown(() {
        testBox.removeAll();
      });
      final range1To10 = DateRange(start: picture1.date, end: picture10.date);
      final date1 = range1To10.startDateIso8601;
      final date10 = range1To10.endDateIso8601;
      const page1 = Page.first();
      const page2 = Page(2);
      const page3 = Page(3);
      const page4 = Page(4);
      const page10 = Page(10);
      const page11 = Page(11);
      const onePerPage = PicturesPerPage(1);
      const fourPerPage = PicturesPerPage(4);
      const aHundredPerPage = PicturesPerPage(100);
      group('method "containsPictures" and range between $date1 and $date10',
          () {
        test('should return true when page is 1 and perPage is 1', () async {
          final page1PerPage1 = Pagination(
            range: range1To10,
            page: page1,
            perPage: onePerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page1PerPage1);
          expect(containsPictures, true);
        });
        test('should return true when page is 1 and perPage is 100', () async {
          final page1PerPage100 = Pagination(
            range: range1To10,
            page: page1,
            perPage: aHundredPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page1PerPage100);
          expect(containsPictures, true);
        });
        test('should return false when page is 2 and perPage is 100', () async {
          final page2PerPage100 = Pagination(
            range: range1To10,
            page: page2,
            perPage: aHundredPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page2PerPage100);
          expect(containsPictures, false);
        });
        test('should return true when page is 10 and perPage is 1', () async {
          final page10PerPage1 = Pagination(
            range: range1To10,
            page: page10,
            perPage: onePerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page10PerPage1);
          expect(containsPictures, true);
        });
        test('should return false when page is 11 and perPage is 1', () async {
          final page11PerPage1 = Pagination(
            range: range1To10,
            page: page11,
            perPage: onePerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page11PerPage1);
          expect(containsPictures, false);
        });
        test('should return true when page is 1 and perPage is 4', () async {
          final page1PerPage4 = Pagination(
            range: range1To10,
            page: page1,
            perPage: fourPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page1PerPage4);
          expect(containsPictures, true);
        });
        test('should return true when page is 2 and perPage is 4', () async {
          final page2PerPage4 = Pagination(
            range: range1To10,
            page: page2,
            perPage: fourPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page2PerPage4);
          expect(containsPictures, true);
        });
        test('should return true when page is 3 and perPage is 4', () async {
          final page3PerPage4 = Pagination(
            range: range1To10,
            page: page3,
            perPage: fourPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page3PerPage4);
          expect(containsPictures, true);
        });
        test('should return false when page is 4 and perPage is 4', () async {
          final page4PerPage4 = Pagination(
            range: range1To10,
            page: page4,
            perPage: fourPerPage,
          );
          final containsPictures =
              await localDataSource.containsPictures(page4PerPage4);
          expect(containsPictures, false);
        });
      });
      group('method "containsPicture" with "wider" date ranges', () {
        final oneDayEarlierRange = DateRange(
          start: picture1.date.subtract(const Duration(days: 1)),
          end: picture10.date,
        );
        final oneDayLaterRange = DateRange(
          start: picture1.date,
          end: picture10.date.add(const Duration(days: 1)),
        );
        final oneDayEarlierAndOneDayLaterRange = DateRange(
          start: picture1.date.subtract(const Duration(days: 1)),
          end: picture10.date.add(const Duration(days: 1)),
        );
        test('should return false when date range is earlier', () async {
          final oneDayEarlierPage1PerPage1 = Pagination(
            range: oneDayEarlierRange,
            page: page1,
            perPage: onePerPage,
          );
          final containsPicturesOneDayEarlier = await localDataSource
              .containsPictures(oneDayEarlierPage1PerPage1);
          expect(containsPicturesOneDayEarlier, false);
        });

        test('should return false when date range is later', () async {
          final oneDayLaterPage1PerPage1 = Pagination(
            range: oneDayLaterRange,
            page: page1,
            perPage: onePerPage,
          );
          final containsPicturesOneDayLater =
              await localDataSource.containsPictures(oneDayLaterPage1PerPage1);
          expect(containsPicturesOneDayLater, false);
        });

        test('should return false when date range is both earlier and later',
            () async {
          final oneDayEarlierAndOneDayLaterPage1PerPage1 = Pagination(
            range: oneDayEarlierAndOneDayLaterRange,
            page: page1,
            perPage: onePerPage,
          );
          final containsPicturesOneDayEarlierAndOneDayLater =
              await localDataSource
                  .containsPictures(oneDayEarlierAndOneDayLaterPage1PerPage1);
          expect(containsPicturesOneDayEarlierAndOneDayLater, false);
        });
      });
      group('method "getAstronomyPictures:"', () {
        test('should return pictures according to pagination', () async {
          final page1PerPage4 = Pagination(
            range: range1To10,
            page: page1,
            perPage: fourPerPage,
          );
          final firstPage =
              await localDataSource.getAstronomyPictures(page1PerPage4);
          expect(
            firstPage.currentPagePictures,
            equals([picture10, picture9, picture8, picture7]),
          );

          final page2PerPage4 = Pagination(
            range: range1To10,
            page: page2,
            perPage: fourPerPage,
          );
          final secondPage =
              await localDataSource.getAstronomyPictures(page2PerPage4);
          expect(
            secondPage.currentPagePictures,
            equals([picture6, picture5, picture4, picture3]),
          );
          final page3PerPage4 = Pagination(
            range: range1To10,
            page: page3,
            perPage: fourPerPage,
          );
          final lastPage =
              await localDataSource.getAstronomyPictures(page3PerPage4);
          expect(lastPage.currentPagePictures, equals([picture2, picture1]));

          final page4PerPage4 = Pagination(
            range: range1To10,
            page: page4,
            perPage: fourPerPage,
          );
          final pastTheEndPage =
              await localDataSource.getAstronomyPictures(page4PerPage4);
          expect(pastTheEndPage.currentPagePictures.isEmpty, true);
        });
      });
    });
  });
  group('Resource release:', () {
    late MockBox mockBox;
    late MockQuery mockQuery;
    late MockQueryBuilder mockQueryBuilder;
    setUp(() async {
      mockBox = MockBox();
      mockQuery = MockQuery();
      mockQueryBuilder = MockQueryBuilder();
      localDataSource = AstronomyPictureLocalDataSourceObjectboxImpl(mockBox);
      registerFallbackValue(MockQueryProperty());
      when(() => mockBox.query(any())).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.build()).thenReturn(mockQuery);
      when(
        () => mockQueryBuilder.order(
          AstronomyPictureObjectboxModel_.date,
          flags: Order.descending,
        ),
      ).thenReturn(mockQueryBuilder);
      when(() => mockQuery.count()).thenReturn(0);
      when(() => mockQuery.find()).thenReturn(const []);
    });
    test('method "containsPictures" should close the 3 Query objects it uses',
        () {
      localDataSource.containsPictures(pagination);
      verify(() => mockQuery.close()).called(3);
    });
    test('method "getAstronomyPictures" should close "Query" object', () {
      localDataSource.getAstronomyPictures(pagination);
      verify(() => mockQuery.close()).called(1);
    });
  });
  group('Error handling: ', () {
    late MockBox mockBox;
    late MockQuery mockQuery;
    late MockQueryBuilder mockQueryBuilder;
    final exception = Exception('Objectbox error');
    setUp(() {
      mockBox = MockBox();
      mockQuery = MockQuery();
      mockQueryBuilder = MockQueryBuilder();
      localDataSource = AstronomyPictureLocalDataSourceObjectboxImpl(mockBox);
      registerFallbackValue(MockQueryProperty());
      when(() => mockBox.query(any())).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.build()).thenReturn(mockQuery);
      when(
        () => mockQueryBuilder.order(
          AstronomyPictureObjectboxModel_.date,
          flags: Order.descending,
        ),
      ).thenReturn(mockQueryBuilder);
      when(() => mockQuery.count()).thenReturn(0);
    });
    test('method "saveAstronomyPictuers" should throw "DataSourceException"',
        () async {
      when(() => mockBox.putMany(any())).thenThrow(exception);
      bool caughtDataSourceException = false;
      try {
        await localDataSource.saveAstronomyPictures(const []);
      } on DataSourceException catch (ex) {
        caughtDataSourceException = true;
        expect(ex.exception, same(exception));
      }
      expect(caughtDataSourceException, true);
    });
    test('method "containsPictures" should throw "DataSourceException"',
        () async {
      when(() => mockQuery.count()).thenThrow(exception);
      bool caughtDataSourceException = false;
      try {
        await localDataSource.containsPictures(pagination);
      } on DataSourceException catch (ex) {
        caughtDataSourceException = true;
        expect(ex.exception, same(exception));
      }
      expect(caughtDataSourceException, true);
    });
    test('method "getAstronomyPictures" should throw "DataSourceException"',
        () async {
      when(() => mockQuery.find()).thenThrow(exception);
      bool caughtDataSourceException = false;
      try {
        await localDataSource.getAstronomyPictures(pagination);
      } on DataSourceException catch (ex) {
        caughtDataSourceException = true;
        expect(ex.exception, same(exception));
      }
      expect(caughtDataSourceException, true);
    });
  });
}
