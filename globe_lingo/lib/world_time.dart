import 'package:flutter/material.dart';
import 'dart:async'; // Needed for the ticking timer
import 'package:intl/intl.dart'; // Needed to format the time nicely

class WorldTimeScreen extends StatefulWidget {
  const WorldTimeScreen({super.key});

  @override
  State<WorldTimeScreen> createState() => _WorldTimeScreenState();
}

class _WorldTimeScreenState extends State<WorldTimeScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  // List of Cities and their offsets from UTC (Universal Time)
  final List<Map<String, dynamic>> locations = [
    {'city': 'New York', 'offset': -5, 'flag': '🇺🇸'},
    {'city': 'London', 'offset': 0, 'flag': '🇬🇧'},
    {'city': 'Paris', 'offset': 1, 'flag': '🇫🇷'},
    {'city': 'Dubai', 'offset': 4, 'flag': '🇦🇪'},
    {'city': 'Islamabad', 'offset': 5, 'flag': '🇵🇰'},
    {'city': 'Beijing', 'offset': 8, 'flag': '🇨🇳'},
    {'city': 'Tokyo', 'offset': 9, 'flag': '🇯🇵'},
    {'city': 'Sydney', 'offset': 11, 'flag': '🇦🇺'},
  ];

  @override
  void initState() {
    super.initState();
    // Start a timer that updates the clock every single second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when we leave the screen
    super.dispose();
  }

  // Helper function to calculate time for a specific city
  String _getTimeForCity(int offset) {
    // 1. Get current UTC time
    DateTime utcNow = DateTime.now().toUtc();
    // 2. Add the hours for that city
    DateTime cityTime = utcNow.add(Duration(hours: offset));
    // 3. Format it beautifully (e.g., "10:30:45 AM")
    return DateFormat('h:mm:ss a').format(cityTime);
  }
  
  // Helper to get the date (e.g., "Mon, Dec 12")
  String _getDateForCity(int offset) {
    DateTime utcNow = DateTime.now().toUtc();
    DateTime cityTime = utcNow.add(Duration(hours: offset));
    return DateFormat('EEE, MMM d').format(cityTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Time (Live)'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side: Flag and City
                  Row(
                    children: [
                      Text(location['flag'], style: const TextStyle(fontSize: 30)),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['city'],
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black87
                            ),
                          ),
                          Text(
                            _getDateForCity(location['offset']),
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right Side: The Ticking Time
                  Text(
                    _getTimeForCity(location['offset']),
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.purple
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}