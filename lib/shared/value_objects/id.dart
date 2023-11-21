import 'package:equatable/equatable.dart';

/// Represents a typed ID.
final class ID<T extends Object>
    with EquatableMixin
    implements Comparable<ID<T>> {
  /// Sets the ID value.
  const ID(this.value);

  /// The ID value.
  final String value;

  /// Equality by [value].
  @override
  List<Object?> get props => [value];

  /// [value] is the String representation.
  @override
  String toString() => value;

  /// Ascending (lexicographic) order by [value].
  @override
  int compareTo(ID<T> other) => value.compareTo(other.value);
}
