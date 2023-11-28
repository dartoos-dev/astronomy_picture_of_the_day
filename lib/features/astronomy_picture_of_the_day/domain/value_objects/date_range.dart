import 'package:equatable/equatable.dart';

/// Represents a date range between two [DateTime] values.
///
/// **Precondition**: [start] must be equal to or earlier than [end].
final class DateRange with EquatableMixin {
  /// Sets the start and end values of the date range.
  ///
  /// Throws [ArgumentError] is [start] is not equal to or earlier than [end].
  DateRange({required this.start, required this.end}) {
    if (start.isAfter(end)) {
      throw ArgumentError.value(
        'start: ${start.toIso8601String()}; end: ${end.toIso8601String()}',
        'start',
        'start date must be equal to or earlier than end',
      );
    }
  }

  /// A single date; [start] == [end].
  DateRange.single(DateTime date) : this(start: date, end: date);

  /// Date range from start and end string in ISO-8601 format.
  DateRange.parse({
    required String startDateISO8601,
    required String endDateISO8601,
  }) : this(
          start: DateTime.parse(startDateISO8601),
          end: DateTime.parse(endDateISO8601),
        );

  /// The start of the date range.
  final DateTime start;

  /// The end of the date range.
  final DateTime end;

  /// The date part of the start date in ISO-8601 format
  ///
  /// For example:
  ///
  /// ```dart
  ///   final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  ///   final berlinWallFell = DateTime.utc(1989, 11, 9);
  ///   final range = DateRange(start: moonLanding, end: berlinWallFell);
  ///   final isoStartDate = range.startDateIso8601();
  ///   print(isoStartDate); // 1969-07-20
  /// ```
  String get startDateIso8601 => _yearMonthDayIso8601(start);

  /// The date part of the end date in ISO-8601 format
  ///
  /// For example:
  ///
  /// ```dart
  ///   final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  ///   final berlinWallFell = DateTime.utc(1989, 11, 9);
  ///   final range = DateRange(start: moonLanding, end: berlinWallFell);
  ///   final isoEndDate = range.endDateIso8601();
  ///   print(isoEndDate); // 1989-11-09
  /// ```
  String get endDateIso8601 => _yearMonthDayIso8601(end);

  /// Equality by the start and end dates.
  @override
  List<Object?> get props => [start, end];

  String _yearMonthDayIso8601(DateTime dt) {
    final month = dt.month;
    final monthString = month < 10 ? '0$month' : '$month';
    final day = dt.day;
    final dayString = day < 10 ? '0$day' : '$day';
    return '${dt.year}-$monthString-$dayString';
  }
}
