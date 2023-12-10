import 'package:equatable/equatable.dart';

/// For classes that holds a single value.
abstract class SingleValue<T> with EquatableMixin {
  const SingleValue(this.value);

  /// The value.
  final T value;

  /// Equality by [value].
  @override
  List<Object?> get props => [value];

  /// Converts [value] to its string representation.
  @override
  String toString() => value.toString();
}
