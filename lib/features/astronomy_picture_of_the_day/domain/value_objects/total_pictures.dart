import '../../../../shared/value_objects/positive.dart';
import 'date_range.dart';

/// Represents the total number of pictures regardless of pagination.
///
/// **Precondition**: value must be greater than zero.
final class TotalPictures extends Positive {
  /// Sets the number of pictures and asserts that it is greater than zero.
  const TotalPictures(super.value);

  /// Total = 0.
  const TotalPictures.zero() : this(0);

  /// The number of pictures is equal to the number of days in the date range.
  TotalPictures.onePicturePerDay(DateRange range) : this(range.days);

  /// Checks whether this total is numerically greater than or equal to [other].
  ///
  /// Returns `true` if this total is greater than or equal to [other]; `false`
  /// otherwise.
  bool operator >=(TotalPictures other) => value >= other.value;
}
