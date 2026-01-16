class AttendanceRecord {
  final String id;
  final DateTime timestamp;
  final String type; // 'Check In' or 'Check Out'

  AttendanceRecord({
    required this.id,
    required this.timestamp,
    required this.type,
  });
}
