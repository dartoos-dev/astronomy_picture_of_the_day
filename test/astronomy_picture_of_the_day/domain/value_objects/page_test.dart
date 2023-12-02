import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main constructor', () {
    test('should reject values that are lesser than 1', () {
      expect(() => Page(0), throwsA(isA<AssertionError>()));
      expect(() => Page(-1), throwsA(isA<AssertionError>()));
    });
    test('should define values greater than or equal to 1', () {
      const page1 = Page(1);
      expect(page1.value, 1);
    });
    test('should perform equality by value', () {
      expect(const Page.first(), equals(const Page(1)));
    });
    test(
        '">" operator should return true only if the first page is greater than the second one',
        () {
      const page20 = Page(20);
      const page10 = Page(10);
      expect(page20 > page10, true);
      expect(page20 > page20, false);
      expect(page10 > page20, false);
    });
  });
  group('"last" constructor', () {
    test('should correctly calculate the last page', () {
      final last = Page.last(const TotalPictures(10), const PicturesPerPage(3));
      expect(last, equals(const Page(4)));
    });
  });
}
