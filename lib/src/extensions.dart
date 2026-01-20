import 'package:google_places_sdk_plus/google_places_sdk_plus.dart';

extension SpecialDayExtension on SpecialDay {
  DateTime get date => DateTime.parse(stringDate);
}

extension LegExtension on Leg {
  Duration get duration => Duration(seconds: durationSeconds);
}
