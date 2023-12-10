import 'package:equatable/equatable.dart';

import '../value_objects/id.dart';

/// Represents an entity with a typed ID.
abstract class Entity with EquatableMixin {
  const Entity({this.id = const ID.empty()});

  /// The entity's ID;
  final ID<Entity> id;

  /// Equality by [id].
  @override
  List<Object?> get props => [id];
}
