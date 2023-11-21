import '../entities/astronomy_picture.dart';
import '../errors/astronomy_picture_failure.dart';
import '../repositories/astronomy_picture_repo.dart';
import '../value_objects/date_range.dart';

/// Presenter of Astronomy Picture Info — converts domain-specific data into
/// ready-to-consume values (String, int, bool) for the view.
abstract interface class AstronomyPicturePresenter {
  /// Presents a successful retrieval operation.
  void success(List<AstronomyPicture> pictures);

  /// Presents a failure operation.
  void failure(AstronomyPictureFailure failure);
}

abstract interface class GetAstronomyPicturesByDateRange {
  /// Retrieves and process astronomy images.
  Future<void> call(
    DateRange range,
    AstronomyPicturePresenter presenter,
  );
}

final class GetAstronomyPicturesByDateRangeImpl
    implements GetAstronomyPicturesByDateRange {
  const GetAstronomyPicturesByDateRangeImpl(this.repo);

  final AstronomyPictureRepo repo;

  @override
  Future<void> call(
    DateRange range,
    AstronomyPicturePresenter presenter,
  ) async {
    final result = await repo.getAstronomyPicturesByDateRange(range);
    result.fold(presenter.failure, presenter.success);
  }
}
