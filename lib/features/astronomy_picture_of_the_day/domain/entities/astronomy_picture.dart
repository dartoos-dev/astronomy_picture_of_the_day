import '../../../../shared/entities/entity.dart';
import '../../../../shared/value_objects/id.dart';

class AstronomyPicture extends Entity {
  const AstronomyPicture({
    ID<AstronomyPicture>? id,
    required this.date,
    required this.title,
    required this.explanation,
    required this.mediumDefinitionUrl,
    required this.highDefinitionUrl,
  }) : super(id: id);

  final DateTime date;
  final String title;
  final String explanation;
  final Uri mediumDefinitionUrl;
  final Uri highDefinitionUrl;

  /// Compares this object with [other] by the properties [id], [date], [title],
  /// [explanation], [mediumDefinitionUrl] and [highDefinitionUrl].
  ///
  /// Compatible with Liskov's Substitution Principle.
  ///
  /// For more details:
  /// - [liskov-compatible-equals-hashcode](https://www.linkedin.com/pulse/liskov-compatible-equals-hashcode-doichin-iordanov/)
  // @override
  bool isEquivalentTo(AstronomyPicture other) {
    return (id == other.id) &&
        (date == other.date) &&
        (mediumDefinitionUrl == other.mediumDefinitionUrl) &&
        (highDefinitionUrl == other.highDefinitionUrl) &&
        (title == other.title) &&
        (explanation == other.explanation);
  }
}
