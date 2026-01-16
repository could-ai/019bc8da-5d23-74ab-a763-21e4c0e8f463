import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mock_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  final MockService _service = MockService();
  bool _isCheckedIn = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _checkStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _currentTime = DateTime.now();
      });
    }
  }

  void _checkStatus() {
    setState(() {
      _isCheckedIn = _service.isCheckedIn();
    });
  }

  Future<void> _handleClockAction() async {
    setState(() {
      _isLoading = true;
    });

    final type = _isCheckedIn ? 'Check Out' : 'Check In';
    await _service.addRecord(type);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _checkStatus();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully $type!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm:ss');
    final dateFormat = DateFormat('EEEE, MMMM d, y');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Date and Time Display
          Text(
            dateFormat.format(_currentTime),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            timeFormat.format(_currentTime),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          const Spacer(),
          
          // Clock In/Out Button
          Center(
            child: GestureDetector(
              onTap: _isLoading ? null : _handleClockAction,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isCheckedIn
                        ? [Colors.orange.shade300, Colors.orange.shade700]
                        : [Colors.blue.shade300, Colors.blue.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_isCheckedIn ? Colors.orange : Colors.blue).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isCheckedIn ? Icons.logout : Icons.login,
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _isCheckedIn ? 'Clock Out' : 'Clock In',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 16,
                  color: _isCheckedIn ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  _isCheckedIn ? 'Currently Working' : 'Not Working',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
