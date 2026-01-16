import '../models/attendance_record.dart';

class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal();

  final List<AttendanceRecord> _records = [
    // Add some dummy data for history
    AttendanceRecord(
      id: '1',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
      type: 'Check In',
    ),
    AttendanceRecord(
      id: '2',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      type: 'Check Out',
    ),
  ];

  List<AttendanceRecord> getRecords() {
    return List.from(_records.reversed); // Newest first
  }

  Future<void> addRecord(String type) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _records.add(AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
    ));
  }
  
  bool isCheckedIn() {
    if (_records.isEmpty) return false;
    // Find the last record for today
    final today = DateTime.now();
    final todayRecords = _records.where((r) => 
      r.timestamp.year == today.year && 
      r.timestamp.month == today.month && 
      r.timestamp.day == today.day
    ).toList();
    
    if (todayRecords.isEmpty) return false;
    return todayRecords.last.type == 'Check In';
  }
}
