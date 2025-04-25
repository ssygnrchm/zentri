import 'package:flutter/material.dart';
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

  void _handleLogout() async {
    // Get preference handler instance
    final prefHandler = await PreferenceHandler.getInstance();

    // Remove token and user data
    await prefHandler.removeToken();
    await prefHandler.removeUser();

    print('token saat logout: ${prefHandler.getToken()}');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleAbsen() async {
    if (statusAbsen == 'CLOCK IN') {
      // API call for checkin
      // final res = await _repo.checkin(
      //   //getting from geolocator
      // );
    } else {
      // API call for checkout
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

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with menu and app name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: CircleAvatar(backgroundColor: Colors.amber),
                  ),
                  const Text(
                    'Zentri',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: _handleLogout,
                    child: Icon(Icons.logout),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child:
                  _showMap
                      ? LocationMapWidget(onAddressChanged: _updateAddress)
                      : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, $name",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),

                            const Text(
                              "Today's Status",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Not clocked in",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Location display
                            GestureDetector(
                              onTap: _toggleMapView,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF3B82F6),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Current Location',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            currentAddress,
                                            style: TextStyle(fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.map, color: Color(0xFF3B82F6)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Clock in button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed:
                                    _isAbsensiLoading ? null : _handleAbsen,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  statusAbsen,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Work hours
                            const Text(
                              "Work Hours",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "9:00 AM – 5:00 PM",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Bottom navigation buttons
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildNavButton(
                                        Icons.access_time,
                                        'History',
                                      ),
                                      _buildNavButton(
                                        Icons.calendar_month,
                                        'Schedule',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildNavButton(Icons.flight, 'Leave'),
                                      _buildNavButton(Icons.bar_chart, 'Stats'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _showMap
              ? FloatingActionButton(
                onPressed: _toggleMapView,
                child: Icon(Icons.arrow_back),
              )
              : null,
    );
  }

  Widget _buildNavButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(icon, size: 36, color: const Color(0xFF3B82F6)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
