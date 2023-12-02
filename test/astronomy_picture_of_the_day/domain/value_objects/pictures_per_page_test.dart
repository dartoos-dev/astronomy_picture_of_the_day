import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main constructor', () {
    test('should reject values that are lesser than 1', () {
      expect(() => PicturesPerPage(0), throwsA(isA<AssertionError>()));
      expect(() => PicturesPerPage(-1), throwsA(isA<AssertionError>()));
    });
    test('should define values greater than or equal to 1', () {
      const onePicturePerPage = PicturesPerPage(1);
      expect(onePicturePerPage.value, 1);
      const aHundredPicturesPerPage = PicturesPerPage(100);
      expect(aHundredPicturesPerPage.value, 100);
    });
    test('should perform equality by value', () {
      expect(const PicturesPerPage.seven(), equals(const PicturesPerPage(7)));
    });
  });
}
