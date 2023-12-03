import 'dart:io';

import 'app_exception.dart';

/// Represents I/O errors thrown by _Driver_ classes.
class DriverException extends AppException implements IOException {
  /// Defines [info] as additional information and [exception] as the original
  /// thrown exception.
  const DriverException(String super.info, {super.exception});
}
