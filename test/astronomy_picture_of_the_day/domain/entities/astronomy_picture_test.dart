import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:astronomy_picture_of_the_day/shared/value_objects/id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main constructor', () {
    final date = DateTime.parse("2023-11-20");
    final hdurl = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg",
    );
    final url = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg",
    );
    const explanation = "Blah blah blah";
    const title = "The Horsehead Nebula";
    final astronomyPicture = AstronomyPicture(
      date: date,
      title: title,
      explanation: explanation,
      highDefinitionUrl: hdurl,
      mediumDefinitionUrl: url,
    );
    test('should extract "date" as is', () async {
      expect(astronomyPicture.date, equals(date));
    });
    test('should extract "title" as is', () async {
      expect(astronomyPicture.title, equals(title));
    });
    test('should extract "explanation" as is', () async {
      expect(astronomyPicture.explanation, equals(explanation));
    });
    test('should extract "hdurl" as is', () async {
      expect(astronomyPicture.highDefinitionUrl, equals(hdurl));
    });
    test('should extract "url" as is', () async {
      expect(astronomyPicture.mediumDefinitionUrl, equals(url));
    });
    test('should sort by date in descending order', () {
      final picture1 = AstronomyPicture(
        date: DateTime.parse("2023-11-21"),
        title: "Fleming's Triangular Wisp",
        explanation: "Blah blah blah 1",
        mediumDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_960.jpg",
        ),
        highDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_2801.jpg",
        ),
      );

      final picture2 = AstronomyPicture(
        date: DateTime.parse("2023-11-22"),
        title: "IC 342: Hidden Galaxy in Camelopardalis",
        explanation: "Blah blah blah 2",
        mediumDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/ic342asi294large_1024.jpg",
        ),
        highDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/ic342asi294large.jpg",
        ),
      );

      final picture3 = AstronomyPicture(
        date: DateTime.parse("2023-11-23"),
        title: "Along the Taurus Molecular Cloud",
        explanation: "Blah blah blah 3",
        mediumDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/ngc1555wide1024.jpg",
        ),
        highDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/ngc1555wide4096.jpg",
        ),
      );
      final picture4 = AstronomyPicture(
        date: DateTime.parse("2023-11-24"),
        title: "Stereo Jupiter near Opposition",
        explanation: "Blah blah blah 4",
        mediumDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo1200.png",
        ),
        highDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/2023-11-17-1617_1632-Jupiter_Stereo.png",
        ),
      );
      final picture5 = AstronomyPicture(
        date: DateTime.parse("2023-11-25"),
        title: "Little Planet Aurora",
        explanation: "Blah blah blah 5",
        mediumDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_1024.jpg",
        ),
        highDefinitionUrl: Uri.parse(
          "https://apod.nasa.gov/apod/image/2311/Kirkjufell2023Nov9_2048.jpg",
        ),
      );
      final unsortedList = [picture1, picture3, picture5, picture2, picture4];
      expect(unsortedList..sort(), [
        picture5,
        picture4,
        picture3,
        picture2,
        picture1,
      ]);
    });
  });

  group("equality operator '=='", () {
    const id1 = ID<AstronomyPicture>("abc-123");
    const id2 = ID<AstronomyPicture>("abc-1234");
    final date1 = DateTime.parse("2023-11-20");
    final hdurl1 = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg",
    );
    final url1 = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg",
    );
    const explanation1 = "Blah blah blah 1";
    const title1 = "The Horsehead Nebula";

    final date2 = DateTime.parse("2023-11-21");
    const explanation2 = "Blah blah blah 2";
    final hdurl2 = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_2801.jpg",
    );
    const title2 = "Fleming's Triangular Wisp";
    final url2 = Uri.parse(
      "https://apod.nasa.gov/apod/image/2311/FlemingsWisp_Gualco_960.jpg",
    );

    final astronomyPicture1 = AstronomyPicture(
      id: id1,
      date: date1,
      title: title1,
      explanation: explanation1,
      highDefinitionUrl: hdurl1,
      mediumDefinitionUrl: url1,
    );
    final astronomyPictureLike1 = AstronomyPicture(
      id: id1,
      date: date1,
      title: title1,
      explanation: explanation1,
      highDefinitionUrl: hdurl1,
      mediumDefinitionUrl: url1,
    );
    final astronomyPictureQuiteLike1 = AstronomyPicture(
      id: id2,
      date: date1,
      title: title1,
      explanation: explanation1,
      highDefinitionUrl: hdurl1,
      mediumDefinitionUrl: url1,
    );
    final astronomyPicture2 = AstronomyPicture(
      id: id2,
      date: date2,
      title: title2,
      explanation: explanation2,
      highDefinitionUrl: hdurl2,
      mediumDefinitionUrl: url2,
    );

    test('should evaluate as true self-comparations', () async {
      expect(astronomyPicture1 == astronomyPicture1, true);
    });
    test(
        'should evaluate as true comparisons between differente objects that have the same property values',
        () async {
      expect(astronomyPicture1 == astronomyPictureLike1, true);
    });
    test(
        'should evaluate as false comparisons between objects that have only one different property between them',
        () async {
      expect(astronomyPicture1 == astronomyPictureQuiteLike1, false);
    });
    test(
        'should evaluate as false comparisons between objects with multiple different properties',
        () async {
      expect(astronomyPicture1 == astronomyPicture2, false);
    });
  });
}
