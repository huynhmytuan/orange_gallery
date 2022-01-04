import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String formatDuration(int duration) {
    NumberFormat formatter = NumberFormat("00");
    if (duration >= 3600) {
      int hours = duration ~/ 3600;
      int mins = (duration - (hours * 3600)) ~/ 60;
      int seconds = (duration - (hours * 3600) - (mins * 60)).toInt();
      return '${formatter.format(hours.round())}:${formatter.format(mins.round())}:${formatter.format(seconds.round())}';
    } else {
      int mins = duration ~/ 60;
      int seconds = (duration - (mins * 60)).toInt();
      return '${formatter.format(mins.round())}:${formatter.format(seconds.round())}';
    }
  }
}
