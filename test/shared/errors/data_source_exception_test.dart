import 'package:astronomy_picture_of_the_day/shared/errors/app_exception.dart';
import 'package:astronomy_picture_of_the_day/shared/errors/data_source_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatasourceException:', () {
    const info = 'Additional info';
    final exception = Exception('Original Exception');
    final dataSourceException = DataSourceException(info, exception: exception);
    test('should be a subclass of "AppException"', () {
      expect(dataSourceException, isA<AppException>());
    });
    test('should have information about the error', () {
      expect(dataSourceException.info, equals(info));
    });
    test('should return the original exception object', () {
      expect(dataSourceException.exception, same(exception));
    });
  });
}
