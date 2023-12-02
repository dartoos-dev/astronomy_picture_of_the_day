import '../dtos/astronomy_pictures_with_pagination.dart';
import '../errors/astronomy_picture_failure.dart';

/// Presenter of Astronomy Picture Info — converts domain-specific data into
/// ready-to-consume values (date as formatted/localized string, int, bool) for
/// the view.
abstract interface class AstronomyPicturePresenter {
  /// Presents a successful retrieval operation.
  void success(AstronomyPicturesWithPagination astronomyPictures);

  /// Presents a failure operation.
  void failure(AstronomyPictureFailure failure);
}
