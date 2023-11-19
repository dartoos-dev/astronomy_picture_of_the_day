import 'dart:io';

import 'app_exception.dart';

/// Represents I/O errors thrown by _Datasourse_ classes.
class DatasourceException extends AppException<String> implements IOException {
  /// Defines [info] as additional information and [exception] as the original
  /// thrown exception.
  const DatasourceException(super.info, {super.exception});
}
