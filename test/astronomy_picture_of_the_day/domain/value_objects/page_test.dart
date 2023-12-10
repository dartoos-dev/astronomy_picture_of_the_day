import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/pictures_per_page.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/total_pictures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Page', () {
    test('should reject negative values', () {
      expect(() => Page(-1), throwsA(isA<AssertionError>()));
    });
    test('should perform equality by value', () {
      expect(const Page.first(), equals(const Page(1)));
    });
    test('">" should be true if the first is greater than second', () {
      const page1 = Page(1);
      const page2 = Page(2);
      expect(page2 > page1, true);
      expect(page1 > page1, false);
      expect(page1 > page2, false);
    });
    test('">=" should be true if first is greater than or equal to second', () {
      const page20 = Page(20);
      const page10 = Page(10);
      expect(page20 >= page10, true);
      expect(page20 >= page20, true);
      expect(page10 >= page20, false);
    });
    test('should perform equality by value', () {
      expect(const Page.first(), equals(const Page(1)));
    });
  });
  group('"zero" — no page — constructor', () {
    test('should set the page value to 0', () {
      const page1 = Page.zero();
      expect(page1.value, 0);
    });
  });
  group('"first" constructor', () {
    test('should set the page value to 1', () {
      const page1 = Page.first();
      expect(page1.value, 1);
    });
  });
  group('"last" constructor', () {
    test('should correctly calculate the last page', () {
      final last = Page.last(const TotalPictures(10), const PicturesPerPage(3));
      expect(last, equals(const Page(4)));
    });
    test('should set the last page to zero when total is zero', () {
      final last =
          Page.last(const TotalPictures.zero(), const PicturesPerPage(3));
      expect(last, equals(const Page.zero()));
    });
  });
  group('"offset" method', () {
    const fourPerPage = PicturesPerPage(4);
    test('given 4 pictures per page, should calculate zero for the first page',
        () {
      const first = Page.first();
      expect(first.offset(fourPerPage), 0);
    });
    test('given 4 pictures per page, should calculate 4 for the second page',
        () {
      const second = Page(2);
      expect(second.offset(fourPerPage), 4);
    });
    test('given 4 pictures per page, should calculate 8 for the third page',
        () {
      const third = Page(3);
      expect(third.offset(fourPerPage), 8);
    });
    test('if page is < 1, should return 0 regardless of the per page value',
        () {
      const noPage = Page.zero();
      expect(noPage.offset(fourPerPage), 0);
    });
  });
}
