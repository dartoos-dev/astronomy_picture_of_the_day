/// Indicates  application-related errors.
///
/// It provides more context about errors.
class AppException<T> implements Exception {
  /// Defines [info] as additional information and [exception] as the original
  /// thrown exception.
  const AppException(this.info, {this.exception});

  /// Additional information about the error.
  ///
  /// For example, it could be:
  /// - a plain text message.
  /// - a key for localized messages.
  /// - an numeric error code.
  /// - an enum.
  final T info;

  /// The original exception.
  final Exception? exception;

  /// Returns [info] along with the original exception message.
  @override
  String toString() => '$info$_separator$_exceptionMessage';

  /// If [exception] is defined, it returns '\n'; otherwise, ''.
  String get _separator => exception != null ? '\n' : '';

  /// If [exception] is defined, its error message will be returned; otherwise,
  /// the empty string ''.
  String get _exceptionMessage => exception?.toString() ?? '';
}
