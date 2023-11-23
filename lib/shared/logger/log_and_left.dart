import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../errors/app_exception.dart';

/// Logs operation failures and returns a [Left] containing the failure object.
abstract interface class LogAndLeft {
  /// Logs [ex] and [stacktrace] and returns a [Left] to indicate a failure.
  Left<F, R> call<F, R>(
    F failure, {
    required AppException exception,
    String? message,
    StackTrace? stacktrace,
  });
}

/// Logs operation failures using a [Logger] object.
final class LogWithLogger implements LogAndLeft {
  const LogWithLogger(this.logger);

  final Logger logger;

  @override
  Left<F, R> call<F, R>(
    F failure, {
    required AppException exception,
    String? message,
    StackTrace? stacktrace,
  }) {
    final logMessage = message ?? exception.info;
    logger.e(logMessage, error: exception, stackTrace: stacktrace);
    return Left(failure);
  }
}
