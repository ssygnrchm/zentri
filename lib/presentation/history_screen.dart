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

  // Date range for filtering
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Set default date range to one month
    _endDate = DateTime.now();
    _startDate = DateTime(_endDate.year, _endDate.month - 1, _endDate.day);
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate);

      final AbsensiResponse response = await _absensiRepo.getHistory(
        startDate: formattedStartDate,
        endDate: formattedEndDate,
      );

      setState(() {
        _isLoading = false;
        if (response.data != null) {
          final dataList = response.getDataList();
          if (dataList != null) {
            _attendanceList = dataList;
            // Sort by check-in date in descending order (newest first)
            _attendanceList.sort((a, b) => b.checkIn.compareTo(a.checkIn));
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

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
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
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Column(
        children: [_buildDateRangeHeader(), Expanded(child: _buildBody())],
      ),
    );
  }

  Widget _buildDateRangeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Date Range: ${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton.icon(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.filter_alt),
            label: const Text('Filter'),
          ),
        ],
      ),
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
              'No attendance records found for the selected date range.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: const Text('Change Date Range'),
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
                  'Date: ${DateFormat('EEE, MMM dd, yyyy').format(attendance.checkIn)}',
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
