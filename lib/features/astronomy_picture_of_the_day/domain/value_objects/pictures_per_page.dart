import 'package:astronomy_picture_of_the_day/shared/value_objects/greater_than_zero.dart';

/// Represents the amount of pictuers per page.
///
/// **Precondition**: must be greater than zero.
final class PicturesPerPage extends GreaterThanZero {
  /// Sets the number of pictures and asserts that it is greater than zero.
  const PicturesPerPage(super.value);

  /// 7 pictures per page.
  const PicturesPerPage.seven() : this(7);
}
