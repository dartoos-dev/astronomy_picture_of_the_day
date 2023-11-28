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

  /// Equality by [id], [date], [title], [explanation], [mediumDefinitionUrl]
  /// and [highDefinitionUrl].
  @override
  List<Object?> get props {
    return [
      super.props,
      date,
      title,
      explanation,
      mediumDefinitionUrl,
      highDefinitionUrl,
    ];
  }
}
