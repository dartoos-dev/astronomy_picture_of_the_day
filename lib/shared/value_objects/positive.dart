import 'single_value.dart';

/// Represents a positive integer value.
///
/// **Precondition**: the given value must be greater than or equal to zero.
class Positive extends SingleValue<int> {
  /// Sets [value] and asserts that it is greater than or equal to zero.
  const Positive(super.value)
      : assert(
          value > -1,
          'The given value must be positive (>= 0); "$value".',
        );
}
