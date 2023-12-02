import 'single_value.dart';

/// Represents a typed ID.
final class ID<T extends Object> extends SingleValue<String>
    implements Comparable<ID<T>> {
  /// Sets the ID value.
  const ID(super.value);

  /// The [value] is the String representation.
  @override
  String toString() => value;

  /// Ascending (lexicographic) order by [value].
  @override
  int compareTo(ID<T> other) => value.compareTo(other.value);
}
