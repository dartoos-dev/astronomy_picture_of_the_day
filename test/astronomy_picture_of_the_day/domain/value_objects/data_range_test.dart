import 'package:astronomy_picture_of_the_day/features/astronomy_picture_of_the_day/domain/value_objects/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main constructor', () {
    test('should assert that the end date is not earlier than the start date',
        () {
      final earlierEndDate = DateTime.parse('2023-11-20');
      final startDate = DateTime.parse('2023-11-21');
      expect(
        () => DateRange(start: startDate, end: earlierEndDate),
        throwsA(isA<ArgumentError>()),
      );
    });
    test('should allow the same start and end date', () {
      final now = DateTime.now();
      final nowDateRange = DateRange(start: now, end: now);
      expect(nowDateRange.start, equals(now));
      expect(nowDateRange.end, equals(now));
    });
    test('should keep the valid dates as they are', () {
      final startDate = DateTime.parse('2022-11-20');
      final endDate = DateTime.parse('2023-11-20');
      final dateRange = DateRange(start: startDate, end: endDate);
      expect(dateRange.start, equals(startDate));
      expect(dateRange.end, equals(endDate));
    });
    test('should correctly calculate the range of few days', () {
      final startDate = DateTime.parse('2023-11-21');
      final endDate = DateTime.parse('2023-11-26');
      final dateRange = DateRange(start: startDate, end: endDate);
      expect(dateRange.days, 6);
    });
    test('should correctly calculate the days of one year interval', () {
      final startDate = DateTime.parse('2023-01-01');
      final endDate = DateTime.parse('2023-12-31');
      final dateRange = DateRange(start: startDate, end: endDate);
      expect(dateRange.days, 365);
    });
  });

  group('"single" constructor', () {
    test('should set both the start and end date to the same value', () {
      final now = DateTime.now();
      final singleDateRange = DateRange.single(now);
      expect(singleDateRange.start, equals(singleDateRange.end));
    });
    test('should calculate the number of days represented by the date range',
        () {
      final now = DateTime.now();
      final singleDateRange = DateRange.single(now);
      expect(singleDateRange.days, 1);
    });
  });
  group('"parse" constructor', () {
    test('should parse the string data and set the dates accordingly', () {
      const date1 = "2023-11-20";
      const date2 = "2023-11-21";
      final parsedDateRange =
          DateRange.parse(startDateISO8601: date1, endDateISO8601: date2);
      expect(parsedDateRange.start, equals(DateTime.parse(date1)));
      expect(parsedDateRange.end, equals(DateTime.parse(date2)));
    });
  });
  group('methods "toIso8601"', () {
    test('should return dates in "YYYY-MM-DD" format', () {
      final dateTime1 = DateTime.parse("2022-12-31T23:59:59");
      final dateTime2 = DateTime.parse("2023-01-01T00:00:00");
      final dateRange = DateRange(start: dateTime1, end: dateTime2);
      expect(dateRange.startDateIso8601, equals('2022-12-31'));
      expect(dateRange.endDateIso8601, equals('2023-01-01'));
    });
    test('should concatenate a "0" to one-digit months and days', () {
      final startOneDigitMonthAndDayDate = DateTime.parse("2023-01-01");
      final endOneDigitMonthAndDayDate = DateTime.parse("2023-09-09");
      final dateRange = DateRange(
        start: startOneDigitMonthAndDayDate,
        end: endOneDigitMonthAndDayDate,
      );
      expect(dateRange.startDateIso8601, equals('2023-01-01'));
      expect(dateRange.endDateIso8601, equals('2023-09-09'));
    });
    test('should not concatenate a "0" to two-digit months and days', () {
      final startTwoDigitMonthAndDayDate = DateTime.parse("2023-10-10");
      final endTwoDigitMonthAndDayDate = DateTime.parse("2023-12-25");
      final dateRange = DateRange(
        start: startTwoDigitMonthAndDayDate,
        end: endTwoDigitMonthAndDayDate,
      );
      expect(dateRange.startDateIso8601, equals('2023-10-10'));
      expect(dateRange.endDateIso8601, equals('2023-12-25'));
    });
  });

  group('equality operator "=="', () {
    test(
        '"props" method should return a list containing the start and end dates',
        () {
      final startDate = DateTime.parse("2023-11-20");
      final endDate = DateTime.parse("2023-11-25");
      final dateRange = DateRange(
        start: startDate,
        end: endDate,
      );
      expect(dateRange.props, equals([startDate, endDate]));
    });
    test(
        'should evaluate to true the comparison between two date ranges that have the same start and end values',
        () {
      final startDate = DateTime.parse("2023-10-10");
      final endDate = DateTime.parse("2023-12-25");
      final dateRange1 = DateRange(
        start: startDate,
        end: endDate,
      );
      final dateRange2 = DateRange(
        start: startDate,
        end: endDate,
      );
      expect(dateRange1 == dateRange2, true);
    });
    test(
        'should evaluate to false the comparison between two date ranges that have different start or end values',
        () {
      final startDate = DateTime.parse("2023-10-10");
      final endDate = DateTime.parse("2023-12-25");
      final dateRange1 = DateRange(
        start: startDate,
        end: endDate,
      );
      final dateRange2 = DateRange(
        start: startDate,
        end: endDate.add(const Duration(days: 1)),
      );
      expect(dateRange1 == dateRange2, false);
    });
  });
}
