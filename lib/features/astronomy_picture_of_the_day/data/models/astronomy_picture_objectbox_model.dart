import 'package:objectbox/objectbox.dart';

import '../../../../shared/value_objects/id.dart';
import '../../domain/entities/astronomy_picture.dart';

/// [AstronomyPicture] model with Objectbox database annotations.
@Entity()
final class AstronomyPictureObjectboxModel extends AstronomyPicture {
  AstronomyPictureObjectboxModel({
    this.pk = 0,
    required super.date,
    required super.title,
    required super.explanation,
    required String dbId,
    required String dbMediumDefinitionUrl,
    required String dbHighDefinitionUrl,
  }) : super(
          id: ID(dbId),
          mediumDefinitionUrl: Uri.parse(dbMediumDefinitionUrl),
          highDefinitionUrl: Uri.parse(dbHighDefinitionUrl),
        );

  AstronomyPictureObjectboxModel.fromEntity(AstronomyPicture entity)
      : this(
          date: entity.date,
          title: entity.title,
          explanation: entity.explanation,
          dbId: entity.id.value,
          dbMediumDefinitionUrl: entity.mediumDefinitionUrl.toString(),
          dbHighDefinitionUrl: entity.highDefinitionUrl.toString(),
        );

  /// Objectbox mandatory primary key.
  @Id()
  int pk;

  /// The entity's own id is used as a unique key.
  @Unique(onConflict: ConflictStrategy.replace)
  String get dbId => super.id.value;

  @Property(type: PropertyType.date)
  @override
  DateTime get date => super.date;

  @Property()
  @override
  String get title => super.title;

  @Property()
  @override
  String get explanation => super.explanation;

  /// Conversion required because Objectbox does not support [Uri] types.
  @Property()
  String get dbMediumDefinitionUrl => super.mediumDefinitionUrl.toString();

  /// Conversion required because Objectbox does not support [Uri] types.
  @Property()
  String get dbHighDefinitionUrl => super.highDefinitionUrl.toString();
}
