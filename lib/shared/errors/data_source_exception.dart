import 'dart:io';

import 'app_exception.dart';

/// Represents I/O errors thrown by _DataSourse_ classes.
class DataSourceException extends AppException<String> implements IOException {
  /// Defines [info] as additional information and [exception] as the original
  /// thrown exception.
  const DataSourceException(super.info, {super.exception});
}
