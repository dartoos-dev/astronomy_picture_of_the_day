import 'package:equatable/equatable.dart';

import '../../../../shared/value_objects/id.dart';

/// Astronomy picture entity with a typed ID.
class AstronomyPicture
    with EquatableMixin
    implements Comparable<AstronomyPicture> {
  const AstronomyPicture({
    this.id = const ID.empty(),
    required this.date,
    required this.title,
    required this.explanation,
    required this.mediumDefinitionUrl,
    required this.highDefinitionUrl,
  });

  final ID<AstronomyPicture> id;
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
      id,
      date,
      title,
      explanation,
      mediumDefinitionUrl,
      highDefinitionUrl,
    ];
  }

  /// Sorts in descending [date] order; in other words: the most recent images
  /// will be listed first.
  @override
  int compareTo(AstronomyPicture other) => other.date.compareTo(date);
}
