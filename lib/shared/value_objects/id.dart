import 'package:crypto/crypto.dart';

import 'single_value.dart';

/// Represents a typed ID.
final class ID<T extends Object> extends SingleValue<String>
    implements Comparable<ID<T>> {
  /// Sets the ID value.
  const ID(super.value);

  /// Empty: the entity still has no actual Id.
  const ID.empty() : this('');

  /// Sets the value of this id as the result of applying the hash algorithm
  /// SHA-256 to [input].
  ///
  /// See also: [SHA-256](https://en.wikipedia.org/wiki/SHA-256)
  ID.sha256(String input) : this(sha256.convert(input.codeUnits).toString());

  /// Makes this id safe to be passed as a URL parameter.
  ID.urlSafe(String input) : this(Uri.encodeFull(input));

  /// The [value] is the String representation.
  @override
  String toString() => value;

  /// Ascending (lexicographic) order by [value].
  @override
  int compareTo(ID<T> other) => value.compareTo(other.value);
}
