import '../../../../shared/value_objects/positive.dart';
import 'pictures_per_page.dart';
import 'total_pictures.dart';

/// Represents a single pagination page value.
///
/// **Precondition**: the page value must be greater than zero.
final class Page extends Positive {
  /// Sets the page number and asserts that it is greater than zero.
  const Page(super.value);

  /// Page 0; no page situation.
  const Page.zero() : this(0);

  /// Page 1.
  const Page.first() : this(1);

  /// The last page according to the number of pictures and the number of
  /// pictures per page.
  Page.last(TotalPictures total, PicturesPerPage perPage)
      : this((total.value / perPage.value).ceil());

  /// Calculates the 'offset' of this page according to the give [perPage].
  ///
  /// ```dart
  ///  const fourPerPage = PicturesPerPage(4);
  ///  const firstPage = Page(1);
  ///  const secondPage = Page(2);
  ///  const thirdPage = Page(3);
  ///  final offset1 = fistPage.offset(fourPerPage);
  ///  final offset2 = secondPage.offset(fourPerPage);
  ///  final offset3 = thirdPage.offset(fourPerPage);
  ///  print(offset1) // 0
  ///  print(offset2) // 4
  ///  print(offset3) // 8
  /// ```
  int offset(PicturesPerPage perPage) =>
      value > 1 ? perPage.value * (value - 1) : 0;

  /// Checks whether this page is numerically greater than [other].
  ///
  /// Returns `true` if this page is greater than [other]; `false` otherwise.
  bool operator >(Page other) => value > other.value;

  /// Checks whether this page is numerically greater than or equal to [other].
  ///
  /// Returns `true` if this page is greater than or equal to [other]; `false`
  /// otherwise.
  bool operator >=(Page other) => value >= other.value;
}
