import 'error_key.dart';

/// Represents failures in the operation of astronomical images
sealed class AstronomyPictureFailure {
  const AstronomyPictureFailure(this.key);

  final ErrorKey key;
}

final class AstronomyPictureRetrievalFailure extends AstronomyPictureFailure {
  const AstronomyPictureRetrievalFailure() : super(ErrorKey.retrievalFailure);
}
