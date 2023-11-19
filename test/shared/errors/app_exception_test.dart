import 'package:astronomy_picture_of_the_day/shared/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException:', () {
    const info = 'Additional info';
    final exception = Exception('Original Exception');
    final appException = AppException(info, exception: exception);
    test('should be a subclass of "Exception"', () {
      expect(appException, isA<Exception>());
    });
    test('should have information about the error', () {
      expect(appException.info, equals(info));
    });
    test('should return the original exception object', () {
      expect(appException.exception, same(exception));
    });
    test('"toString" should return the same as "info"', () {
      const appException = AppException(info);
      expect(appException.toString(), info);
    });
    test('"toString" should return "info" along with the exception message',
        () {
      final ex = Exception('Texto de teste');
      final appException = AppException(info, exception: ex);
      expect(appException.toString(), '$info\n$ex');
    });
  });
}
