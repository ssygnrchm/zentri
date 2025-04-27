import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zentri/repository/absensi_repo.dart';
import 'package:zentri/services/pref_handler.dart';
import 'package:zentri/presentation/widget/location_map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String statusAbsen = 'CLOCK IN';
  String currentAddress = 'Determining location...';
  final AbsensiRepo _repo = AbsensiRepo();
  bool _isAbsensiLoading = false;
  bool _showMap = false;

  // For clock display
  late DateTime _currentTime;
  late DateTime _date;
  String _clockInTime = '-- : --';
  String _clockOutTime = '-- : --';
  bool _isClockedIn = false;
  late Timer _timer;

  void _handleLogout() async {
    // Get preference handler instance
    final prefHandler = await PreferenceHandler.getInstance();

    // Remove token and user data
    await prefHandler.removeToken();
    await prefHandler.removeUser();

    // print('token saat logout: ${prefHandler.getToken()}');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleAbsen() async {
    try {
      if (statusAbsen == 'CLOCK IN') {
        setState(() {
          _clockInTime = DateFormat('h:mm a').format(_currentTime);
          _isClockedIn = true;
          statusAbsen = 'CLOCK OUT';
        });

        // API call for checkin
        // final res = await _repo.checkin(
        //   //getting from geolocator
        // );
      } else {
        // Set clock out time
        setState(() {
          _clockOutTime = DateFormat('h:mm a').format(_currentTime);
          _isClockedIn = false;
          statusAbsen = 'CLOCK IN';
        });
        // API call for checkout
      }
    } catch (e) {
      // Handle error
      print('Error during clock in/out: $e');
    } finally {
      setState(() {
        _isAbsensiLoading = false;
      });
    }
  }

  void _updateAddress(String address) {
    setState(() {
      currentAddress = address;
    });
  }

  void _toggleMapView() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  // Example of updating the _loadUserData method
  void _loadUserData() async {
    // Get preference handler instance
    final prefHandler = await PreferenceHandler.getInstance();

    // Get user name
    final fetchedName = prefHandler.getName();

    setState(() {
      name = fetchedName ?? '';
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  bool isWithinWorkingHours() {
    int hour = _currentTime.hour;
    return hour >= 9 && hour < 17;
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
    _currentTime = DateTime.now();
    _date = DateTime.now();

    // Set up timer for updating the current time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with app name and logout
            _buildHeader(),

            // Main content
            Expanded(
              child:
                  _showMap
                      ? LocationMapWidget(onAddressChanged: _updateAddress)
                      : _buildMainContent(),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _showMap
              ? FloatingActionButton(
                onPressed: _toggleMapView,
                backgroundColor: const Color(0xFF3B82F6),
                child: const Icon(Icons.arrow_back),
              )
              : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "Z",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Zentri',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: _handleLogout,
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome and date/time section
          _buildWelcomeSection(),
          const SizedBox(height: 24),

          // Location section
          _buildLocationSection(),
          const SizedBox(height: 24),

          // Attendance section
          _buildAttendanceSection(),
          const SizedBox(height: 32),

          // Work hours section
          _buildWorkHoursSection(),
          const SizedBox(height: 32),

          // Bottom navigation buttons
          _buildNavButtons(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $name",
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Text(
                    _isClockedIn ? "Currently Working" : "Not clocked in",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      isWithinWorkingHours()
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isWithinWorkingHours() ? "Working Hours" : "Outside Hours",
                  style: TextStyle(
                    color:
                        isWithinWorkingHours()
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(_date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Current Time',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    DateFormat('h:mm:ss a').format(_currentTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return GestureDetector(
      onTap: _toggleMapView,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF3B82F6), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Location',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentAddress,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.map, color: Color(0xFF3B82F6)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clock In',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    _clockInTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Clock Out',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    _clockOutTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _isAbsensiLoading ? null : _handleAbsen,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isClockedIn
                        ? Colors.red.shade600
                        : const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child:
                  _isAbsensiLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        statusAbsen,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkHoursSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Work Hours",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: double.infinity, height: 8),
          Text(
            "9:00 AM – 5:00 PM",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.access_time, 'History'),
            _buildNavButton(Icons.calendar_month, 'Schedule'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.flight, 'Leave'),
            _buildNavButton(Icons.bar_chart, 'Stats'),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, String label) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: const Color(0xFF3B82F6)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
