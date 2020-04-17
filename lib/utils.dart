import 'package:flutter/foundation.dart';

class Utils {
  static bool get isRelease {
    return kReleaseMode;
  }

  static bool get isDebug {
    return !isRelease;
  }

  static String formatDuration(DateTime start, DateTime end) {
    if (start == null) return "";
    if (end == null) end = DateTime.now();
    Duration duration = Duration(
        milliseconds:
            end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
    return [duration.inHours, duration.inMinutes]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}
