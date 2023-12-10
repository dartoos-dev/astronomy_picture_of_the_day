import '../../../../shared/value_objects/id.dart';
import '../../domain/entities/astronomy_picture.dart';

/// [AstronomyPicture] model with mapping constructors.
final class AstronomyPictureApiModel extends AstronomyPicture {
  /// Constructs an [AstronomyPictureApiModel] from string data and, since there
  /// is only one image per day, sets the entity ID to the result of applying
  /// the sha256 algorithm to [dateIso8601].
  AstronomyPictureApiModel.fromStringData({
    required String dateIso8601,
    required super.title,
    required super.explanation,
    required String mediumDefinitionUrl,
    required String highDefinitionUrl,
  }) : super(
          id: ID.sha256(dateIso8601),
          date: DateTime.parse(dateIso8601),
          mediumDefinitionUrl: Uri.parse(mediumDefinitionUrl),
          highDefinitionUrl: Uri.parse(highDefinitionUrl),
        );

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
      : this.fromStringData(
          dateIso8601: json['date'] as String,
          explanation: json['explanation'] as String,
          title: json['title'] as String,
          highDefinitionUrl: json['hdurl'] as String,
          mediumDefinitionUrl: json['url'] as String,
        );

  static const nasaBaseUrl = 'https://api.nasa.gov';

  /// Url path of NASA's Astronomy Picture of the Day API.
  static const apodPath = '/planetary/apod';

  /// NASA's API documents state that '1995-06-15' is the first day an APOD
  /// picture was posted.
  static final minStartDate = DateTime.parse('1995-06-15');

  /// The maximum end date is the current date.
  static DateTime get maxEndDate => DateTime.now();
}
