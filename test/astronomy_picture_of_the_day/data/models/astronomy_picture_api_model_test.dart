import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/data/models/astronomy_picture_api_model.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = DateTime.parse("2023-11-20");
  const explanation = "This is a beatiful astronomy picture";
  const title = "Astronomy Picture";
  final highDefinitionUrl = Uri.parse(
    "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg",
  );

  final mediumDefinitionUrl = Uri.parse(
    "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg",
  );
  final Map<String, dynamic> astronomyPictureJson = {
    "date": date.toIso8601String(),
    "title": title,
    "explanation": explanation,
    "hdurl": highDefinitionUrl.toString(),
    "url": mediumDefinitionUrl.toString(),
    "copyright": "NASA 2023",
    "media_type": "image",
    "service_version": "v1",
  };
  group('constructor "fromJson"', () {
    final model = AstronomyPictureApiModel.fromJson(astronomyPictureJson);
    test('should be a subclass of AstronomyPicture entity', () async {
      expect(model, isA<AstronomyPicture>());
    });

    test('should extract "date" from the json object', () async {
      expect(model.date, equals(date));
    });
    test('should extract "title" from the json object', () async {
      expect(model.title, equals(title));
    });
    test('should extract "explanation" from the json object', () async {
      expect(model.explanation, equals(explanation));
    });
    test('should extract "hdurl" from the json object', () async {
      expect(model.highDefinitionUrl, equals(highDefinitionUrl));
    });
    test('should extract "url" from the json object', () async {
      expect(model.mediumDefinitionUrl, equals(mediumDefinitionUrl));
    });
  });
}
