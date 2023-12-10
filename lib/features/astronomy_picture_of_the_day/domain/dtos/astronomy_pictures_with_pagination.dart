import '../entities/astronomy_picture.dart';
import '../value_objects/page.dart';
import '../value_objects/total_pictures.dart';

/// Paginated image list along with pagination information.
final class AstronomyPicturesWithPagination {
  const AstronomyPicturesWithPagination({
    required this.currentPage,
    required this.lastPage,
    required this.totalPictures,
    required this.currentPagePictures,
  });
  const AstronomyPicturesWithPagination.empty()
      : this(
          currentPage: const Page.zero(),
          lastPage: const Page.zero(),
          totalPictures: const TotalPictures.zero(),
          currentPagePictures: const [],
        );

  final Page currentPage;
  final Page lastPage;
  final TotalPictures totalPictures;
  final List<AstronomyPicture> currentPagePictures;
}
