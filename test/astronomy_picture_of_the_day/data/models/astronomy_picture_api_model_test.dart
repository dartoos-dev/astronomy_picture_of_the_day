import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_api_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const date = "2023-11-20";
  const explanation = "Blah blah blah";
  const hdurl =
      "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg";
  const title = "The Horsehead Nebula";
  const url = "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg";

  group('constructor "fromJson"', () {
    final Map<String, dynamic> astronomyPictureJson = {
      "date": date,
      "title": title,
      "explanation": explanation,
      "hdurl": hdurl,
      "url": url,
      "copyright": "NASA 2023",
      "media_type": "image",
      "service_version": "v1",
    };
    final modelFromJson =
        AstronomyPictureApiModel.fromJson(astronomyPictureJson);
    test('should be a subclass of AstronomyPicture entity', () async {
      expect(modelFromJson, isA<AstronomyPicture>());
    });
    test('should extract "date" from the json object', () async {
      expect(modelFromJson.date, equals(DateTime.parse(date)));
    });
    test('should extract "title" from the json object', () async {
      expect(modelFromJson.title, equals(title));
    });
    test('should extract "explanation" from the json object', () async {
      expect(modelFromJson.explanation, equals(explanation));
    });
    test('should extract "hdurl" from the json object', () async {
      expect(modelFromJson.highDefinitionUrl, equals(Uri.parse(hdurl)));
    });
    test('should extract "url" from the json object', () async {
      expect(modelFromJson.mediumDefinitionUrl, equals(Uri.parse(url)));
    });
  });

  group('constructor "fromStringData"', () {
    final modelFromStringData = AstronomyPictureApiModel.fromStringData(
      dateIso8601: date,
      title: title,
      explanation: explanation,
      mediumDefinitionUrl: url,
      highDefinitionUrl: hdurl,
    );
    test('should be a subclass of AstronomyPicture entity', () async {
      expect(modelFromStringData, isA<AstronomyPicture>());
    });
    test('should extract "date" from the input string', () async {
      expect(modelFromStringData.date, equals(DateTime.parse(date)));
    });
    test('should extract "title" from the input string', () async {
      expect(modelFromStringData.title, equals(title));
    });
    test('should extract "explanation" from the input string', () async {
      expect(modelFromStringData.explanation, equals(explanation));
    });
    test('should extract "hdurl" from the input string', () async {
      expect(modelFromStringData.highDefinitionUrl, equals(Uri.parse(hdurl)));
    });
    test('should extract "url" from the input string', () async {
      expect(modelFromStringData.mediumDefinitionUrl, equals(Uri.parse(url)));
    });
  });
}
