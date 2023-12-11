import '../value_objects/date_range.dart';
import '../value_objects/page.dart';
import '../value_objects/pictures_per_page.dart';

/// Dto for transfering pagination-related parameters.
final class Pagination {
  const Pagination({
    required this.range,
    required this.page,
    required this.perPage,
  });

  /// Sets the date range to one week from now.
  Pagination.oneWeek({
    Page page = const Page.first(),
    PicturesPerPage perPage = const PicturesPerPage.seven(),
  }) : this(
          range: DateRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
          page: page,
          perPage: perPage,
        );

  /// The date range of the pictures.
  final DateRange range;

  /// The current page.
  final Page page;

  /// The number of pictures per page.
  final PicturesPerPage perPage;
}
