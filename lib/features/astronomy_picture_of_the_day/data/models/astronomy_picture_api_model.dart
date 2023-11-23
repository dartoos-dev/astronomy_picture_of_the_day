import '../../domain/entities/astronomy_picture.dart';

/// [AstronomyPicture] model with mapping constructors.
final class AstronomyPictureApiModel extends AstronomyPicture {
  /// Maps an astronomical picture from the NASA API response json.
  ///
  /// Example of an actual request:
  ///
  /// https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2023-11-20
  ///
  /// ```json
  /// {
  ///   "copyright": "\nMark Hanson & \nMartin Pugh,\nSSRO, \nPROMPT, \nCTIO,\nNSF\n",
  ///   "date": "2023-11-20",
  ///   "explanation": "Sculpted by stellar winds and radiation, a magnificent
  ///   interstellar dust cloud by chance has assumed this recognizable shape.
  ///   Fittingly named the Horsehead Nebula, it is some 1,500 light-years
  ///   distant, embedded in the vast Orion cloud complex. About five
  ///   light-years \"tall,\" the dark cloud is cataloged as Barnard 33 and is
  ///   visible only because its obscuring dust is silhouetted against the
  ///   glowing red emission nebula IC 434.  Stars are forming within the dark
  ///   cloud. Contrasting blue reflection nebula NGC 2023, surrounding a hot,
  ///   young star, is at the lower left of the full image.  The featured
  ///   gorgeous color image combines both narrowband and broadband images
  ///   recorded using several different telescopes.    New: Follow APOD on
  ///   Telegram",
  ///   "hdurl": "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_2604.jpg",
  ///   "media_type": "image",
  ///   "service_version": "v1",
  ///   "title": "The Horsehead Nebula",
  ///   "url": "https://apod.nasa.gov/apod/image/2311/Horsehead_Hanson_960.jpg"
  /// }
  /// ```
  AstronomyPictureApiModel.fromJson(Map<String, dynamic> json)
      : super(
          date: DateTime.parse(json['date'] as String),
          explanation: json['explanation'] as String,
          title: json['title'] as String,
          highDefinitionUrl: Uri.parse(json['hdurl'] as String),
          mediumDefinitionUrl: Uri.parse(json['url'] as String),
        );
}
