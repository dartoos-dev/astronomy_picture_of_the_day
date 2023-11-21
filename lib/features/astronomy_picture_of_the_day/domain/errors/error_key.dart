/// Error keys to be used for localization purposes — translation.
enum ErrorKey {
  retrievalFailure('retrieval-failure');

  const ErrorKey(this.value);

  /// The error key value.
  final String value;
}
