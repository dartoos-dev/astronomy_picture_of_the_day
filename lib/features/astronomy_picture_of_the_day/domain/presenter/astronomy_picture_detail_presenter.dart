import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/entities/astronomy_picture.dart';

import '../errors/astronomy_picture_failure.dart';

/// Presenter of Astronomy Picture Detail Info — converts domain-specific data
/// into ready-to-consume values (date as formatted/localized string, int, bool)
/// for the view.
abstract interface class AstronomyPictureDetailPresenter {
  /// Presents a successful retrieval of an astronomy picture.
  void success(AstronomyPicture astronomyPicture);

  /// Presents a unsuccessful retrieval of an astronomy picture.
  void notFound(String id);

  /// Presents a failure operation.
  void failure(AstronomyPictureFailure failure);
}
