import 'error_key.dart';

/// Represents failures in the operation of astronomy images
sealed class AstronomyPictureFailure {
  const AstronomyPictureFailure(this.key);

  final ErrorKey key;
}

final class RetrievalFailure extends AstronomyPictureFailure {
  const RetrievalFailure() : super(ErrorKey.retrievalFailure);
}

final class ConnectionCheckFailure extends AstronomyPictureFailure {
  const ConnectionCheckFailure() : super(ErrorKey.connectionCheckFailure);
}
