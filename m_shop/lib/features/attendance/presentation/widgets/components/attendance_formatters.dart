int? timeToMinutes(String time) {
  if (time == '-' || time.contains(':') == false) {
    return null;
  }

  final parts = time.split(':');
  final hour = int.tryParse(parts.first);
  final minute = int.tryParse(parts.last);
  if (hour == null || minute == null) {
    return null;
  }
  return (hour * 60) + minute;
}

String formatAttendanceMoney(num value) {
  final negative = value < 0;
  final rounded = value.abs().round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write(',');
    }
  }

  final result = '${buffer.toString()} ج.م';
  return negative ? '-$result' : result;
}

String formatAttendanceHours(double hours) {
  if (hours == hours.roundToDouble()) {
    return '${hours.round()} س';
  }
  return '${hours.toStringAsFixed(1)} س';
}

String formatAttendanceMinutes(int minutes) {
  if (minutes <= 0) {
    return '0 د';
  }
  return '$minutes د';
}
