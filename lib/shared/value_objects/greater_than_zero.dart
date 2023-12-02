import 'single_value.dart';

/// Represents a integer value greater than zero.
///
/// **Precondition**: the given value must be greater than zero.
class GreaterThanZero extends SingleValue<int> {
  /// Sets [value] and asserts that it is greater than zero.
  const GreaterThanZero(super.value)
      : assert(
          value > 0,
          'The given value must be > 0; "$value".',
        );
}
