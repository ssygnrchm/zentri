import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zentri/absensi/model/absensi_model.dart';
import 'package:zentri/repository/absensi_repo.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final AbsensiRepo _absensiRepo = AbsensiRepo();
  bool _isLoading = true;
  String _errorMessage = '';
  List<AbsensiData> _attendanceList = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final AbsensiResponse response = await _absensiRepo.getHistory(
        startDate: formattedDate,
        endDate: formattedDate,
      );

      setState(() {
        _isLoading = false;
        if (response.data != null) {
          final dataList = response.getDataList();
          if (dataList != null) {
            _attendanceList = dataList;
          } else {
            // Handle single data case
            final singleData = response.getSingleData();
            if (singleData != null) {
              _attendanceList = [singleData];
            } else {
              _attendanceList = [];
            }
          }
        } else {
          _errorMessage = response.message;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load attendance data: $e';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAttendanceData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAttendanceData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_attendanceList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No attendance records found for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Different Date'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAttendanceData,
      child: ListView.builder(
        itemCount: _attendanceList.length,
        itemBuilder: (context, index) {
          final attendance = _attendanceList[index];
          return AttendanceCard(attendance: attendance);
        },
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final AbsensiData attendance;

  const AttendanceCard({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm:ss');
    final fullDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(attendance.checkIn)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(attendance.status),
              ],
            ),
            const Divider(),
            _buildInfoRow(
              'Check-in Time',
              dateFormat.format(attendance.checkIn),
            ),
            _buildInfoRow('Check-in Location', attendance.checkInAddress),

            if (attendance.status == 'izin' && attendance.alasanIzin != null)
              _buildInfoRow('Reason', attendance.alasanIzin!),

            if (attendance.checkOut != null) ...[
              const Divider(),
              _buildInfoRow(
                'Check-out Time',
                dateFormat.format(attendance.checkOut!),
              ),
              _buildInfoRow(
                'Check-out Location',
                attendance.checkOutAddress ?? 'N/A',
              ),
              _buildInfoRow(
                'Duration',
                _calculateDuration(attendance.checkIn, attendance.checkOut!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String label;

    switch (status.toLowerCase()) {
      case 'hadir':
        chipColor = Colors.green;
        label = 'Present';
        break;
      case 'izin':
        chipColor = Colors.orange;
        label = 'Leave';
        break;
      case 'sakit':
        chipColor = Colors.red;
        label = 'Sick';
        break;
      default:
        chipColor = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime checkIn, DateTime checkOut) {
    final difference = checkOut.difference(checkIn);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours hours $minutes minutes';
  }
}
