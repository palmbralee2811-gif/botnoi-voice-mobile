// ชื่อไฟล์: point_calculator.dart

class PointCalculator {
  // กำหนดอัตราแลกเปลี่ยน: 1 วินาที = 5 points
  static const int _pointsPerSecond = 5;

  static int calculateTotalPoints(Duration? duration) {
    if (duration == null) {
      return 0;
    }
    // คำนวณโดยเอาจำนวนวินาทีทั้งหมด x 5
    return duration.inSeconds * _pointsPerSecond;
  }
}