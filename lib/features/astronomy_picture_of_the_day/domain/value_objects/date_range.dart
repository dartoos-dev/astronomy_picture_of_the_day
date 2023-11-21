import 'package:equatable/equatable.dart';

/// Represents a date range between two [DateTime] values.
///
/// **Precondition**: [start] must be equal to or earlier than [end].
final class DateRange with EquatableMixin {
  /// Sets the start and end values of the date range.
  DateRange({required this.start, required this.end})
      : assert(
          !start.isAfter(end),
          'start must be equal to or earlier than end',
        );

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

  /// Equality by the start and end dates.
  @override
  List<Object?> get props => [start, end];
}
