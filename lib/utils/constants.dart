String secondsToHoursMinutes(double seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;

  String formattedTime = '$hours:${minutes.toString().padLeft(2, '0')}';

  return formattedTime;
}

