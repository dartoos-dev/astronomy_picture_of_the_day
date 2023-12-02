import '../../../../shared/value_objects/greater_than_zero.dart';
import 'pictures_per_page.dart';
import 'total_pictures.dart';

/// Represents a single pagination page value.
///
/// **Precondition**: the page value must be greater than zero.
final class Page extends GreaterThanZero {
  /// Sets the page number and asserts that it is greater than zero.
  const Page(super.value);

  /// Page 1.
  const Page.first() : this(1);

  /// The last page according to the number of pictures and the number of
  /// pictures per page.
  Page.last(TotalPictures total, PicturesPerPage perPage)
      : this((total.value / perPage.value).ceil());

  /// Checks whether this page is numerically greater than [other].
  ///
  /// Returns `true` if this page is greater than [other]; `false` otherwise.
  bool operator >(Page other) => value > other.value;
}
