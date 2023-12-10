import 'package:astronomy_picture_of_the_day/shared/value_objects/id.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class GenericType {}

class Type1 extends GenericType {}

class Type2 extends GenericType {}

void main() {
  const value1 = "value1";
  const value2 = "value2";
  group('ID:', () {
    test('two IDs of the same type and value should be equal', () {
      const id1 = ID<Type1>(value1);
      const id2 = ID<Type1>(value1);
      expect(id1, id2);
    });
    test('two IDs of the same type and differente values should not be equal',
        () {
      const id1 = ID<Type1>(value1);
      const id2 = ID<Type1>(value2);
      assert(id1 != id2);
    });
    test('two IDs of same value but different types should not be equal', () {
      const id1 = ID<Type1>(value1);
      const id2 = ID<Type2>(value1);
      const idGeneric = ID<GenericType>(value1);
      assert(id1 != id2);
      assert(id1 != idGeneric);
    });
    test('the method "toString" should be equivalent to calling "value"', () {
      const id1 = ID<Type1>(value1);
      expect(id1.toString(), id1.value);
    });
    test('"urlSafe" constructor should produce an url-safe id', () {
      final urlSafeTimestamp = ID<Type1>.urlSafe('2023-11-20 11:35:22');
      expect(urlSafeTimestamp.value, '2023-11-20%2011:35:22');
      final urlSafeName = ID<Type1>.urlSafe('François');
      expect(urlSafeName.value, 'Fran%C3%A7ois');
    });

    test('"sha256" constructor should produce SHA256-encoded ids', () {
      final sha256Empty = ID<Type1>.sha256('');
      expect(
        sha256Empty.value,
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      final sha256Sentence =
          ID<Type1>.sha256('The quick brown fox jumps over the lazy dog.');
      expect(
        sha256Sentence.value,
        'ef537f25c895bfa782526529a9b63d97aa631564d5d789c2b765448c8635fb6c',
      );
      final sha256DateIso8601 = ID<Type1>.sha256('2023-11-20');
      expect(
        sha256DateIso8601.value,
        '45373a26a1a0af22c988f5e208af4239159019c334ee269af76969251fd37c9e',
      );
    });
    test('the natural ordering should be ascending by the ID value', () {
      const id1 = ID("AAAAA");
      const id2 = ID("BBBBB");
      const id3 = ID("CCCCC");
      const id4 = ID("DDDDD");
      const id5 = ID("EEEEE");
      final ids = [id5, id3, id4, id1, id2]..sort();
      expect(ids, equals([id1, id2, id3, id4, id5]));
    });
  });
}
