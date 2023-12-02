import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main constructor', () {
    test('should reject negative values', () {
      expect(() => TotalPictures(-1), throwsA(isA<AssertionError>()));
      expect(() => TotalPictures(-100), throwsA(isA<AssertionError>()));
    });
    test('should define values greater than or equal to 0', () {
      const zero = TotalPictures.zero();
      expect(zero.value, 0);
      const aHundred = TotalPictures(100);
      expect(aHundred.value, 100);
    });
    test('should perform equality by value', () {
      expect(const TotalPictures.zero(), equals(const TotalPictures(0)));
    });
  });
}
