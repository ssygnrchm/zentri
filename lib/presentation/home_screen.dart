import 'package:flutter/material.dart';
import 'package:zentri/services/pref_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getName() async {
    String? name = await PreferenceHandler.getUserName();
    return name;
  }

  void _handleLogout() {
    PreferenceHandler.removeToken();
    print('token saat logout: ${PreferenceHandler.getToken().toString()}');
    PreferenceHandler.removeUserData();
    Navigator.pushReplacementNamed(context, '/login');
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
                    onTap: () {
                      _handleLogout();
                    },
                    child: Icon(Icons.logout),
                  ), // For balance
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${getName()}",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),

                    const Text(
                      "Today's Status",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
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

                    // Clock in button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'CLOCK IN',
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
                      style: TextStyle(fontSize: 20, color: Colors.black54),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavButton(Icons.access_time, 'History'),
                              _buildNavButton(Icons.calendar_month, 'Schedule'),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
