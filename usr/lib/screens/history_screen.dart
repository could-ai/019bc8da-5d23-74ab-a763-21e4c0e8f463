import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mock_service.dart';
import '../models/attendance_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final MockService _service = MockService();
  List<AttendanceRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _records = _service.getRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Refresh records when building to ensure latest data
    _records = _service.getRecords();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: _records.isEmpty
          ? const Center(child: Text('No records found'))
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                final isCheckIn = record.type == 'Check In';
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCheckIn ? Colors.blue.shade100 : Colors.orange.shade100,
                      child: Icon(
                        isCheckIn ? Icons.login : Icons.logout,
                        color: isCheckIn ? Colors.blue : Colors.orange,
                      ),
                    ),
                    title: Text(
                      record.type,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('MMM d, yyyy').format(record.timestamp),
                    ),
                    trailing: Text(
                      DateFormat('HH:mm').format(record.timestamp),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
